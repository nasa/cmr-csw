class CqlFilterArchiveCenter < OgcFilterArchiveCenter
  def self.process(value)
    # the archive_center CMR param supports a wilcard
    cmr_query_hash = CqlFilterHelper.process_queryable(value, @@ISO_QUERYABLE_NAME, @@CMR_ARCHIVECENTER_PARAM, true)
    cmr_query_hash
  end
end