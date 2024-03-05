<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"
    media-type="text/html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="record"/>
  </xsl:template>
  
  <xsl:template match="record">
    <xsl:apply-templates select="data"/>
  </xsl:template>
  
  <xsl:template match="data">
    <xsl:apply-templates select="place"/>
  </xsl:template>

  <xsl:template match="place">
    <h1>
      <xsl:value-of select="authority/geographic"/>
    </h1>
    <div class="articleText" id="articleText_component_56_2">
      <xsl:for-each select="variant">
        <p>
        <xsl:if test="position() = 1">
            <strong>Alternativa namnformer</strong>
            <br/>
        </xsl:if>
        <xsl:for-each select="geographic">
          <xsl:value-of select="."/>
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
      </xsl:for-each>
      <xsl:for-each select="country">
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
