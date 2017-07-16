class CqlFilterTemporal < OgcFilterTemporal
  # the temporal begin before end is left to CMR
  def self.process(begin_date, end_date)
    cmr_query_hash = {}
    temporal_query_string = ''
    if !begin_date.nil?
      validate_iso_date_time('TempExtent_begin',begin_date)
      temporal_query_string = "#{begin_date}/"
    end
    if !end_date.nil?
      validate_iso_date_time('TempExtent_end',end_date)
      if temporal_query_string.blank?
        temporal_query_string = "/#{end_date}"
      else
        temporal_query_string = temporal_query_string + "#{end_date}"
      end
    end
    if (!temporal_query_string.blank?)
      cmr_query_hash['temporal'] = temporal_query_string
    end
    cmr_query_hash
  end
end