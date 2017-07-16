<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:ows="http://www.opengis.net/ows"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <xsl:output method="xml" indent="yes"/>
  <!-- Nokogiri only supports xslt 1.0 where functions are not a native construct, must use templates -->
  <!-- functionality in this stylesheet can be used across the csw_brief.xslt, csw_summary.xslt and csw_full.xslt -->

  <!-- TODO: investigate whether or not there can be multiple polygons for a CMR result -->
  <xsl:template name="process_polygon">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList">
        <dct:spatial>gml:Polygon gml:posList
          <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Polygon/gml:exterior/gml:LinearRing/gml:posList"/>
        </dct:spatial>
    </xsl:if>
  </xsl:template>

  <!-- TODO: investigate whether or not there can be multiple lines for a CMR result  -->
  <xsl:template name="process_line">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:LineString/gml:posList">
      <dct:spatial>gml:LineString gml:posList
        <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:LineString/gml:posList"/>
      </dct:spatial>
    </xsl:if>
  </xsl:template>

  <!-- TODO: investigate whether or not there can be multiple points for a CMR result -->
  <xsl:template name="process_point">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Point/gml:pos">
      <dct:spatial>gml:Point gml:pos
        <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_BoundingPolygon/gmd:polygon/gml:Point/gml:pos"/>
      </dct:spatial>
    </xsl:if>
  </xsl:template>

  <!-- TODO: investigate whether or not there can be multiple bounding boxes for a CMR result entry -->
  <xsl:template name="process_bbox">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal">
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
    </xsl:if>
  </xsl:template>

  <!-- ISO 8601 dates and date ranges are used to represent the temporal coverage inside a CSW dct:temporal element -->
  <!-- Only CSW FULL / csw:Record responses contain temporal coverage -->
  <xsl:template name="process_temporal_range">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod">
      <xsl:variable name="begin" select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition"/>
      <xsl:variable name="begin_indeterminate" select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition/@indeterminatePosition"/>
      <xsl:variable name="end" select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition"/>
      <xsl:variable name="end_indeterminate" select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition/@indeterminatePosition"/>
      <dct:temporal>
        <xsl:choose>
          <!-- We have a complete range specified -->
          <xsl:when test="$begin and $begin != '' and $end and $end != ''">
            <xsl:value-of select="concat($begin, '/', $end)"/>
          </xsl:when>
          <xsl:when test="$begin and $begin != '' and $end_indeterminate = 'now'">
            <xsl:value-of select="concat($begin, '/')"/>
          </xsl:when>
          <xsl:when test="$end and $end != '' and $begin_indeterminate = 'before'">
            <xsl:value-of select="concat('/', $end)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Functionality to process the current entry temporal coverage from the CMR ISO 19115 response by CMR CSW does not exist.</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </dct:temporal>
    </xsl:if>
  </xsl:template>

  <xsl:template name="process_temporal_point">
    <xsl:param name="current_result"/>
    <xsl:if test="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
      <dct:temporal>
        <xsl:value-of select="gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition"/>
      </dct:temporal>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>