<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="lang"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="baseURL">
        <xsl:value-of select="$domain_root"/>
        <xsl:text>/vocabulary/</xsl:text>
    </xsl:variable>
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
            <xsl:value-of select="recordInfo/id"/>
            <xsl:text>.rdf</xsl:text>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="@type = 'group'">
                    <xsl:choose>
                        <xsl:when test="nameInData = 'record'">
                            <xsl:text>Record type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'person'">
                            <xsl:text>Record type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'organisation'">
                            <xsl:text>Record type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'place'">
                            <xsl:text>Record type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'work'">
                            <xsl:text>Record type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="nameInData = 'location'">
                            <xsl:text>Record type: </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Metadata group: </xsl:text>
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
                    <xsl:text>Record link: </xsl:text>
                    <xsl:value-of select="nameInData"/>
                </xsl:when>
                <xsl:when test="@type = 'textVariable'">
                    <xsl:text>Text variable: </xsl:text>
                    <xsl:value-of select="nameInData"/>
                    <xsl:if test="attributeReferences/ref/linkedRecord/metadata/finalValue">
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="attributeReferences/ref/linkedRecord/metadata/finalValue"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@type = 'collectionVariable'">
                    <xsl:text>Collection variable: </xsl:text>
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
            <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                <div class="md:w-1/4 font-bold pl-2 break-all">
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
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:text>Label [en]</xsl:text>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'no']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:text>Benevning  [no]</xsl:text>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'sv']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:text>Benämning [sv]</xsl:text>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'en']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:text>Definition [en]</xsl:text>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'no']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:text>Definisjon [no]</xsl:text>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'sv']">
                    <xsl:if test="string-length(.) &gt; 0">
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:text>Definition [sv]</xsl:text>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <xsl:value-of select="text"/>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="refCollection">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
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
                    <div class="md:w-3/4 pl-2">
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
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Metadata group: </xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Metadatagrupp: </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Metadatagruppe: </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
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
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Text variable: </xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Tekstvariabel: </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Textvariabel: </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
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
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Collection variable: </xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Listevariabel: </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Listvariabel: </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
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
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Record link: </xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Post link: </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Postlänk: </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
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
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Attribute</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
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
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
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
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="substring-before(.,'T')"/>
                    </div>
                </div>
            </xsl:for-each>
        </div>
        <div class="footer flex justify-end py-4">
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
                                <td class="p-2 text-sm break-all">
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
</xsl:stylesheet>
