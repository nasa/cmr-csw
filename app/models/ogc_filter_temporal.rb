class OgcFilterTemporal
  # since temporal requires special processing, we cannot  use the OgcFilterHelper
  # CMR temporal query syntax
  # 2000-01-01T10:00:00Z, means AFTER, so does ISO 2000-01-01T10:00:00Z/
  # ,2010-03-10T12:00:00Z means BEFORE, so does ISO /2010-03-10T12:00:00Z
  # 2000-01-01T10:00:00Z,2010-03-10T12:00:00Z means BETWEEN, so does ISO 2000-01-01T10:00:00Z/2010-03-10T12:00:00Z
  # For temporal range search, the default is inclusive on the range boundaries. This can be changed by specifying
  # exclude_boundary option with options[temporal][exclude_boundary]=true. This option has no impact on periodic
  # temporal searches, which CMR CSW will not support initially.
  # The CSW temporal extents are expressed in DateTime 8601
  def process(ogc_filter)
    cmr_query_hash = {}
    cmr_temporal_param = ISO_QUERYABLES_TO_CMR_QUERYABLES["TempExtent_begin"][1] # same CMR mapping exists for TempExtent_end
    time_start_params = extract_operand_filter_data("TempExtent_begin", ogc_filter)
    time_end_params = extract_operand_filter_data("TempExtent_end", ogc_filter)
    temporal_query_string = nil
    if (time_start_params.size == 2)
      temporal_query_string = process_start_temporal(time_start_params)
    end
    if (time_end_params.size == 2)
      temporal_query_string = process_end_temporal(time_end_params, temporal_query_string)
    end
    if (temporal_query_string != nil)
      cmr_query_hash["#{cmr_temporal_param}"] = temporal_query_string
    end
    cmr_query_hash
  end

  private
  SUPPORTED_TEMPORAL_OPERATORS = %w(PropertyIsGreaterThanOrEqualTo PropertyIsGreaterThan PropertyIsLessThanOrEqualTo PropertyIsLess)
  # the property_name is the string that we are interested in (AnyText, TempExtent_begin, TempExtent_end etc.)
  # assume that there is just ONE property_name node that we are operating on
  def extract_operand_filter_data(property_name, ogc_filter)
    filter_data = {}
    property_name_xpath = "//ogc:PropertyName[contains(text(), '#{property_name}')]"
    property_name_node_set = ogc_filter.xpath(property_name_xpath, 'ogc' => 'http://www.opengis.net/ogc')
    if (property_name_node_set != nil && property_name_node_set[0] != nil)
      property_literal_node = property_name_node_set[0].next_element
      property_parent_operator_node = property_name_node_set[0].parent
      if (property_literal_node != nil)
        filter_data[:literal_value] = property_literal_node.text
      end
      if (property_parent_operator_node != nil)
        filter_data[:operator] = property_parent_operator_node.name
      end
    end
    filter_data
  end

  def process_start_temporal(time_start_hash)
    query_string = nil
    begin_value = time_start_hash[:literal_value]
    OgcFilterTemporal.validate_iso_date_time('TempExtent_begin', begin_value)
    operator = time_start_hash[:operator]
    case operator
      when "PropertyIsGreaterThanOrEqualTo"
        query_string = "#{begin_value}/"
      when "PropertyIsGreaterThan"
        # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
        # boundary exlcusion applies to ALL temporal query components
        query_string = "#{begin_value}/"
      when "PropertyIsLessThanOrEqualTo"
        query_string = "/#{begin_value}"
      when "PropertyIsLessThan"
        # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
        # boundary exlcusion applies to ALL temporal query components
        query_string = "/#{begin_value}"
      else
        error_message = "OgcFilterTemporal.process_start_temporal: invalid operator value #{operator} for TempExtent_begin"
        Rails.logger.error(error_message)
        # use 'None' instead of ommiting the locator
        raise OwsException.new('None', error_message)
    end
    query_string
  end

  def process_end_temporal(time_end_hash, query_string)
    end_value = time_end_hash[:literal_value]
    OgcFilterTemporal.validate_iso_date_time('TempExtent_end', end_value)
    operator = time_end_hash[:operator]
    if (query_string == nil)
      # we have no TempExtent_begin queryable
      case operator
        when 'PropertyIsGreaterThanOrEqualTo'
          query_string = "#{end_value}/"
        when 'PropertyIsGreaterThan'
          # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
          # boundary exlcusion applies to ALL temporal query components
          query_string = "#{end_value}/"
        when 'PropertyIsLessThanOrEqualTo'
          query_string = "/#{end_value}"
        when 'PropertyIsLessThan'
          # TODO modify when CMR supports boundary exclusion for individual temporal query component, currently the
          # boundary exlcusion applies to ALL temporal query components
          query_string = "/#{end_value}"
        else
          Rails.logger.error("OgcFilterTemporal.process_end_temporal: invalid operator value #{operator}")
          # use 'None' instead of ommiting the locator
          raise OwsException.new('TempExtent_end', "Invalid operator '#{operator}' for TempExtent_end")
      end
    else
      # we already have a TempExtent_begin queryable
      begin_temporal_after_operator = query_string.last == '/' ? true : false
      begin_temporal_before_operator = query_string.first == '/' ? true : false
      case operator
        when "PropertyIsGreaterThanOrEqualTo"
          if begin_temporal_after_operator
            # begin is AFTER, end is AFTER, need begin is AFTER, end is BEFORE
            error_message = "OgcFilterTemporal.process_end_temporal (A AFTER/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('None', error_message)
          else
            # begin is BEFORE, end is AFTER
            error_message = "OgcFilterTemporal.process_end_temporal (B BEFORE/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('None', error_message)
          end
        when "PropertyIsGreaterThan"
          if begin_temporal_after_operator
            # begin is AFTER, end is AFTER, need begin is AFTER, end is BEFORE
            error_message = "OgcFilterTemporal.process_end_temporal (C AFTER/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('None', error_message)
          else
            # begin is BEFORE, end is AFTER
            error_message = "OgcFilterTemporal.process_end_temporal (C BEFORE/AFTER): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('None', error_message)
          end
        when "PropertyIsLessThanOrEqualTo"
          if begin_temporal_after_operator
            # begin is AFTER, end is BEFORE OK
            begin_date = DateTime.parse(query_string.gsub('/',''))
            end_date = DateTime.parse(end_value)
            if(begin_date < end_date)
              query_string = query_string + end_value
            else
              error_message = "OgcFilterTemporal.process_end_temporal: TempExtent_begin date #{begin_date} must be before the " +
                  "TempExtent_end date #{end_date}"
              Rails.logger.error(error_message)
              # use 'None' instead of ommiting the locator
              raise OwsException.new('None', error_message)
            end
          else
            # begin is BEFORE, end is BEFORE
            error_message = "OgcFilterTemporal.process_end_temporal (E BEFORE/BEFORE): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('None', error_message)
          end
        when "PropertyIsLessThan"
          if begin_temporal_after_operator
            # begin is AFTER, end is BEFORE OK
            begin_date = DateTime.parse(query_string.gsub('/',''))
            end_date = DateTime.parse(end_value)
            if(begin_date < end_date)
              query_string = query_string + end_value
            else
              error_message = "OgcFilterTemporal.process_end_temporal: TempExtent_begin date #{begin_date} must be before the " +
                  "TempExtent_end date #{end_date}"
              Rails.logger.error(error_message)
              # use 'None' instead of ommiting the locator
              raise OwsException.new('None', error_message)
            end
          else
            # begin is BEFORE, end is BEFORE
            error_message = "OgcFilterTemporal.process_end_temporal (F BEFORE/BEFORE): PropertyIsGreaterThanOrEqualTo OR PropertyIsGreaterThan for " +
                "TempExtent_begin can only be combined with PropertyIsLessThanOrEqualTo OR " +
                "PropertyIsGreaterThan for TempExtent_end"
            Rails.logger.error(error_message)
            # use 'None' instead of ommiting the locator
            raise OwsException.new('None', error_message)
          end
        else
          error_message = "OgcFilterTemporal.process_end_temporal: invalid operator value #{operator} for TempExtent_end"
          Rails.logger.error(error_message)
          # use 'None' instead of ommiting the locator
          raise OwsException.new('None', error_message)
      end
    end
    query_string
  end

  def self.validate_iso_date_time(id, date_string)
    begin
      # DateTime.parse(date).iso8601 is too lax, we must enforce CMR ISO 8601 format 2016-09-06T23:59:59Z
      d = DateTime.strptime(date_string, '%Y-%m-%dT%H:%M:%SZ')
    rescue ArgumentError => e
      raise OwsException.new(id, "'#{date_string}' is NOT in the supported ISO8601 format yyyy-MM-ddTHH:mm:ssZ")
    end
  end
end