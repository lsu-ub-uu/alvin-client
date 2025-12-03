<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
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
    <xsl:param name="sub44"/>
    <xsl:param name="sub46"/>
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
        <div class=" [&amp;>*:nth-child(odd)]:bg-gray-100 [&amp;>*:nth-child(even)]:bg-white pb-4">
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
                    <xsl:if test="$sub44 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub44"/>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$sub46 != 'None'">
                        <xsl:call-template name="sub">
                            <xsl:with-param name="baseURL" select="$baseURL"/>
                            <xsl:with-param name="sub" select="$sub46"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:for-each select="refCollection">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <div class="w-full md:w-1/4 flex-grow font-bold pl-2">
                        <xsl:text>Controlled list</xsl:text>
                    </div>
                    <div class="w-full md:w-3/4 flex-grow pl-2">
                        <a class="text-blue-800 underline">
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
                            <a class="text-blue-800 underline">
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
                            <a class="text-blue-800 underline">
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
                            <a class="text-blue-800 underline">
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
                            <xsl:text>Property (link)</xsl:text>
                        </div>
                        <div class="w-full md:w-3/4 flex-grow pl-2">
                            <a class="text-blue-800 underline">
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
                                <a class="text-blue-800 underline">
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
        <xsl:if test="not(@type = 'itemCollection')">
            <div class="flex justify-end py-4">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$urirdf"/>
                    </xsl:attribute>
                    <button class="flex flex-row bg-orange-600 hover:bg-gray-700 focus:bg-blue-800 text-white font-semibold py-2 px-4 rounded-full"> RDF/XML </button>
                </a>
            </div>
        </xsl:if>
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
                    <tbody class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white">
                        <xsl:for-each select="collectionItemReferences/ref">
                            <xsl:sort select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']/text"/>
                            <tr class="border-b border-alvin">
                                <td class="p-2 text-sm">
                                    <a class="text-blue-800 underline">
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

        <xsl:choose>
            <xsl:when test="recordInfo/id = 'recordGroup'">
                <xsl:call-template name="overview"/>
                <ul class="py-2 list-disc list-inside">
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/typeOfResourceCollectionVar">typeOfResource</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/collectionTypeOfResourceCollectionVar">collection</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/productionMethodCollectionVar">productionMethod</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/titleGroup">title</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/variantTitleGroup">variantTitle</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/physicalLocationGroup">physicalLocation</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/heldByGroup">heldBy</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/locationLink">location</a> (property: link)</li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/sublocationTextVar">sublocation</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/subcollectionGroup">subcollection</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionArbogaCollectionVar">arboga</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionDigitalCollectionVar">digital</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionFauppsalaCollectionVar">fauppsala</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionKiCollectionVar">ki</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionKvaCollectionVar">kva</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionLinkopingCollectionVar">linkoping</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionLuCollectionVar">lu</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionMusikverketCollectionVar">musikverket</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionOruCollectionVar">oru</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionUioCollectionVar">uio</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/subcollectionUuCollectionVar">uu</a> (property: code)</li>
                                </ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/shelfMarkTextVar">shelfMark</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/formerShelfMarkTextVar">formerShelfMark</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/noteFieldGeneralTextVar">note</a> {general} (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/noteFieldInternalTextVar">note</a> {internal} (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/agentPersonGroup">agent</a> {person} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/personLink">person</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/agentOrganisationGroup">agent</a> {organisation} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/organisationLink">organisation</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/languageCollectionVar">language</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/adminMetadataGroup">adminMetadata</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/descriptionLanguageCollectionVar">descriptionLanguage</a> (property: code)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/editionStatementTextVar">editionStatement</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/originPlaceGroup">originPlace</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/historicalCountryCollectionVar">historicalCountry</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/publicationTextVar">publication</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/originDateGroup">originDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/dateOtherGroup">dateOther</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/noteFieldGeneralTextVar">note</a> {general} (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/dimensionsGroup">dimensions</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/heightTextVar">height</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/widthTextVar">width</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/depthTextVar">depth</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/diameterTextVar">diameter</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dimensionUnitCollectionVar">unit</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/scopeCollectionVar">scope</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/measureGroup">measure</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/weightTextVar">weight</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/weightUnitCollectionVar">unit</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/physicalDescriptionGroup">physicalDescription</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/noteFieldPhysicalDescriptionTextVar">note</a> (property: text)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/baseMaterialCollectionVar">baseMaterial</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/appliedMaterialCollectionVar">appliedMaterial</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/summaryTextVar">summary</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/sourceDocTextVar">transcription</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/tableOfContentsTextVar">tableOfContents</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/listBiblTextVar">listBibl</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldTextVar">note</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldInternalTextVar">note</a> {internal} (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/relatedToGroup">relatedTo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordLink">record</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/partGroup">part</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/partNumberTextVar">partNumber</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/genreFormCollectionVar">genreForm</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/subjectGroup">subject</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/topicTextVar">topic</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/genreFormTextVar">genreForm</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/geographicCoverageTextVar">geographicCoverage</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/temporalTextVar">temporal</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/occupationTextVar">occupation</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/subjectPersonGroup">subject</a> {person} (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/personLink">person</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/subjectOrganisationGroup">subject</a> {organisation} (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/organisationLink">organisation</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/subjectPlaceGroup">subject</a> {place} (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/classificationTextVar">classification</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/accessPolicyTextVar">accessPolicy</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/bindingDescGroup">bindingDesc</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/bindingTextVar">binding</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/decoNoteTextVar">decoNote</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/decoNoteTextVar">decoNote</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/identifierTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/workLink">work</a> (property: link)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/levelCollectionCollectionVar">level</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/extentUnitShelfMetresTextVar">extent</a> {shelfMetres} (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/extentUnitArchivalUnitsTextVar">extent</a> {archivalUnits} (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/otherfindaidTextVar">otherfindaid</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/appraisalTextVar">weeding</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/relatedmaterialTextVar">relatedmaterial</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/arrangementTextVar">arrangement</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/accrualsTextVar">accruals</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/locusTextVar">locus</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/incipitTextVar">incipit</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/explicitTextVar">explicit</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/rubricTextVar">rubric</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/finalRubricTextVar">finalRubric</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicKeyCollectionVar">musicKey</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicKeyOtherTextVar">musicKeyOther</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicMediumCollectionVar">musicMedium</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicMediumOtherTextVar">musicMediumOther</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicNotationCollectionVar">musicNotation</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/cartographicAttributesGroup">cartographicAttributes</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/scaleTextVar">scale</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/projectionTextVar">projection</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/coordinatesTextVar">coordinates</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/appraisalGroup">appraisal</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/appraisalValueTextVar">value</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/appraisalCurrencyTextVar">currency</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/edgeGroup">edge</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/edgeDescriptionCollectionVar">description</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/legendTextVar">legend</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/axisGroup">axis</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/clockCollectionVar">clock</a> (property: code)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/conservationStateCollectionVar">conservationState</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/obverseGroup">obverse</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/nudsDescriptionTextVar">description</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/legendTextVar">legend</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/reverseGroup">reverse</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/nudsDescriptionTextVar">description</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/legendTextVar">legend</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/countermarkTextVar">countermark</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/msContentsGroup">msContents</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/msItem01Group">msItem01</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/locusTextVar">locus</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/titleGroup">title</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/agentPersonGroup">agent</a> {person} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/personLink">person</a> (property: link)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/languageCollectionVar">language</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/originPlaceGroup">originPlace</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/historicalCountryCollectionVar">historicalCountry</a> (property: code)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/originDateGroup">originDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/physicalDescriptionGroup">physicalDescription</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                                <a href="/vocabulary/noteFieldPhysicalDescriptionTextVar">note</a> (property: text)</li></ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/incipitTextVar">incipit</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/explicitTextVar">explicit</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/rubricTextVar">rubric</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/finalRubricTextVar">finalRubric</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/listBiblTextVar">listBibl</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldTextVar">note</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/relatedToGroup">relatedTo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/recordLink">record</a> (property: link)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/partGroup">part</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                    <li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/partNumberTextVar">partNumber</a> (property: text)</li>
                                                    <li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/msItem02Group">msItem02</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/msItem03Group">msItem03</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                    <li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/msItem04Group">msItem04</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/msItem05Group">msItem05</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                                    <li>
                                                                        <a class="text-blue-800 underline" href="/vocabulary/msItem06Group">msItem06</a> (subclass) </li>
                                                                </ul>
                                                            </li>
                                                        </ul>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/descriptionOfSubordinateComponentsGroup">descriptionOfSubordinateComponents</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/component01Group">component01</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/levelCollectionComponentCollectionVar">level</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/unitidTextVar">unitid</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/titleGroup">title</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/agentPersonGroup">agent</a> {person} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/personLink">person</a> (property: link)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/agentOrganisationGroup">agent</a> {organisation} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/organisationLink">organisation</a> (property: link)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/originDateGroup">originDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldGeneralTextVar">note</a> {general} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/identifierAccessionNumberTextVar">identifier</a> {accessionNumber} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/relatedToGroup">relatedTo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/recordLink">record</a> (property: link)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/partGroup">part</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                    <li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/partNumberTextVar">partNumber</a> (property: text)</li>
                                                    <li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/accessPolicyTextVar">accessPolicy</a> (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/component02Group">component02</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/component03Group">component03</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                    <li>
                                                        <a class="text-blue-800 underline" href="/vocabulary/component04Group">component04</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                            <li>
                                                                <a class="text-blue-800 underline" href="/vocabulary/component05Group">component05</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                                                    <li>
                                                                        <a class="text-blue-800 underline" href="/vocabulary/component06Group">component06</a> (subclass) </li>
                                                                </ul>
                                                            </li>
                                                        </ul>
                                                    </li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/recordInfoAlvinRecordGroup">recordInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/urnAlvinTextVar">urn</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordTypeAlvinLink">type</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/validationTypeAlvinLink">validationType</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/permissionUnitLink">permissionUnit</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/visibilityCollectionVar">visibility</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsVisibilityTextVar">tsVisibility</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/createdByAlvinLink">createdBy</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsCreatedAlvinTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/updatedAlvinGroup">updated</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/updatedByAlvinLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/tsUpdatedAlvinTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/fileSectionGroup">fileSection</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/rightsCollectionVar">rights</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/digitalOriginCollectionVar">digitalOrigin</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/fileGroupGroup">fileGroup</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/internetMediaTypeCollectionVar">internetMediaType</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/fileGroupTypeCollectionVar">type</a> (property: code)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/fileGroup">file</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/fileTypeCollectionVar">type</a> (property: code)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/labelTextVar">label</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/fileLocationLink">fileLocation</a> (property: link)</li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'personGroup'">
                <xsl:call-template name="overview"/>
                <ul class="py-2 list-disc list-inside">
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/authorityPersonGroup">authority</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/namePersonGroup">name</a> {personal} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartFamilyTextVar">namePart</a> {family} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartGivenTextVar">namePart</a> {given} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartNumerationTextVar">namePart</a> {numeration} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/familyNameCollectionVar">familyName</a> (property: code)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/personInfoGroup">personInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/birthDateGroup">birthDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/deathDateGroup">deathDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/birthPlaceGroup">birthPlace</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                </ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/deathPlaceGroup">deathPlace</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                </ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/nationalityGroup">nationality</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/genderCollectionVar">gender</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/variantPersonGroup">variant</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/nameVariantPersonGroup">name</a> {personal} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartFamilyTextVar">namePart</a> {family} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartGivenTextVar">namePart</a> {given} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartNumerationTextVar">namePart</a> {numeration} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/nameParttermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/fieldOfEndeavorTextVar">fieldOfEndeavor</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldAuthorityTextVar">note</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/identifierAuthorityTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/relatedPersonGroup">related</a> {person} (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/personLink">person</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/relatedOrganisationGroup">related</a> {organisation} (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/organisationLink">organisation</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/recordInfoAlvinGroup">recordInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordTypeAlvinLink">type</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/validationTypeAlvinLink">validationType</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/createdByAlvinLink">createdBy</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsCreatedAlvinTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/updatedAlvinGroup">updated</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/updatedByAlvinLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/tsUpdatedAlvinTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'organisationGroup'">
                <xsl:call-template name="overview"/>
                <ul class="py-2 list-disc list-inside">
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/authorityOrganisationGroup">authority</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/nameOrganisationGroup">name</a> {corporate} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartOrganisationTextVar">namePart</a> {corporateName} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartSubordinateTextVar">namePart</a> {subordinate} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/organisationInfoGroup">organisationInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/variantOrganisationGroup">variant</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/nameVariantOrganisationGroup">name</a> {corporate} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartOrganisationTextVar">namePart</a> {corporateName} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartSubordinateTextVar">namePart</a> {subordinate} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldAuthorityTextVar">note</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/identifierAuthorityTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/addressGroup">address</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/addressPostOfficeBoxTextVar">postOfficeBox</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/addressStreetTextVar">street</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/addressPostcodeBoxTextVar">postcode</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/relatedOrganisationTypeGroup">related</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/organisationLink">organisation</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/recordInfoAlvinGroup">recordInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordTypeAlvinLink">type</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/validationTypeAlvinLink">validationType</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/createdByAlvinLink">createdBy</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsCreatedAlvinTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/updatedAlvinGroup">updated</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/updatedByAlvinLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/tsUpdatedAlvinTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'placeGroup'">
                <xsl:call-template name="overview"/>
                <ul class="py-2 list-disc list-inside">
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/authorityPlaceGroup">authority</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/geographicPlaceTextVar">geographic</a> (property: text)</li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/variantPlaceGroup">variant</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/geographicPlaceTextVar">geographic</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/pointGroup">point</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/latitudeTextVar">latitude</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/longitudeTextVar">longitude</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/recordInfoAlvinGroup">recordInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordTypeAlvinLink">type</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/validationTypeAlvinLink">validationType</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/createdByAlvinLink">createdBy</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsCreatedAlvinTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/updatedAlvinGroup">updated</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/updatedByAlvinLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/tsUpdatedAlvinTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'workGroup'">
                <xsl:call-template name="overview"/>
                <ul class="py-2 list-disc list-inside">
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/titleGroup">title</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/variantTitleGroup">variantTitle</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/incipitTextVar">incipit</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/formOfWorkCollectionVar">formOfWork</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/agentPersonGroup">agent</a> {person} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/personLink">person</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/agentOrganisationGroup">agent</a> {organisation} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/organisationLink">organisation</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/originDateGroup">originDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/dateOtherGroup">dateOther</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/noteFieldGeneralTextVar">note</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/originPlaceGroup">originPlace</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/historicalCountryCollectionVar">historicalCountry</a> (property: code)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicMediumCollectionVar">musicMedium</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicMediumOtherTextVar">musicMediumOther</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/numericDesignationOfMusicalWorkGroup">numericDesignationOfMusicalWork</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/musicSerialNumberTextVar">musicSerialNumber</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/musicOpusNumberTextVar">musicOpusNumber</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/musicThematicNumberTextVar">musicThematicNumber</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicKeyCollectionVar">musicKey</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/musicKeyOtherTextVar">musicKeyOther</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldGeneralTextVar">note</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/listBiblTextVar">listBibl</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/genreFormMusicCollectionVar">genreForm</a> (property: code)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/pointGroup">point</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/latitudeTextVar">latitude</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/longitudeTextVar">longitude</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/noteFieldThesisTextVar">note</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/recordInfoAlvinGroup">recordInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordTypeAlvinLink">type</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/validationTypeAlvinLink">validationType</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/createdByAlvinLink">createdBy</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsCreatedAlvinTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/updatedAlvinGroup">updated</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/updatedByAlvinLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/tsUpdatedAlvinTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'locationGroup'">
                <xsl:call-template name="overview"/>
                <ul class="py-2 list-disc list-inside">
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/authorityOrganisationGroup">authority</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                <a class="text-blue-800 underline" href="/vocabulary/nameOrganisationGroup">name</a> {corporate} (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartOrganisationTextVar">namePart</a> {corporateName} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartSubordinateTextVar">namePart</a> {subordinate} (property: text)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/organisationInfoGroup">organisationInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/startDateGroup">startDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/endDateGroup">endDate</a> (subclass)<ul class="py-2 list-disc list-inside pl-4"><li>
                                        <a class="text-blue-800 underline" href="/vocabulary/dateGroup">date</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a class="text-blue-800 underline" href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/descriptorCollectionVar">descriptor</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/summaryWithLangTextVar">summary</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/identifierLocationTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/emailAddressTextVar">email</a> (property: text)</li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/addressGroup">address</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/addressPostOfficeBoxTextVar">postOfficeBox</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/addressStreetTextVar">street</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/addressPostcodeBoxTextVar">postcode</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/pointGroup">point</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/latitudeTextVar">latitude</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/longitudeTextVar">longitude</a> (property: text)</li>
                        </ul>
                    </li>

                    <li>
                        <a class="text-blue-800 underline" href="/vocabulary/recordInfoAlvinGroup">recordInfo</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/recordTypeAlvinLink">type</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/validationTypeAlvinLink">validationType</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/createdByAlvinLink">createdBy</a> (property: link)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/tsCreatedAlvinTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a class="text-blue-800 underline" href="/vocabulary/updatedAlvinGroup">updated</a> (subclass)<ul class="py-2 list-disc list-inside pl-4">
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/updatedByAlvinLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a class="text-blue-800 underline" href="/vocabulary/tsUpdatedAlvinTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
        </xsl:choose>
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
                                    <xsl:otherwise>
                                        <xsl:text>Property Of</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            <div class="w-full md:w-3/4 flex-grow pl-2">
                                <a class="text-blue-800 underline">
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
</xsl:stylesheet>
