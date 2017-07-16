class CqlFilterIsCwic
  def self.process(queryable_value)
    cmr_query_hash = {}
    if !queryable_value.nil?
      if (queryable_value == 'true')
        # add the cwic tags to the CMR query
        # include_tags=org.ceos.wgiss.cwic.granules.prod&tag_key=org.ceos.wgiss.cwic.granules.prod
        # the include_tags is already added by default for org.ceos.wgiss.cwic.granules.prod
        cmr_query_hash["tag_key"] = Rails.configuration.cwic_tag
      else
        error_message = "#{queryable_value} is not supported. Value must be set to 'true' in order to search only CWIC datasets"
        Rails.logger.error(error_message)
        raise OwsException.new('IsCwic', error_message)
      end
    else
      # if IsCwic is present it must have a value
      error_message = "cannot be blank, it must be set to 'true' in order to search only CWIC datasets"
      Rails.logger.error(error_message)
      raise OwsException.new('IsCwic', error_message)
    end
    cmr_query_hash
  end
end