class CqlFilterIsGeoss
  def self.process(queryable_value)
    cmr_query_hash = {}
    if !queryable_value.nil?
      if (queryable_value == 'true')
        # add the geoss tags to the CMR query
        cmr_query_hash['tag_key'] = Rails.configuration.geoss_data_core_tag
      else
        error_message = "#{queryable_value} is not supported. Value must be set to 'true' in order to search only GEOSS datasets"
        Rails.logger.error(error_message)
        raise OwsException.new('IsGeoss', error_message)
      end
    else
      # if IsGeoss is present it must have a value
      error_message = "cannot be blank, it must be set to 'true' in order to search only GEOSS datasets"
      Rails.logger.error(error_message)
      raise OwsException.new('IsGeoss', error_message)
    end
    cmr_query_hash
  end
end