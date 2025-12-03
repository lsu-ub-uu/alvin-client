<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:apply-templates select="dataList/data"/>
    </xsl:template>
    <xsl:template match="data">
        <xsl:variable name="sub1">
        <xsl:for-each select="recordToRecordLink[1][from/linkedRecordType = 'metadata']">
            <xsl:value-of select="from/linkedRecordId"></xsl:value-of>        
        </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sub2">
            <xsl:for-each select="recordToRecordLink[2][from/linkedRecordType = 'metadata']">
                <xsl:value-of select="from/linkedRecordId"></xsl:value-of>        
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="sub3">
            <xsl:for-each select="recordToRecordLink[3][from/linkedRecordType = 'metadata']">
                <xsl:value-of select="from/linkedRecordId"></xsl:value-of>        
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="$sub1"/>
        <xsl:value-of select="$sub2"/>
        <xsl:value-of select="$sub3"/>
    </xsl:template>
</xsl:stylesheet>
