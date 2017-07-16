class CqlFilterBoundingBox < OgcFilterBoundingBox
  def self.process(value)
    # the bbox CMR param does not support wildcards
    # leave the bbox format validation to CMR
    cmr_query_hash = CqlFilterHelper.process_queryable(value, @@ISO_QUERYABLE_NAME, @@CMR_BOUNDINGBOX_PARAM, false)
    cmr_query_hash
  end
end