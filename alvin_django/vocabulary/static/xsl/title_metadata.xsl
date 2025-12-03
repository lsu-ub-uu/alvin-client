<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/metadata"/>
    </xsl:template>
    <xsl:template match="metadata">
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="@type = 'group'">
                    <xsl:choose>
                        <xsl:when test="nameInData = 'record'">
                            <xsl:text>Core class: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'person'">
                            <xsl:text>Core class: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'organisation'">
                            <xsl:text>Core class: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'place'">
                            <xsl:text>Core class: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'work'">
                            <xsl:text>Core class: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'location'">
                            <xsl:text>Core class: </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Subclass: </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'textVariable'">
                    <xsl:text>Property (text): </xsl:text>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'collectionVariable'">
                    <xsl:text>Property (code): </xsl:text>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'itemCollection'">
                    <xsl:text>Controlled list: </xsl:text>
                    <xsl:value-of select="textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                </xsl:when>
                <xsl:when test="@type = 'collectionItem'">
                    <xsl:text>Code: </xsl:text>
                    <xsl:value-of select="nameInData"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                    <xsl:text>)</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'recordLink'">
                    <xsl:text>Property (link): </xsl:text>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$title"/>
    </xsl:template>
</xsl:stylesheet>
