class CqlFilterProvider < OgcFilterProvider
  def self.process(value)
    # the archive_center CMR param supports a wilcard
    cmr_query_hash = CqlFilterHelper.process_queryable(value, @@ADDITIONAL_QUERYABLE_NAME, @@CMR_PROVIDER_ID_PARAM, true)
    cmr_query_hash
  end
end