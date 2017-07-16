class OgcFilterInstrument

  @@QUERYABLE_NAME = "Instrument"
  # platform is not an ISO queryable, it is a GCMD / CMR specific queryable
  @@CMR_INSTRUMENT_PARAM = GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES[@@QUERYABLE_NAME][1]

  def process(ogc_filter)
    # the platform CMR param supports a wilcard
    cmr_query_hash =  OgcFilterHelper.process_queryable(ogc_filter, @@QUERYABLE_NAME, @@CMR_INSTRUMENT_PARAM, true)
    cmr_query_hash
  end
end