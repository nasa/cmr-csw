class OgcFilterModified
  # From 07-006r1_OpenGIS_Catalogue_Services_Specification_V2.0.2
  # OGC Queryable: Modified - Date on which the record was created or updated within the catalogue formatted as Date-8601
  # XML Element Name: dct:modified
  # Dublin Core element name: date
  # note that the CMR data expects DateTime-8601 while the CSW spec expects Date-8601
  @@ISO_QUERYABLE_NAME = "Modified"
  @@CMR_QUERY_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  def process(ogc_filter)
    cmr_query_hash = {}
    modified_param = extract_operand_filter_data(@@ISO_QUERYABLE_NAME, ogc_filter)
    if(modified_param[:operator] != nil && modified_param[:literal_value] != nil)
      modified_query_string = process_modified_date(modified_param)
      if (modified_query_string != nil)
        cmr_query_hash["#{@@CMR_QUERY_PARAM}"] = modified_query_string
      end
    end
    cmr_query_hash
  end

  private
  SUPPORTED_TEMPORAL_OPERATORS = %w(PropertyIsGreaterThanOrEqualTo PropertyIsGreaterThan)
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

  def process_modified_date(modified_hash)
    query_string = nil
    modified_value = modified_hash[:literal_value]
    validate_iso_date(@@ISO_QUERYABLE_NAME, modified_value)
    operator = modified_hash[:operator]
    if SUPPORTED_TEMPORAL_OPERATORS.include?(operator)
      query_string = "#{modified_value}"
    else
      error_message = "OgcFilterModified.process_modified_date: invalid operator value #{operator} for Modified, supported values are #{SUPPORTED_TEMPORAL_OPERATORS}"
      Rails.logger.error(error_message)
      # use 'None' instead of ommiting the locator
      raise OwsException.new('None', error_message)
    end
    query_string
  end

  def validate_iso_date(id, date_string)
    begin
      # DateTime.parse(date).iso8601 is too lax, we must enforce CSW date 8601 format 2016-09-06
      d = DateTime.strptime(date_string, '%Y-%m-%d')
    rescue ArgumentError => e
      raise OwsException.new(id, "'#{date_string}' is NOT in the supported ISO8601 date format yyyy-MM-dd")
    end
  end
end