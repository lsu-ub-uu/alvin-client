<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data"/>
    </xsl:template>
    <xsl:template match="data">
        <h1>
            <xsl:value-of select="location/authority[1]/name/namePart"/>
        </h1>
    </xsl:template>
</xsl:stylesheet>
