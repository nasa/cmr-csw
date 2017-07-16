<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
  <xsl:output method="xml" indent="yes"/>
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
      <gmi:MI_Metadata
              xmlns:gco="http://www.isotc211.org/2005/gco"
              xmlns:gmd="http://www.isotc211.org/2005/gmd"
              xmlns:gmi="http://www.isotc211.org/2005/gmi"
              xmlns:xs="http://www.w3.org/2001/XMLSchema"
              xmlns:gmx="http://www.isotc211.org/2005/gmx"
              xmlns:gss="http://www.isotc211.org/2005/gss"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xmlns:gml="http://www.opengis.net/gml/3.2"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              xmlns:eos="http://earthdata.nasa.gov/schema/eos"
              xmlns:srv="http://www.isotc211.org/2005/srv"
              xmlns:gts="http://www.isotc211.org/2005/gts"
              xmlns:swe="http://schemas.opengis.net/sweCommon/2.0/"
              xmlns:gsr="http://www.isotc211.org/2005/gsr">
        <gmd:fileIdentifier>
          <gco:CharacterString>
            <xsl:value-of select="@concept-id"/>
          </gco:CharacterString>
        </gmd:fileIdentifier>
        <gmd:hierarchyLevel>
          <xsl:copy-of select="gmi:MI_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode"/>
        </gmd:hierarchyLevel>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:identificationInfo"/>
        <xsl:copy-of select="gmi:MI_Metadata/gmd:distributionInfo"/>
      </gmi:MI_Metadata>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>