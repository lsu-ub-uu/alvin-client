<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="urn:nbn:se:uu:ub:epc-schema:rs-location-mapping">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <records xmlns="urn:nbn:se:uu:ub:epc-schema:rs-location-mapping">
            <protocol-version>3.0</protocol-version>
            <xsl:apply-templates select="dataList/data/record/data"/>
        </records>
    </xsl:template>
    <xsl:template match="data">
        <xsl:for-each select="record">
            <record>
                <header>
                    <identifier>
                        <xsl:value-of select="recordInfo/urn"/>
                    </identifier>
                    <destinations>
                        <destination status="activated">
                            <url>
                                <xsl:text>https://www.alvin-portal.org/record/</xsl:text>
                                <xsl:value-of select="recordInfo/id"/>
                            </url>
                        </destination>
                    </destinations>
                </header>
            </record>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
