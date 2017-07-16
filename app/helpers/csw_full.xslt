<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="csw_common.xslt" />
  <xsl:param name="result_root_element"/>
  <xsl:param name="server_timestamp"/>
  <xsl:param name="number_of_records_matched"/>
  <xsl:param name="number_of_records_returned"/>
  <xsl:param name="next_record"/>
  <xsl:param name="element_set"/>
  <xsl:param name="record_schema"/>
  <xsl:variable name="v_result_root_element" select="$result_root_element"/>
  <xsl:variable name="v_server_timestamp" select="$server_timestamp"/>
  <xsl:variable name="v_number_of_records_matched" select="$number_of_records_matched"/>
  <xsl:variable name="v_number_of_records_returned" select="$number_of_records_returned"/>
  <xsl:variable name="v_next_record" select="$next_record"/>
  <xsl:variable name="v_element_set" select="$element_set"/>
  <xsl:variable name="v_record_schema" select="$record_schema"/>
  <xsl:template match="/">
    <xsl:element name="{$v_result_root_element}">
      <xsl:if test="$v_result_root_element = 'csw:GetRecordsResponse'">
        <csw:SearchStatus timestamp="{$v_server_timestamp}"/>
        <csw:SearchResults numberOfRecordsMatched="{$v_number_of_records_matched}"
                           numberOfRecordsReturned="{$v_number_of_records_returned}" nextRecord="{$v_next_record}"
                           elementSet="{$v_element_set}" recordSchema="{$v_record_schema}">
          <xsl:call-template name="entries"/>
        </csw:SearchResults>
      </xsl:if>
      <xsl:if test="$v_result_root_element = 'csw:GetRecordByIdResponse'">
        <xsl:call-template name="entries"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template name="entries">
    <xsl:for-each select="results/result">
      <csw:Record
              xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
              xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gmi="http://www.isotc211.org/2005/gmi"
              xmlns:gml="http://www.opengis.net/gml/3.2"
              xmlns:dc="http://purl.org/dc/elements/1.1/"
              xmlns:dct="http://purl.org/dc/terms/"
              xmlns:ows="http://www.opengis.net/ows"
              xmlns:gco="http://www.isotc211.org/2005/gco"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.opengis.net/cat/csw/2.0.2 record.xsd">
        <dc:identifier>
          <xsl:value-of select="@concept-id"/>
        </dc:identifier>
        <dc:title>
          <xsl:value-of select="gmi:MI_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
        </dc:title>
        <xsl:if test="gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString">
          <dc:creator>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:contact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
          </dc:creator>
        </xsl:if>
        <dc:type>dataset</dc:type>
        <xsl:for-each select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword">
          <dc:subject>
            <xsl:value-of select="gco:CharacterString"/>
          </dc:subject>
        </xsl:for-each>
        <xsl:if test="gmi:MI_Metadata/gmi:acquisitionInformation/gmi:MI_AcquisitionInformation/gmi:operation/gmi:MI_Operation/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
          <dc:source>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmi:acquisitionInformation/gmi:MI_AcquisitionInformation/gmi:operation/gmi:MI_Operation/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
          </dc:source>
        </xsl:if>
        <xsl:if test="gmi:MI_Metadata/gmd:language/gco:CharacterString">
          <dc:language>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:language/gco:CharacterString"/>
          </dc:language>
        </xsl:if>
        <xsl:for-each select="*/gmd:topicCategory">
          <dc:subject>
            <xsl:value-of select="gmd:MD_TopicCategoryCode"/>
          </dc:subject>
        </xsl:for-each>
        <xsl:if test="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name">
          <dc:format>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorFormat/gmd:MD_Format/gmd:name/gco:CharacterString"/>
          </dc:format>
        </xsl:if>
        <xsl:for-each
                select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:aggregationInfo/gmd:MD_AggregateInformation/gmd:aggregateDataSetName/gmd:CI_Citation/gmd:title">
          <dc:relation>
            <xsl:value-of select="gco:CharacterString"/>
          </dc:relation>
        </xsl:for-each>
        <xsl:for-each
                select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date">
          <dct:modified>
            <xsl:value-of select="gco:DateTime"/>
          </dct:modified>
        </xsl:for-each>
        <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString">
          <dct:abstract>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/>
          </dct:abstract>
        </xsl:if>
        <xsl:for-each
                select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints">
          <dct:rights>
            <xsl:value-of
                    select="gmd:MD_RestrictionCode"/>
          </dct:rights>
        </xsl:for-each>
        <xsl:for-each
                select="gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage">
          <dct:references>
            <xsl:value-of
                    select="gmd:URL"/>
          </dct:references>
        </xsl:for-each>
        <xsl:call-template name="process_polygon">
          <xsl:with-param name="current_result">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="process_line">
          <xsl:with-param name="current_result">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="process_point">
          <xsl:with-param name="current_result">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="process_temporal_point">
          <xsl:with-param name="current_result">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="process_temporal_range">
          <xsl:with-param name="current_result">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
        <!-- BBOX must be after the dct namespace -->
        <xsl:call-template name="process_bbox">
          <xsl:with-param name="current_result">
            <xsl:value-of select="."/>
          </xsl:with-param>
        </xsl:call-template>
      </csw:Record>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>