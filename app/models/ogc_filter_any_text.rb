class OgcFilterAnyText
  @@ISO_QUERYABLE_NAME = "AnyText"
  # AnyText is an ISO queryable
  @@CMR_ANYTEXT_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  def process(ogc_filter)
    # the keyword CMR param supports a wilcard
    cmr_query_hash = OgcFilterHelper.process_queryable(ogc_filter, @@ISO_QUERYABLE_NAME, @@CMR_ANYTEXT_PARAM, true)
    cmr_query_hash
  end

end