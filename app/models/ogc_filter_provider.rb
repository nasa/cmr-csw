class OgcFilterProvider
  @@ADDITIONAL_QUERYABLE_NAME = "Provider"
  # ProviderId is not an ISO queryable, it is captured into AdditionalQueryables
  @@CMR_PROVIDER_ID_PARAM = ADDITIONAL_QUERYABLES_TO_CMR_QUERYABLES[@@ADDITIONAL_QUERYABLE_NAME][1]

  def process(ogc_filter)
    # the provider_id CMR param supports a wilcard
    cmr_query_hash = OgcFilterHelper.process_queryable(ogc_filter, @@ADDITIONAL_QUERYABLE_NAME, @@CMR_PROVIDER_ID_PARAM, true)
    cmr_query_hash
  end

end