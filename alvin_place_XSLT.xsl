<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"
    media-type="text/html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="place"/>
  </xsl:template>

  <xsl:template match="record/data/place">
    <h1>
      <xsl:value-of select="authority/name/geographic"/>
    </h1>
    <div class="articleText" id="articleText_component_56_2">
      <p>
        <div style="display: flex; align-items: center;">
          <img src="../img/place.svg" style="vertical-align:middle; width:25px;height:25px"/>
          <span style="vertical-align:middle;margin-left:10px">(Plats)</span>
        </div>
      </p>
      <xsl:for-each select="variant">
        <xsl:if test="position() = 1">
          <p>
            <strong>Alternativa namnformer</strong>
            <br/>
            <xsl:for-each select="name">
              <xsl:value-of select="geographic"/>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="../@lang"/>
              <xsl:text>)</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="../variant[position() &gt; 1]/name">
              <br/>
              <xsl:value-of select="geographic"/>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="../@lang"/>
              <xsl:text>)</xsl:text>
              <br/>
            </xsl:for-each>
          </p>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="countryCode">
        <strong>Land</strong>
        <br/>
        <p>
          <xsl:value-of select="."/>
        </p>
      </xsl:for-each>
      <xsl:for-each select="point">
        <xsl:for-each select="latitude">
          <p>
            <strong>Latitud</strong>
            <br/>
            <xsl:value-of select="."/>
          </p>
        </xsl:for-each>
        <xsl:for-each select="longitude">
          <p>
            <strong>Longitud</strong>
            <br/>
            <xsl:value-of select="."/>
          </p>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="recordInfo/id">
        <strong>ID</strong>
        <br/>
        <p>
          <xsl:text>alvin-place:</xsl:text>
          <xsl:value-of select="."/>
        </p>
      </xsl:for-each>
      <strong>Karta</strong>
      <br/>
      <div id="map" style="width: 100%; height: 500px"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
