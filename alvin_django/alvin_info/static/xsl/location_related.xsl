<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="lang"/>
    <xsl:template match="/">
        <div class="main">
            <xsl:apply-templates select="record/data"/>
        </div>
    </xsl:template>
    <xsl:template match="data">
        <xsl:apply-templates select="location"/>
    </xsl:template>
    <xsl:template match="location">
        <xsl:apply-templates select="electronicLocator"/>
    </xsl:template>
    <xsl:template match="electronicLocator">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:text>URL</xsl:text>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <a class="text-blue-800 dark:text-blue-200 underline">
                    <xsl:attribute name="href">
                        <xsl:value-of select="url"/>
                    </xsl:attribute>
                    <xsl:value-of select="displayLabel"/>
                </a>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
