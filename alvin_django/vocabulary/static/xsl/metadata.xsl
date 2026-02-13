<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="lang"/>
    <xsl:variable name="baseURL">
        <xsl:text>http://127.0.0.1:8000/vocabulary/</xsl:text>
    </xsl:variable>
    <xsl:param name="sub"/>
    <xsl:param name="sub1"/>
    <xsl:param name="sub2"/>
    <xsl:param name="sub3"/>
    <xsl:param name="sub4"/>
    <xsl:param name="sub5"/>
    <xsl:param name="sub6"/>
    <xsl:param name="sub7"/>
    <xsl:param name="sub8"/>
    <xsl:param name="sub9"/>
    <xsl:param name="sub10"/>
    <xsl:param name="sub11"/>
    <xsl:param name="sub12"/>
    <xsl:param name="sub13"/>
    <xsl:param name="sub14"/>
    <xsl:param name="sub15"/>
    <xsl:param name="sub16"/>
    <xsl:param name="sub17"/>
    <xsl:param name="sub18"/>
    <xsl:param name="sub19"/>
    <xsl:param name="sub20"/>
    <xsl:param name="sub21"/>
    <xsl:param name="sub25"/>
    <xsl:param name="sub30"/>
    <xsl:param name="sub34"/>
    <xsl:param name="sub36"/>
    <xsl:param name="sub38"/>
    <xsl:param name="sub39"/>
    <xsl:param name="sub40"/>
    <xsl:param name="sub41"/>
    <xsl:param name="sub42"/>
    <xsl:param name="sub43"/>
    <xsl:param name="sub44"/>
    <xsl:param name="sub45"/>
    <xsl:param name="sub46"/>
    <xsl:param name="sub56"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/metadata"/>
    </xsl:template>
    <xsl:template match="metadata">
        <xsl:variable name="uri">
            <xsl:value-of select="$baseURL"/>
            <xsl:value-of select="recordInfo/id"/>
        </xsl:variable>
        <xsl:variable name="urirdf">
            <xsl:value-of select="$baseURL"/>
            <xsl:text>rdf/</xsl:text>
            <xsl:value-of select="recordInfo/id"/>
        </xsl:variable>
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
                    <xsl:if test="attributeReferences/ref/linkedRecord/metadata/finalValue">
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="attributeReferences/ref/linkedRecord/metadata/finalValue"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@type = 'recordLink'">
                    <xsl:text>Subclass (link): </xsl:text>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'textVariable'">
                    <xsl:text>Property (text): </xsl:text>
                    <xsl:value-of select="nameInData"/>
                    <xsl:if test="attributeReferences/ref/linkedRecord/metadata/finalValue">
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="attributeReferences/ref/linkedRecord/metadata/finalValue"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@type = 'collectionVariable'">
                    <xsl:text>Property (code): </xsl:text>
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
                    <xsl:text>Code: </xsl:text>
                    <xsl:value-of select="nameInData"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                    <xsl:text>)</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-t border-alvin">
                <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                    <xsl:text>URI</xsl:text>
                </div>
                <div class="w-full md:w-3/4 flex flex-grow pl-2" id="uri">
                    <xsl:value-of select="$uri"/>
                    <button class="btn flex items-right flex justify-end" data-clipboard-action="copy" data-clipboard-target="#uri">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6 float-right">
                            <title>Copy</title>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15.666 3.888A2.25 2.25 0 0 0 13.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 0 1-.75.75H9a.75.75 0 0 1-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 0 1-2.25 2.25H6.75A2.25 2.25 0 0 1 4.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 0 1 1.927-.184"/>
                        </svg>
                    </button>
                </div>
            </div>
            <xsl:if test="not(@type = 'itemCollection')">
                <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'en']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:text>Label [en]</xsl:text>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'no']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:text>Benevning  [no]</xsl:text>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'sv']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:text>Benämning [sv]</xsl:text>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'en']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:text>Definition [en]</xsl:text>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'no']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:text>Definisjon [no]</xsl:text>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'sv']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:text>Definition [sv]</xsl:text>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(@type = 'itemCollection')">
                <xsl:if test="recordInfo/dataDivider/linkedRecordId = 'alvin'">
                    <xsl:if test="$sub1 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub1"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub2 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub2"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub3 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub3"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub4 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub4"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub5 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub5"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub6 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub6"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub7 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub7"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub8 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub8"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub9 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub9"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub10 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub10"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub11 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub11"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub12 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub12"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub13 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub13"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub14 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub14"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub15 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub15"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub16 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub16"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub17 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub17"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub18 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub18"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub19 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub19"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub20 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub20"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub21 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub21"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub25 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub25"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub30 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub30"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub34 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub34"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub36 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub36"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub38 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub38"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub39 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub39"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub40 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub40"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub41 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub41"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub42 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub42"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub43 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub43"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub44 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub44"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub45 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub45"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub46 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub46"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub56 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub56"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:for-each select="refCollection">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
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
                    </div>
                    <div class="w-full md:w-3/4 flex-grow pl-2">
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$baseURL"/>
                                <xsl:value-of select="linkedRecordId"/>
                            </xsl:attribute>
                            <xsl:value-of select="$baseURL"/>
                            <xsl:value-of select="linkedRecordId"/>
                        </a>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="childReferences/childReference">
                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataGroup'">
                    <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                        <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                            <xsl:text>Subclass</xsl:text>
                        </div>
                        <div class="w-full md:w-3/4 flex-grow pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="ref/linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="ref/linkedRecord/metadata/nameInData"/>
                            </a>
                            <xsl:if test="ref/linkedRecord/metadata/attributeReferences/ref/linkedRecord/metadata/finalValue">
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="ref/linkedRecord/metadata/attributeReferences/ref/linkedRecord/metadata/finalValue"/>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                            <xsl:call-template name="repeat"/>
                        </div>
                    </div>
                </xsl:if>

                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataTextVariable'">
                    <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                        <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                            <xsl:text>Property (text)</xsl:text>
                        </div>
                        <div class="w-full md:w-3/4 flex-grow pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="ref/linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="ref/linkedRecord/metadata/nameInData"/>
                            </a>
                            <xsl:if test="ref/linkedRecord/metadata/attributeReferences/ref/linkedRecord/metadata/finalValue">
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="ref/linkedRecord/metadata/attributeReferences/ref/linkedRecord/metadata/finalValue"/>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                            <xsl:call-template name="repeat"/>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataCollectionVariable'">
                    <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                        <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                            <xsl:text>Property (code)</xsl:text>
                        </div>
                        <div class="w-full md:w-3/4 flex-grow pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="ref/linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="ref/linkedRecord/metadata/nameInData"/>
                            </a>
                            <xsl:call-template name="repeat"/>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataRecordLink'">
                    <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                        <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                            <xsl:text>Subclass (link):</xsl:text>
                        </div>
                        <div class="w-full md:w-3/4 flex-grow pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="ref/linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="ref/linkedRecord/metadata/nameInData"/>
                            </a>
                            <xsl:call-template name="repeat"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="attributeReferences/ref/linkedRecord/metadata">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                        <xsl:text>Attribute</xsl:text>
                    </div>
                    <div class="w-full md:w-3/4 flex-grow pl-2">
                        <xsl:value-of select="nameInData"/>
                        <xsl:text> (</xsl:text>
                        <xsl:choose>
                            <xsl:when test="finalValue">
                                <xsl:value-of select="finalValue"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a class="text-blue-800 dark:text-blue-200 underline">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$baseURL"/>
                                        <xsl:value-of select="../../linkedRecordId"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="refCollection/linkedRecord/metadata/nameInData"/>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>)</xsl:text>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="recordInfo/updated[last()]/tsUpdated">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:text>Modified</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:text>Endret</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Ändrad</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="w-full md:w-3/4 flex-grow pl-2">
                        <xsl:value-of select="substring-before(.,'T')"/>
                    </div>
                </div>
            </xsl:for-each>
        </div>
      
            <div class="flex justify-end py-4">
                <a class="flex flex-row bg-orange-600 hover:bg-orange-700 focus:bg-blue-800 text-white font-semibold py-2 px-4 rounded-full">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$urirdf"/>
                    </xsl:attribute>
                    <xsl:text>RDF/XML </xsl:text>
                </a>
            </div>
        
        <xsl:if test="@type = 'itemCollection'">
            <p class="pb-2">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text>Click on the column header to sort.</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text>Klikk på kolonneoverskriften for å sortere.</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Klicka på kolumnrubriken för att sortera.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </p>
            <div class="relative overflow-x-auto max-sm:pb-4">
                <table class="sortable w-full bg-white" id="tablerows">
                    <thead>
                        <tr>
                            <th class="bg-dark-alvin text-white p-2">
                                <xsl:choose>
                                    <xsl:when test="$lang = 'en'">
                                        <xsl:text>Code</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$lang = 'no'">
                                        <xsl:text>Kode</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Kod</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </th>
                            <th class="bg-dark-alvin text-white p-2">English</th>
                            <th class="bg-dark-alvin text-white p-2">Norsk</th>
                            <th class="bg-dark-alvin text-white p-2">Svenska</th>
                        </tr>
                    </thead>
                    <tbody class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
                        <xsl:for-each select="collectionItemReferences/ref">
                            <xsl:sort select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']/text"/>
                            <tr class="border-b border-alvin">
                                <td class="p-2 text-sm">
                                    <a class="text-blue-800 dark:text-blue-200 underline">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="linkedRecordId"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="linkedRecord/metadata/nameInData"/>
                                    </a>
                                </td>
                                <td class="p-2 text-sm">
                                    <xsl:value-of select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                                </td>
                                <td class="p-2 text-sm">
                                    <xsl:value-of select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'no']/text"/>
                                </td>
                                <td class="p-2 text-sm">
                                    <xsl:value-of select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']/text"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </div>
        </xsl:if>
        <!--
        <xsl:choose>
            <xsl:when test="recordInfo/id = 'recordGroup'">
                <xsl:call-template name="overview"/>
                <ul class="list-disc list-inside">
                    <xsl:for-each select="document('https://cora.alvin-portal.org/rest/record/metadata/recordGroup')/record/data/metadata/childReferences">
                        <xsl:call-template name="childReference"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'personGroup'">
                <xsl:call-template name="overview"/>
                <ul class="list-disc list-inside">
                    <xsl:for-each select="document('https://cora.alvin-portal.org/rest/record/metadata/personGroup')/record/data/metadata/childReferences">
                        <xsl:call-template name="childReference"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'organisationGroup'">
                <xsl:call-template name="overview"/>
                <ul class="list-disc list-inside">
                    <xsl:for-each select="document('https://cora.alvin-portal.org/rest/record/metadata/organisationGroup')/record/data/metadata/childReferences">
                        <xsl:call-template name="childReference"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'placeGroup'">
                <xsl:call-template name="overview"/>
                <ul class="list-disc list-inside">
                    <xsl:for-each select="document('https://cora.alvin-portal.org/rest/record/metadata/placeGroup')/record/data/metadata/childReferences">
                        <xsl:call-template name="childReference"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'workGroup'">
                <xsl:call-template name="overview"/>
                <ul class="list-disc list-inside">
                    <xsl:for-each select="document('https://cora.alvin-portal.org/rest/record/metadata/workGroup')/record/data/metadata/childReferences">
                        <xsl:call-template name="childReference"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'locationGroup'">
                <xsl:call-template name="overview"/>
                <ul class="list-disc list-inside">
                    <xsl:for-each select="document('https://cora.alvin-portal.org/rest/record/metadata/locationGroup')/record/data/metadata/childReferences">
                        <xsl:call-template name="childReference"/>
                    </xsl:for-each>
                </ul>
            </xsl:when>
        </xsl:choose>
        -->
    </xsl:template>
    <xsl:template name="repeat">
        <xsl:choose>
            <xsl:when test="repeatMin = '1'">
                <span class="italic">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text> Mandatory -</xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text> Obligatorisk -</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> Obligatorisk -</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="repeatMax = '1'">
                <span class="italic">

                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text> Not repeatable</xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text> Ikke repeterbar</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> Ej repeterbar</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="italic">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text> Repeatable</xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text> Repeterbar</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> Repeterbar</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="overview">
        <h2 class="text-2xl md:text-3xl font-bold pb-2">
            <xsl:text>Core class: </xsl:text>
            <xsl:value-of select="substring-before(recordInfo/id,'Group')"/>
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text> - overview</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text> - oversikt</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> - översikt</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
    </xsl:template>
    <xsl:template name="sub">
        <xsl:param name="baseURL" select="$baseURL"/>
        <xsl:param name="sub" select="$sub"/>
        <xsl:if test="not(contains($sub, 'New'))">
            <xsl:if test="not(contains($sub, 'Update'))">
                <xsl:if test="not(contains($sub, 'Search'))">
                    <xsl:if test="not(contains($sub, 'User'))">
                        <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                            <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                                <xsl:choose>
                                    <xsl:when test="contains(recordInfo/id,'Group')">
                                        <xsl:text>Subclass Of</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="contains(recordInfo/id,'Link')">
                                        <xsl:text>Subclass Of</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Property Of</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <a class="text-blue-800 dark:text-blue-200 underline">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$baseURL"/>
                                        <xsl:value-of select="$sub"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="$sub"/>
                                </a>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="childReference">
        <xsl:for-each select="childReference">
            <xsl:variable name="url">
                <xsl:value-of select="ref/actionLinks/read/url"/>
            </xsl:variable>
            <xsl:for-each select="document($url)/record/data/metadata">
                <xsl:variable name="nameInData">
                    <xsl:value-of select="nameInData"/>
                </xsl:variable>
                <li>
                    <a class="text-blue-800 dark:text-blue-200 underline">
                        <xsl:attribute name="href">
                            <xsl:value-of select="recordInfo/id"/>
                        </xsl:attribute>
                        <xsl:value-of select="$nameInData"/>
                    </a>
                    <ul class="list-disc list-inside pl-4">
                        <xsl:for-each select="childReferences/childReference">
                            <xsl:variable name="url1">
                                <xsl:value-of select="ref/actionLinks/read/url"/>
                            </xsl:variable>
                            <li>
                                <a class="text-blue-800 dark:text-blue-200 underline">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="ref/linkedRecordId"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="document($url1)/record/data/metadata/nameInData"/>
                                </a>
                                <ul class="list-disc list-inside pl-4">
                                    <xsl:for-each select="document($url1)/record/data/metadata/childReferences/childReference">
                                        <xsl:variable name="url2">
                                            <xsl:value-of select="ref/actionLinks/read/url"/>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="document($url2)/record/data/metadata/nameInData = 'msItem02'">
                                                <li>msItem02 -- msItem06</li>
                                            </xsl:when>
                                            <xsl:when test="document($url2)/record/data/metadata/nameInData = 'component02'">
                                                <li>component02 -- component06</li>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <li>
                                                    <a class="text-blue-800 dark:text-blue-200 underline">
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="ref/linkedRecordId"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="document($url2)/record/data/metadata/nameInData"/>
                                                    </a>
                                                    <ul class="list-disc list-inside pl-4">
                                                        <xsl:for-each select="document($url2)/record/data/metadata/childReferences/childReference">
                                                            <xsl:variable name="url3">
                                                                <xsl:value-of select="ref/actionLinks/read/url"/>
                                                            </xsl:variable>
                                                            <li>
                                                                <a class="text-blue-800 dark:text-blue-200 underline">
                                                                    <xsl:attribute name="href">
                                                                        <xsl:value-of select="ref/linkedRecordId"/>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="document($url3)/record/data/metadata/nameInData"/>
                                                                </a>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </li>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </xsl:for-each>
                    </ul>
                </li>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
