class OgcFilterEntryTitle

  @@ISO_QUERYABLE_NAME = "Title"
  # Title is an ISO queryable
  @@CMR_TITLE_PARAM = ISO_QUERYABLES_TO_CMR_QUERYABLES[@@ISO_QUERYABLE_NAME][1]

  def process(ogc_filter)
    # the entry_title CMR param supports a wilcard
    cmr_query_hash = OgcFilterHelper.process_queryable(ogc_filter, @@ISO_QUERYABLE_NAME, @@CMR_TITLE_PARAM, true)
    cmr_query_hash
  end
end