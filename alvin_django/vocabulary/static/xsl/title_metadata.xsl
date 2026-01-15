<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:param name="lang"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/metadata"/>
    </xsl:template>
    <xsl:template match="metadata">
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="@type = 'group'">
                    <xsl:choose>
                        <xsl:when test="nameInData = 'record'">
                            <xsl:call-template name="coreclass"></xsl:call-template>
                        </xsl:when>
                        <xsl:when test="nameInData = 'person'">
                            <xsl:call-template name="coreclass"></xsl:call-template>
                        </xsl:when>
                        <xsl:when test="nameInData = 'organisation'">
                            <xsl:call-template name="coreclass"></xsl:call-template>
                        </xsl:when>
                        <xsl:when test="nameInData = 'place'">
                            <xsl:call-template name="coreclass"></xsl:call-template>
                        </xsl:when>
                        <xsl:when test="nameInData = 'work'">
                            <xsl:call-template name="coreclass"></xsl:call-template>
                        </xsl:when>
                        <xsl:when test="nameInData = 'location'">
                            <xsl:call-template name="coreclass"></xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Subclass: </xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Subklass: </xsl:text>                                    
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Subklass: </xsl:text>                                   
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'textVariable'">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Property (text): </xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Egenskap (tekst): </xsl:text>                                    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Egenskap (text): </xsl:text>                                  
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'collectionVariable'">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Property (code): </xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Egenskap (kode): </xsl:text>                                    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Egenskap (kod): </xsl:text>                                  
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'itemCollection'">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Controlled list: </xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Kontrollert liste: </xsl:text>                                    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Kontrollerad lista: </xsl:text>                                  
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                </xsl:when>
                <xsl:when test="@type = 'collectionItem'">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Code: </xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Kode: </xsl:text>                                    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Kod: </xsl:text>                                  
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="nameInData"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                    <xsl:text>)</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'recordLink'">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Subclass (link): </xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Subklass (lenke): </xsl:text>                                    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Subklass (länk): </xsl:text>                                  
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$title"/>
    </xsl:template>
    <xsl:template name="coreclass">
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <xsl:text>Core class: </xsl:text>
            </xsl:when>
            <xsl:when test="$lang = 'no'">
                <xsl:text>Kjerneklass: </xsl:text>                                    
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Kärnklass: </xsl:text>                                   
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
