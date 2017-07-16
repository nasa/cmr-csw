# This file contains data structures that are used to analye the CSW queryables support in CSW standard, CMR search and
# GCMD CSW.  The data structure might give us some help in automating some CMR CSW request or response processing

ISO_QUERYABLES_TO_CMR_QUERYABLES =
    {
        # Hash format below is: ISO_Queryable_Name => [GCMD_Queryable, CMR_Queryable, [array of XML Elements where is appears in output]]
        # NOTE:  the queryables below appear in the SupportedISOQueryables section of the GCMD GetCapabilities document.
        # The descriptions above each entry are the corresponding ISO standard description of the ISO field from the CSW
        # standard document.

        # The topic of the content of the resource
        #'Subject' => ['Subject', '', ['MD_Metadata.identificationInfo.AbstractMD_Identification.descriptiveKeywords.MD_Keywords .keyword',
        #                              'MD_Metadata.identificationInfo.MD_DataIdentification.topicCategory']],

        # A name given to the resource
        'Title' => ['Title', 'entry_title', ['MD_Metadata.identificationInfo.AbstractMD_Identification.citation.CI_ Citation.title']],

        # A summary of the content of the resource.
        #'Abstract' => ['Abstract', '', ['MD_Metadata.identificationInfo.AbstractMD_Id entification.abstract']],
        # A target for full-text search of character data types in a catalogue
        'AnyText' => ['AnyText', 'keyword', []],
        # The physical or digital manifestation of the resource
        #'Format' => ['Format', '', 'MD_Metadata.distributionInfo.MD_Distribution.distributionFormat.MD_Format.name'],

        # A unique reference to the record within the catalogue
        #'Identifier' => ['Identifier', 'concept_id', ['MD_Metadata.fileIdentifier']],

        # Date on which the record was created or updated within the catalogue
        'Modified' => ['Modified', 'updated_since', ['MD_Metadata.dateStamp.Date']],

        # The nature or genre of the content of the resource. Type can include general categories, genres or aggregation
        # levels of content. If MD_Metadata.hierarchyLevel.MD_ScopeCode@codeListValue is missing, default is 'Dataset'.
        #'Type' => ['Type', '', ['MD_Metadata.hierarchyLevel.MD_ScopeCode/@codeListValue']],
        # A bounding box for identifying a geographic area of interest
        'BoundingBox' => ['', 'bounding_box', ['BoundingBox']],

        # Geographic Coordinate Reference System (Authority and ID) for the BoundingBox
        #'CRS' => ['', 'two_d_coordinate_system_name', ['CRS']],

        # Complete statement of a one-to-one relationship
        #'Association' => ['', '', []],
        # Western-most coordinate of the limit of the resource ́s extent, expressed in longitude in decimal degrees
        # (positive east)
        #'WestBoundLongitude' => ['', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.extent.EX_Extent.geographicElement.EX_GeographicBoundingBox.westBoundLongitude']],

        # Southern-most coordinate of the limit of the resource ́s extent, expressed in latitude in decimal degrees
        # (positive north)
        #'SouthBoundLatitude' => ['', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.extent.EX_Extent.geographicElement.EX_GeographicBoundingBox.southBoundLatitude']],

        # Eastern-most coordinate of the limit of the resource ́s extent, expressed in longitude in decimal degrees
        # (positive east)
        #'EastBoundLongitude' => ['', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.extent.EX_Extent.geographicElement.EX_GeographicBoundingBox.eastBoundLongitude']],

        # Northern-most, coordinate of the limit of the resource ́s extent, expressed in latitude in decimal degrees
        # (positive north)
        #'NorthBoundLatitue' => ['', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.extent.EX_Extent.geographicElement.EX_GeographicBoundingBox.northBoundLatitude']],

        # Authority of the CRS
        #'Authority' => ['', '', ['MD_Metadata.referenceSystemInfo.MD_ReferenceSystem.referenceSystemIdentifier.RS_Identifier.codeSpace']],

        # ID of the CRS
        #'ID' => ['', '', ['MD_Metadata.referenceSystemInfo.MD_ReferenceSystem.referenceSystemIdentifier.RS_Identifier.code']],

        # Version of the CRS
        #'Version' => ['', '', ['MD_Metadata.referenceSystemInfo.MD_ReferenceSystem.referenceSystemIdentifier.RS_Identifier.version']],

        # Alternate title of the resource
        #'AlternateTitle' => ['AlternateTitle', '', ['MD_Metadata.identificationInfo.AbstractMD_Identification.citation.CI_Citation.alternateTitle']],

        # Revision date of the resource
        #'RevisionDate' => ['RevisionDate', 'revision_date', ['MD_Metadata.identificationInfo.Abstrac tMD_Identification.citation.CI_Citation.date.CI_Date[dateType.CI_DateTypeCode.@codeListValue='revision'].date.Date']],

        # Creation date of the resource
        #'CreationDate' => ['CreationDate', '', ['MD_Metadata.identificationInfo.AbstractMD_Identification.citation.CI_Citation.date.CI_Date[dateType.CI_DateTypeCo de.@codeListV alue='creation'].date.Date']],

        # Publication date of the resource
        #'PublicationDate' => ['PublicationDate', '', ['MD_Metadata.identificationInfo.AbstractMD_Identification.citation.CI_Citation.date.CI_Date[dateType.CI_DateTypeCo de.@codeListValue='publication'].date.Date']],

        # Name of the organisation (OrganisationName) providing the resource NOT SURE provider_short_name. archive_center or data_center
        'ArchiveCenter' => ['ArchiveCenter', 'archive_center', ['MD_Metadata.identificationInfo.AbstractMD_Identification.pointOfContact.CI_ResponsibleParty.organisationName']],

        # Are there any security constraints?
        #'HasSecurityConstraints' => ['HasSecurityConstraints', '', ['MD_Metadata.AbstractMD_Identification.resourceConstraints.MD_SecurityConstraints']],

        # Language of the metadata
        #'Language' => ['Language', '', ['MD_Metadata.language']],

        # Identifier of the resource
        #'ResourceIdentifier' => ['ResourceIdentifier', 'dif_entry_id', ['MD_Metadata.identificationInfo.AbstractMD_Identification.citation.CI_Citation.identifier.code']],

        # File identifier of the metadata to which this metadata is a subset (child)
        #'ParentIdentifier' => ['ParentIdentifier', '', ['MD_Metadata.parentIdentifier']],
        # Methods used to group similar keywords
        #'KeywordType' => ['KeywordType', '', '', ['MD_Metadata.identificationInfo.Abstract.MD_Identification.descriptiveKeywords.MD_Keywords.type']],

        # Main theme(s) of the dataset
        #'TopicCategory' => ['TopicCategory', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.topicCategory']],

        # Language(s) used within the dataset
        #'ResourceLanguage' => ['ResourceLanguage', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.language']],

        # Temporal extent information: begin
        'TempExtent_begin' => ['TempExtent_begin', 'temporal[]', ['MD_Metadata.identificationInfo.MD_DataIdentification.extent.EX_Extent.temporalElement.EX_TemporalExtent.extent.TimePeriod.beginPosition']],

        # Temporal extent information: end
        'TempExtent_end' => ['TempExtent_end', 'temporal[]', ['MD_Metadata.identificationInfo.MD_DataIdentification.extent.EX_Extent.temporalElement.EX_TemporalExtent.extent.TimePeriod.endPosition']],

        'Instrument' => ['Instrument', 'instrument', ['']],

        'Platform' => ['Platform', 'platform', ['']],

        'ScienceKeywords' => ['ScienceKeywords', 'science_keywords', ['']],

        # Name of a service type.
        #'ServiceType' => ['ServiceType', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.serviceType']],

        # The version of a service type.
        #'ServiceTypeVersion' => ['ServiceTypeVersion', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.serviceTypeVersion']],

        # Name of a service operation.
        #'Operation' => ['Operation', '', ['MD_Metadata.identificationInfo.SV_Ser viceIdentification.containsOperations. SV_OperationMetadata.operationName']],

        # Level of detail expressed as a scale factor or a ground distance. Here: the number below the line in a vulgar fraction.
        # Only used, if DistanceValue and DistanceUOM are not used.
        #'Denominator' => ['Denominator', '', ['MD_Metadata.identificationInfo.MD_ DataIdentification.spatialResolution.MD_Resolution.equivalentScale.MD_RepresentativeFraction.denominator']],

        # Sample ground distance. Here: the distance as decimal value. Only used, if Denominator is not used.
        #'DistanceValue' => ['DistanceValue', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.spatialResolution.MD_Resolution.distance.gco:Distance']],

        # Sample ground distance. Here: the name of the unit of measure. Only used, if Denominator is not used.
        #'DistanceUOM' => ['DistanceUOM', '', ['MD_Metadata.identificationInfo.MD_DataIdentification.spatialResolution.MD_Resolution.distance.gco:Distance@ uom']],

        # Name of a service operation.
        #'Operation' => ['Operation', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.containsOperations.SV_OperationMetadata.operationName']],

        # Description of the geographic area using identifiers.
        #'GeographicDescriptionCode' => ['GeographicDescription Code', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.extent.EX_Extent.geographicElement.EX_GeographicDescripti on.geographicIdentifier.MD_Identifier.code']],

        # Specifies the tightly coupled dataset relation
        #'OperatesOnData' => ['', '', []],

        # The coupling type of this service.
        #'CouplingType' => ['CouplingType', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.couplingType.SV_CouplingType.code@codeListValue']],

        # Identifier of a dataset tightly coupled with the service instance.
        #'OperatesOn' => ['OperatesOn', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.operatesOn.MD_DataIdentification.citation.CI_Citation.identifier']],

        # Identifier of a tightly coupled dataset on which the service operates with a specific operation
        #'OperatesOnIdentifier' => ['OperatesOnIdentifier', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.coupledResource.SV_CoupledResource.identifier']],

        #
        #'OperatesOnName' => ['OperatesOnName', '', ['MD_Metadata.identificationInfo.SV_ServiceIdentification.coupledResource.SV_CoupledResource.operationName']],

        # CharacterString
        #'Lineage' => ['Lineage', '', ['MD_Metadata.dataQualityInfo.DQ_DataQuality.lineage.LI_Lineage.statement']]
        #
        #'' => ['','',['']]
    }

ADDITIONAL_QUERYABLES_TO_CMR_QUERYABLES =
{
    # CWIC datasets are tagged in CMR with:
    # namespace = 'org.ceos.wgiss.cwic.granules' and value = 'prod' for CWIC PROD datasets
    # namespace = 'org.ceos.wgiss.cwic.granules' and value = 'test' for CWIC TEST datasets
    # Sample CMR query is:
    # https://cmr.earthdata.nasa.gov/search/collections.json?tag_key=org.ceos.wgiss.cwic.granules.prod&include_tags=org.ceos.wgiss.cwic.*
    'IsCwic' => ['IsCwic', 'IsCwic', ['']],
    'IsGeoss' => ['IsGeoss', 'IsGeoss', ['']],
    'Provider' => ['', 'provider', ['']]
}

GCMD_SPECIFIC_QUERYABLES_TO_CMR_QUERYABLES =
    {
        # Hash format below is: GCMD_Queryable => [GCMD_Queryable, CMR_Queryable, [array of XML Elements where is appears in output]]
        # NOTE:  ALL of the queryables below appear the AdditionalQueryables sections of the GCMD GetCapabilities document.
        # Since they do  not appear in the ISO standard, there is no description of the meaning of the entry

        'Project' => ['Project', 'project', ['']], # not sure this is the same meaning since CMR Project is campaign
        #
        'Platform' => ['Platform', 'platform', ['']],
        #
        'Location' => ['Location', 'spatial_keyword', ['']], # spatial_keyword OR archive_center
        #
        'ScienceKeywords' => ['ScienceKeywords', 'science_keywords', ['']],
        #
        'CreationDate' => ['CreationDate', '', ['']],
        #
        'Instrument' => ['Instrument', 'instrument', ['']],
        #
        'ConditionApplyingToAccessAndUse' => ['ConditionApplyingToAccessAndUse', '', ['']],
        #
        'AccessConstraints' => ['AccessConstraints', '', ['']],
        #
        'OnlineResourceMimeType' => ['OnlineResourceMimeType', '', ['']],
        #
        'ResponsiblePartyRole' => ['ResponsiblePartyRole', '', ['']],
        #
        'OnlineResourceType' => ['OnlineResourceType', '', ['']],
        #
        'SpecificationDate' => ['SpecificationDate', '', ['']],
        #
        'MetadataPointOfContact' => ['MetadataPointOfContact', '', ['']],
        #
        'Classification' => ['Classification', '', ['']],
        #
        'OtherConstraints' => ['OtherConstraints', '', ['']],
        #
        'Degree' => ['Degree', '', ['']],
        #
        'SpecificationTitle' => ['SpecificationTitle', '', ['']]
        #
        #'' => ['','',['']]
    }

ALL_CMR_QUERYABLES =
    {
        # Hash format below is: CMR_Queryable => [GCMD_Queryable, CMR_Queryable, [array of XML Elements where is appears in output]]
        # NOTE:  ALL of the queryables below appear the AdditionalQueryables sections of the GCMD GetCapabilities document.
        # Since they do  not appear in the ISO standard, there is no description of the meaning of the entry

        #
        'concept_id' => ['', 'concept_id', ['']],
        #
        'echo_collection_id' => ['', 'echo_collection_id', ['']],
        #
        'provider_short_name' => ['', 'provider_short_name', ['']],
        #
        'entry_title' => ['', 'entry_title', ['']],
        #
        'dataset_id' => ['', 'dataset_id', ['']],
        #
        'entry_id' => ['', 'entry_id', ['']],
        #
        'dif_entry_id' => ['', 'dif_entry_id', ['']],
        #
        'archive_center' => ['', 'archive_center', ['']],
        #
        'data_center' => ['', 'data_center', ['']],
        #
        'temporal[]' => ['', 'temporal[]', ['']],
        #
        'project' => ['', 'project', ['']],
        #
        'updated_since' => ['', 'updated_since', ['']],
        #
        'revision_date' => ['', 'revision_date', ['']],
        #
        'processing_level_id' => ['', 'processing_level_id', ['']],
        #
        'platform' => ['', 'platform', ['']],
        #
        'instrument' => ['', 'instrument', ['']],
        #
        'spatial_keyword' => ['', 'spatial_keyword', ['']],
        #
        'science_keywords' => ['ScienceKeywords', 'science_keywords', ['']],
        #
        'two_d_coordinate_system_name' => ['', 'two_d_coordinate_system_name', ['']],
        #
        'collection_data_type' => ['', 'collection_data_type', ['']],
        #
        'online_only' => ['', 'online_only', ['']],
        #
        'downloadable' => ['', 'downloadable', ['']],
        #
        'browse_only' => ['', 'browse_only', ['']],
        #
        'browsable' => ['', 'browsable', ['']],
        #
        'keyword' => ['', 'keyword', ['']],
        #
        'provider' => ['', 'provider', ['']],
        #
        'short_name' => ['', 'short_name', ['']],
        #
        'version' => ['', 'version', ['']],
        #
        'polygon' => ['', 'polygon', ['']],
        #
        'bounding_box' => ['', 'bounding_box', ['']],
        #
        'point' => ['', 'point', ['']],
        #
        'line' => ['', 'line', ['']],
        #
        'has_granules' => ['', 'has_granules', ['']]
    }