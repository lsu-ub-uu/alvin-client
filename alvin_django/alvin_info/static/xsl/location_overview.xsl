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
        <xsl:apply-templates select="email"/>
        <xsl:apply-templates select="address"/>
        <xsl:apply-templates select="point"/>
    </xsl:template>
    <xsl:template match="authority">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="name/@_en"/>
                        <xsl:call-template name="namelang"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="name/@_no"/>
                        <xsl:call-template name="namelang"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name/@_sv"/>
                        <xsl:call-template name="namelang"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <xsl:for-each select="name">
                    <xsl:value-of select="namePart[@type = 'corporateName']"/>
                    <xsl:for-each select="namePart[@type = 'subordinate']">
                        <xsl:text>. </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                    <xsl:for-each select="namePart[@type = 'termsOfAddress']">
                        <xsl:text>. </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:for-each>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="organisationInfo">
        <xsl:for-each select="startDate">
            <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:value-of select="@_en"/>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:value-of select="@_no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@_sv"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="w-full md:w-3/4 flex flex-grow pl-2">
                    <xsl:for-each select="date">
                        <xsl:for-each select="year">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="month">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="day">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="era">
                            <xsl:text> </xsl:text>
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:value-of select="@_value_en"/>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:value-of select="@_value_no"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@_value_sv"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </div>
            </div>
        </xsl:for-each>
        <xsl:for-each select="endDate">
            <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:value-of select="@_en"/>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:value-of select="@_no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@_sv"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="w-full md:w-3/4 flex flex-grow pl-2">
                    <xsl:for-each select="date">
                        <xsl:for-each select="year">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="month">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="day">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="era">
                            <xsl:text> </xsl:text>
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:value-of select="@_value_en"/>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:value-of select="@_value_no"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@_value_sv"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </div>
            </div>
        </xsl:for-each>
        <xsl:for-each select="displayDate">
            <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:value-of select="@_en"/>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:value-of select="@_no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@_sv"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="w-full md:w-3/4 flex flex-grow pl-2">
                    <xsl:value-of select="."/>
                </div>
            </div>
        </xsl:for-each>
        <xsl:for-each select="descriptor">
            <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:value-of select="@_en"/>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:value-of select="@_no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@_sv"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="w-full md:w-3/4 flex flex-grow pl-2">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:value-of select="@_value_en"/>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:value-of select="@_value_no"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@_value_sv"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
        </xsl:for-each>
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
    <xsl:template match="identifier">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="@_en"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="@_no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@_sv"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@type"/>
                <xsl:text>)</xsl:text>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <xsl:value-of select="."/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="email">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="@_en"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="@_no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@_sv"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <a class="text-blue-800 dark:text-blue-200 underline">
                    <xsl:attribute name="href">
                        <xsl:text>mailto:</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="latitude">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="@_en"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="@_no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@_sv"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <xsl:value-of select="."/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="longitude">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="@_en"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="@_no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@_sv"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <xsl:value-of select="."/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="address">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="@_en"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="@_no"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@_sv"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <div class="flex flex-col">
                    <xsl:for-each select="postOfficeBox">
                        <div>
                            <xsl:value-of select="."/>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select="street">
                        <div>
                            <xsl:value-of select="."/>
                        </div>
                    </xsl:for-each>
                    <xsl:if test="string-length(postcode) &gt; 0 or string-length(place) &gt; 0">
                        <div>
                            <xsl:for-each select="postcode">
                                <xsl:value-of select="."/>
                                <xsl:text> </xsl:text>
                            </xsl:for-each>
                            <xsl:for-each select="place">
                                <a class="text-blue-800 dark:text-blue-200 underline">
                                    <xsl:attribute name="href">
                                        <xsl:text>/alvin-place/</xsl:text>
                                        <xsl:value-of select="linkedRecordId"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="linkedRecord/place/authority[1]/geographic"/>
                                </a>
                            </xsl:for-each>
                        </div>
                    </xsl:if>
                    <xsl:for-each select="country">
                        <div>
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:value-of select="@_value_en"/>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:value-of select="@_value_no"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@_value_sv"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="summary">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:value-of select="@_en"/>
                        <xsl:call-template name="namelang"/>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:value-of select="@_no"/>
                        <xsl:call-template name="namelang"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@_sv"/>
                        <xsl:call-template name="namelang"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div style="white-space: pre-line;" class="w-full md:w-3/4 flex flex-grow pl-2">
                <xsl:value-of select="."/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="recordInfo">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text>Date of registration</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text>Dato for registrering</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Registreringsdatum</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <xsl:value-of select="tsCreated"/>
            </div>
        </div>
        <xsl:for-each select="updated[last()]">
            <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Updated</xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Oppdatert</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Uppdaterad</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="w-full md:w-3/4 flex flex-grow pl-2">
                    <xsl:value-of select="tsUpdated"/>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="namelang">
        <xsl:choose>
            <xsl:when test="@lang = 'eng'">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text> (English)</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text> (Engelsk)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> (Engelska)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@lang = 'nor'">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text> (Norwegian)</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text> (Norsk)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> (Norska)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text> (Swedish)</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text> (Svensk)</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> (Svenska)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="point">
        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text>Directions</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text>Veibeskrivelse</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Vägbeskrivning</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2">
                <a class="text-blue-800 dark:text-blue-200 underline">
                    <xsl:attribute name="href">
                        <xsl:text>https://maps.google.com/?q=</xsl:text>
                        <xsl:value-of select="latitude"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="longitude"/>
                    </xsl:attribute>Google Maps</a>
            </div>
        </div>    
    </xsl:template>
</xsl:stylesheet>
