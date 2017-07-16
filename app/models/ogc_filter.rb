class OgcFilter
  # New queryable processor classes should be added here
  @@SUPPORTED_QUERYABLE_PROCESSORS = [ OgcFilterAnyText,
                                       OgcFilterBoundingBox,
                                       OgcFilterTemporal,
                                       OgcFilterEntryTitle,
                                       OgcFilterPlatform,
                                       OgcFilterInstrument,
                                       OgcFilterScienceKeywords,
                                       OgcFilterArchiveCenter,
                                       OgcFilterPolygon,
                                       OgcFilterLine,
                                       OgcFilterPoint,
                                       OgcFilterModified,
                                       OgcFilterIsCwic,
                                       OgcFilterIsGeoss
                                     ]
  @ogc_filter
  @cmr_query_hash

  def initialize (filter, cmr_query_hash)
    @ogc_filter = filter
    @cmr_query_hash = cmr_query_hash
  end

  def process_all_queryables
    @@SUPPORTED_QUERYABLE_PROCESSORS.each do |queryable_processor|
      queryable_processor_instance = queryable_processor.new
      @cmr_query_hash.reverse_merge!(queryable_processor_instance.process(@ogc_filter))
      #TODO might need to add post_processing for @cmr_query_hash once we add support for logical operators
    end
  end

end