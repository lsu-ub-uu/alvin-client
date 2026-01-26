<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" method="text" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="dataList/data"/>
    </xsl:template>
    <xsl:template match="data">
        <xsl:variable name="sub1">
            <xsl:for-each select="recordToRecordLink[1][from/linkedRecordType = 'metadata']">
                <xsl:value-of select="from/linkedRecordId"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$sub1"/>
    </xsl:template>
</xsl:stylesheet>
