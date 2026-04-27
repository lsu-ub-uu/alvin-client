<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/record | dataList/data/record/data/record"/>
    </xsl:template>
    <xsl:template match="@*|text()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//record">
        <record>
            <header>
                <identifier>
                    <xsl:text>oai:ALVIN.org:</xsl:text>
                    <xsl:value-of select="recordInfo/id"/>
                </identifier>
                <datestamp>
                    <xsl:for-each select="recordInfo/updated/tsUpdated[position() = last()]">
                        <xsl:value-of select="substring-before(.,'.')"/>
                        <xsl:text>Z</xsl:text>
                    </xsl:for-each>
                </datestamp>
                <setSpec>
                    <xsl:value-of select="physicalLocation/heldBy/location/linkedRecordId"/>
                </setSpec>
            </header>
            <metadata>
                <record xmlns="https://www.alvin-portal.org/vocabulary" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="https://www.alvin-portal.org/vocabulary https://www.alvin-portal.org/schema/alvin-record.xsd">
                    <xsl:apply-templates select="@*|node()"/>
                </record>
            </metadata>
        </record>
    </xsl:template>
    <xsl:template match="*">
        <xsl:element name="{local-name()}" namespace="https://www.alvin-portal.org/vocabulary">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    <!-- When matching actionLinks: do nothing -->
    <xsl:template match="actionLinks"/>
    <xsl:template match="note[@noteType = 'internal']"/>    
</xsl:stylesheet>
