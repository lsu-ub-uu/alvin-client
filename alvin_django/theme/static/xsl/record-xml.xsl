<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data"/>
    </xsl:template>
    <xsl:template match="data">
        <xsl:apply-templates select="record | person | organisation | place | work | location"></xsl:apply-templates>
    </xsl:template>   
    <!-- Copy all text nodes, elements and attributes -->   
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>  
    <!-- When matching actionLinks: do nothing -->
    <xsl:template match="actionLinks" />
</xsl:stylesheet>
