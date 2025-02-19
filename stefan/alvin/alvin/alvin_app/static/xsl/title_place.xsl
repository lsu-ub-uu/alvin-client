<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data"/>
    </xsl:template>
    <xsl:template match="data">
        <xsl:value-of select="place/authority[1]/geographic"/>
    </xsl:template>
</xsl:stylesheet>
