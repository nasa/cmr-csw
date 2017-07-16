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
        <csw:SearchResults numberOfRecordsMatched="{$v_number_of_records_matched}" numberOfRecordsReturned="{$v_number_of_records_returned}"
                           nextRecord="{$v_next_record}" elementSet="{$v_element_set}" recordSchema="{$v_record_schema}">
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
      <csw:BriefRecord
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
        <dc:type>dataset</dc:type>
        <!-- csw:BriefRecord schema does not support the dct:spatial -->
        <!-- TODO: investigate whether or not there can be multiple bounding boxes for a CMR result entry -->
        <ows:WGS84BoundingBox>
          <ows:LowerCorner>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/>
            <xsl:text> </xsl:text>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
          </ows:LowerCorner>
          <ows:UpperCorner>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/>
            <xsl:text> </xsl:text>
            <xsl:value-of
                    select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/>
          </ows:UpperCorner>
        </ows:WGS84BoundingBox>
      </csw:BriefRecord>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>