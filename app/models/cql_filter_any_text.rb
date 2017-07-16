class CqlFilterAnyText < OgcFilterAnyText
  def self.process(value)
    # the keyword CMR param supports a wilcard
    cmr_query_hash = CqlFilterHelper.process_queryable(value, @@ISO_QUERYABLE_NAME, @@CMR_ANYTEXT_PARAM, true)
    cmr_query_hash
  end
end