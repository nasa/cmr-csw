class CqlFilterHelper
  def self.process_queryable(value, iso_queryable_name, cmr_parameter_name, wildcard_flag)
    cmr_query_hash = {}
    if !value.blank?
      cmr_query_hash["#{cmr_parameter_name}"] = value
      if (wildcard_flag)
          process_wildcard(cmr_query_hash, cmr_parameter_name)
      end
    end
    cmr_query_hash
  end

  private
  def self.process_wildcard(cmr_query_hash, cmr_parameter_name)
    literal_value = cmr_query_hash["#{cmr_parameter_name}"]
    if (literal_value.include?('*') || literal_value.include?('?'))
      cmr_query_hash["options[#{cmr_parameter_name}][pattern]"] = true
    end
  end

end