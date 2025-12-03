<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/metadata"/>
    </xsl:template>
    <xsl:template match="metadata">
        <xsl:variable name="baseURL">
            <xsl:text>http://127.0.0.1:8000/vocabulary/</xsl:text>
        </xsl:variable>
        <xsl:variable name="uri">
            <xsl:value-of select="$baseURL"/>
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
                        <xsl:otherwise>
                            <xsl:text>Class: </xsl:text>
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
                    <xsl:text>Controlled value: </xsl:text>
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
        <h2>
            <xsl:value-of select="$title"/>
        </h2>
        <div class="vocab">
            <div class="row">
                <div class="col-25">URI</div>
                <div class="col-75">
                    <xsl:value-of select="$uri"/>
                </div>
            </div>
            <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'en']">
                <xsl:if test="string-length(.) &gt; 0">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Label [en]</xsl:text>
                        </div>
                        <div class="col-75">
                            <xsl:value-of select="text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'no']">
                <xsl:if test="string-length(.) &gt; 0">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Label [no]</xsl:text>
                        </div>
                        <div class="col-75">
                            <xsl:value-of select="text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'sv']">
                <xsl:if test="string-length(.) &gt; 0">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Label [sv]</xsl:text>
                        </div>
                        <div class="col-75">
                            <xsl:value-of select="text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'en']">
                <xsl:if test="string-length(.) &gt; 0">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Definition [en]</xsl:text>
                        </div>
                        <div class="col-75">
                            <xsl:value-of select="text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'no']">
                <xsl:if test="string-length(.) &gt; 0">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Definition [no]</xsl:text>
                        </div>
                        <div class="col-75">
                            <xsl:value-of select="text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'sv']">
                <xsl:if test="string-length(.) &gt; 0">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Definition [sv]</xsl:text>
                        </div>
                        <div class="col-75">
                            <xsl:value-of select="text"/>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="refCollection">
                <div class="row">
                    <div class="col-25">
                        <xsl:text>Controlled list</xsl:text>
                    </div>
                    <div class="col-75">
                        <a>
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
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Class</xsl:text>
                        </div>
                        <div class="col-75">
                            <a>
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
                            <xsl:choose>
                                <xsl:when test="repeatMin = '1'">
                                    <xsl:text> Mandatory -</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="repeatMax = '1'">
                                    <xsl:text> Not repeatable</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> Repeatable</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataTextVariable'">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Property (text)</xsl:text>
                        </div>
                        <div class="col-75">
                            <a>
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
                            <xsl:choose>
                                <xsl:when test="repeatMin = '1'">
                                    <xsl:text> Mandatory -</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="repeatMax = '1'">
                                    <xsl:text> Not repeatable</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> Repeatable</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataCollectionVariable'">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Property (code)</xsl:text>
                        </div>
                        <div class="col-75">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="ref/linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="ref/linkedRecord/metadata/nameInData"/>
                            </a>
                            <xsl:choose>
                                <xsl:when test="repeatMin = '1'">
                                    <xsl:text> Mandatory -</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="repeatMax = '1'">
                                    <xsl:text> Not repeatable</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> Repeatable</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </xsl:if>
                <xsl:if test="ref/linkedRecord/metadata/recordInfo/validationType/linkedRecordId = 'metadataRecordLink'">
                    <div class="row">
                        <div class="col-25">
                            <xsl:text>Property (link)</xsl:text>
                        </div>
                        <div class="col-75">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$baseURL"/>
                                    <xsl:value-of select="ref/linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="ref/linkedRecord/metadata/nameInData"/>
                            </a>
                            <xsl:choose>
                                <xsl:when test="repeatMin = '1'">
                                    <xsl:text> Mandatory -</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="repeatMax = '1'">
                                    <xsl:text> Not repeatable</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> Repeatable</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="attributeReferences/ref/linkedRecord/metadata">
                <div class="row">
                    <div class="col-25">
                        <xsl:text>Attribute</xsl:text>
                    </div>
                    <div class="col-75">
                        <xsl:value-of select="nameInData"/>
                        <xsl:text> (</xsl:text>
                        <xsl:choose>
                            <xsl:when test="finalValue">
                                <xsl:value-of select="finalValue"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <a>
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
                <div class="row">
                    <div class="col-25">
                        <xsl:text>Modified</xsl:text>
                    </div>
                    <div class="col-75">
                        <xsl:value-of select="substring-before(.,'T')"/>
                    </div>
                </div>
            </xsl:for-each>
        </div>
        <xsl:if test="@type = 'itemCollection'">
            <h2>List of values</h2>
            <p>Click on the column header to sort.</p>
            <table class="sortable" id="tablerows">
                <tr>
                    <th>Code</th>
                    <th>English</th>
                    <th>Norsk</th>
                    <th>Svenska</th>
                </tr>
                <xsl:for-each select="collectionItemReferences/ref">
                    <xsl:sort select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']/text"/>
                    <tr>
                        <td>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:value-of select="linkedRecord/metadata/nameInData"/>
                            </a>
                        </td>
                        <td>
                            <xsl:value-of select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'en']/text"/>
                        </td>
                        <td>
                            <xsl:value-of select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'no']/text"/>
                        </td>
                        <td>
                            <xsl:value-of select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']/text"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="recordInfo/id = 'recordGroup'">
                <h2>Core class: record overview</h2>
                <ul>
                    <li>
                        <a href="/vocabulary/typeOfResourceCollectionVar">typeOfResource</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/collectionTypeOfResourceCollectionVar">collection</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/productionMethodCollectionVar">productionMethod</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/titleGroup">title</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/variantTitleGroup">variantTitle</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/physicalLocationGroup">physicalLocation</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/heldByGroup">heldBy</a> (class)<ul><li>
                                        <a href="/vocabulary/locationLink">location</a> (property: link)</li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/sublocationTextVar">sublocation</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/subcollectionGroup">subcollection</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/subcollectionArbogaCollectionVar">arboga</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionDigitalCollectionVar">digital</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionFauppsalaCollectionVar">fauppsala</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionKiCollectionVar">ki</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionKvaCollectionVar">kva</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionLinkopingCollectionVar">linkoping</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionLuCollectionVar">lu</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionMusikverketCollectionVar">musikverket</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionOruCollectionVar">oru</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionUioCollectionVar">uio</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/subcollectionUuCollectionVar">uu</a> (property: code)</li>
                                </ul>
                            </li>
                            <li>
                                <a href="/vocabulary/shelfMarkTextVar">shelfMark</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/formerShelfMarkTextVar">formerShelfMark</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/noteFieldGeneralTextVar">note</a> {general} (property: text)</li>
                            <li>
                                <a href="/vocabulary/noteFieldInternalTextVar">note</a> {internal} (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/agentPersonGroup">agent</a> {person} (class)<ul>
                            <li>
                                <a href="/vocabulary/personLink">person</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/agentOrganisationGroup">agent</a> {organisation} (class)<ul>
                            <li>
                                <a href="/vocabulary/organisationLink">organisation</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/languageCollectionVar">language</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/adminMetadataGroup">adminMetadata</a> (class)<ul><li>
                                <a href="/vocabulary/descriptionLanguageCollectionVar">descriptionLanguage</a> (property: code)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/editionStatementTextVar">editionStatement</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/originPlaceGroup">originPlace</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/historicalCountryCollectionVar">historicalCountry</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/publicationTextVar">publication</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/originDateGroup">originDate</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/dateOtherGroup">dateOther</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/noteFieldGeneralTextVar">note</a> {general} (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/dimensionsGroup">dimensions</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/heightTextVar">height</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/widthTextVar">width</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/depthTextVar">depth</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/diameterTextVar">diameter</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/dimensionUnitCollectionVar">unit</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/scopeCollectionVar">scope</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/measureGroup">measure</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/weightTextVar">weight</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/weightUnitCollectionVar">unit</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/physicalDescriptionGroup">physicalDescription</a> (class)<ul><li>
                                <a href="/vocabulary/noteFieldPhysicalDescriptionTextVar">note</a> (property: text)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/baseMaterialCollectionVar">baseMaterial</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/appliedMaterialCollectionVar">appliedMaterial</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/summaryTextVar">summary</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/sourceDocTextVar">transcription</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/tableOfContentsTextVar">tableOfContents</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/listBiblTextVar">listBibl</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/noteFieldTextVar">note</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/noteFieldInternalTextVar">note</a> {internal} (property: text)</li>
                    <li>
                        <a href="/vocabulary/relatedToGroup">relatedTo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/recordLink">record</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/partGroup">part</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/partNumberTextVar">partNumber</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/genreFormCollectionVar">genreForm</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/subjectGroup">subject</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/topicTextVar">topic</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/genreFormTextVar">genreForm</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/geographicCoverageTextVar">geographicCoverage</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/temporalTextVar">temporal</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/occupationTextVar">occupation</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/subjectPersonGroup">subject</a> {person} (class)<ul><li>
                                <a href="/vocabulary/personLink">person</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/subjectOrganisationGroup">subject</a> {organisation} (class)<ul><li>
                                <a href="/vocabulary/organisationLink">organisation</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/subjectPlaceGroup">subject</a> {place} (class)<ul><li>
                                <a href="/vocabulary/placeLink">place</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/classificationTextVar">classification</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/accessPolicyTextVar">accessPolicy</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/bindingDescGroup">bindingDesc</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/bindingTextVar">binding</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/decoNoteTextVar">decoNote</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/decoNoteTextVar">decoNote</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/identifierTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/workLink">work</a> (property: link)</li>
                    <li>
                        <a href="/vocabulary/levelCollectionCollectionVar">level</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/extentUnitShelfMetresTextVar">extent</a> {shelfMetres} (property: text)</li>
                    <li>
                        <a href="/vocabulary/extentUnitArchivalUnitsTextVar">extent</a> {archivalUnits} (property: text)</li>
                    <li>
                        <a href="/vocabulary/otherfindaidTextVar">otherfindaid</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/appraisalTextVar">weeding</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/relatedmaterialTextVar">relatedmaterial</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/arrangementTextVar">arrangement</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/accrualsTextVar">accruals</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/locusTextVar">locus</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/incipitTextVar">incipit</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/explicitTextVar">explicit</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/rubricTextVar">rubric</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/finalRubricTextVar">finalRubric</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/musicKeyCollectionVar">musicKey</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/musicKeyOtherTextVar">musicKeyOther</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/musicMediumCollectionVar">musicMedium</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/musicMediumOtherTextVar">musicMediumOther</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/musicNotationCollectionVar">musicNotation</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/cartographicAttributesGroup">cartographicAttributes</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/scaleTextVar">scale</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/projectionTextVar">projection</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/coordinatesTextVar">coordinates</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/appraisalGroup">appraisal</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/appraisalValueTextVar">value</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/appraisalCurrencyTextVar">currency</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/edgeGroup">edge</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/edgeDescriptionCollectionVar">description</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/legendTextVar">legend</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/axisGroup">axis</a> (class)<ul><li>
                                <a href="/vocabulary/clockCollectionVar">clock</a> (property: code)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/conservationStateCollectionVar">conservationState</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/obverseGroup">obverse</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/nudsDescriptionTextVar">description</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/legendTextVar">legend</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/reverseGroup">reverse</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/nudsDescriptionTextVar">description</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/legendTextVar">legend</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/countermarkTextVar">countermark</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/msContentsGroup">msContents</a> (class)<ul><li>
                                <a href="/vocabulary/msItem01Group">msItem01</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/locusTextVar">locus</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/titleGroup">title</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/agentPersonGroup">agent</a> {person} (class)<ul>
                                            <li>
                                                <a href="/vocabulary/personLink">person</a> (property: link)</li>
                                            <li>
                                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                                            <li>
                                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/languageCollectionVar">language</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/originPlaceGroup">originPlace</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                                            <li>
                                                <a href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                                            <li>
                                                <a href="/vocabulary/historicalCountryCollectionVar">historicalCountry</a> (property: code)</li>
                                            <li>
                                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/originDateGroup">originDate</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                                            <li>
                                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                                            <li>
                                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/physicalDescriptionGroup">physicalDescription</a> (class)<ul><li>
                                                <a href="/vocabulary/noteFieldPhysicalDescriptionTextVar">note</a> (property: text)</li></ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/incipitTextVar">incipit</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/explicitTextVar">explicit</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/rubricTextVar">rubric</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/finalRubricTextVar">finalRubric</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/listBiblTextVar">listBibl</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/noteFieldTextVar">note</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/relatedToGroup">relatedTo</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/recordLink">record</a> (property: link)</li>
                                            <li>
                                                <a href="/vocabulary/partGroup">part</a> (class)<ul>
                                                    <li>
                                                        <a href="/vocabulary/partNumberTextVar">partNumber</a> (property: text)</li>
                                                    <li>
                                                        <a href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/msItem02Group">msItem02</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/msItem03Group">msItem03</a> (class)<ul>
                                                    <li>
                                                        <a href="/vocabulary/msItem04Group">msItem04</a> (class)<ul>
                                                            <li>
                                                                <a href="/vocabulary/msItem05Group">msItem05</a> (class)<ul>
                                                                    <li>
                                                                        <a href="/vocabulary/msItem06Group">msItem06</a> (class) </li>
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
                        <a href="/vocabulary/descriptionOfSubordinateComponentsGroup">descriptionOfSubordinateComponents</a> (class)<ul><li>
                                <a href="/vocabulary/component01Group">component01</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/levelCollectionComponentCollectionVar">level</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/unitidTextVar">unitid</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/titleGroup">title</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/agentPersonGroup">agent</a> {person} (class)<ul>
                                            <li>
                                                <a href="/vocabulary/personLink">person</a> (property: link)</li>
                                            <li>
                                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                                            <li>
                                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/agentOrganisationGroup">agent</a> {organisation} (class)<ul>
                                            <li>
                                                <a href="/vocabulary/organisationLink">organisation</a> (property: link)</li>
                                            <li>
                                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                                            <li>
                                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/originDateGroup">originDate</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                                            <li>
                                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                                            <li>
                                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                                            <li>
                                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                                        </ul>
                                                    </li></ul>
                                            </li>
                                            <li>
                                                <a href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/noteFieldGeneralTextVar">note</a> {general} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/identifierAccessionNumberTextVar">identifier</a> {accessionNumber} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/relatedToGroup">relatedTo</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/recordLink">record</a> (property: link)</li>
                                            <li>
                                                <a href="/vocabulary/partGroup">part</a> (class)<ul>
                                                    <li>
                                                        <a href="/vocabulary/partNumberTextVar">partNumber</a> (property: text)</li>
                                                    <li>
                                                        <a href="/vocabulary/extentTextVar">extent</a> (property: text)</li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="/vocabulary/accessPolicyTextVar">accessPolicy</a> (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/component02Group">component02</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/component03Group">component03</a> (class)<ul>
                                                    <li>
                                                        <a href="/vocabulary/component04Group">component04</a> (class)<ul>
                                                            <li>
                                                                <a href="/vocabulary/component05Group">component05</a> (class)<ul>
                                                                    <li>
                                                                        <a href="/vocabulary/component06Group">component06</a> (class) </li>
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
                        <a href="/vocabulary/recordInfoAlvinRecordGroup">recordInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/urnAlvinTextVar">urn</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/recordTypeLink">type</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/validationTypeLink">validationType</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/permissionUnitLink">permissionUnit</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/visibilityCollectionVar">visibility</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/tsVisibilityTextVar">tsVisibility</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/createdByLink">createdBy</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/tsCreatedTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/updatedGroup">updated</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/updatedByLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/tsUpdatedTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/fileSectionGroup">fileSection</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/rightsCollectionVar">rights</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/digitalOriginCollectionVar">digitalOrigin</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/fileGroupGroup">fileGroup</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/internetMediaTypeCollectionVar">internetMediaType</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/fileGroupTypeCollectionVar">type</a> (property: code)</li>
                                    <li>
                                        <a href="/vocabulary/fileGroup">file</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/fileTypeCollectionVar">type</a> (property: code)</li>
                                            <li>
                                                <a href="/vocabulary/labelTextVar">label</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/fileLocationLink">fileLocation</a> (property: link)</li>
                                        </ul>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'personGroup'">
                <h2>Core class: person overview</h2>
                <ul>
                    <li>
                        <a href="/vocabulary/authorityPersonGroup">authority</a> (class)<ul><li>
                                <a href="/vocabulary/namePersonGroup">name</a> {personal} (class)<ul>
                                    <li>
                                        <a href="/vocabulary/namePartFamilyTextVar">namePart</a> {family} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartGivenTextVar">namePart</a> {given} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartNumerationTextVar">namePart</a> {numeration} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/familyNameCollectionVar">familyName</a> (property: code)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/personInfoGroup">personInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/birthDateGroup">birthDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/deathDateGroup">deathDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/birthPlaceGroup">birthPlace</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                </ul>
                            </li>
                            <li>
                                <a href="/vocabulary/deathPlaceGroup">deathPlace</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                                </ul>
                            </li>
                            <li>
                                <a href="/vocabulary/nationalityGroup">nationality</a> (class)<ul><li>
                                        <a href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/genderCollectionVar">gender</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/variantPersonGroup">variant</a> (class)<ul><li>
                                <a href="/vocabulary/nameVariantPersonGroup">name</a> {personal} (class)<ul>
                                    <li>
                                        <a href="/vocabulary/namePartFamilyTextVar">namePart</a> {family} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartGivenTextVar">namePart</a> {given} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartNumerationTextVar">namePart</a> {numeration} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/nameParttermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/fieldOfEndeavorTextVar">fieldOfEndeavor</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/noteFieldAuthorityTextVar">note</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/identifierAuthorityTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/relatedPersonGroup">related</a> {person} (class)<ul><li>
                                <a href="/vocabulary/personLink">person</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/relatedOrganisationGroup">related</a> {organisation} (class)<ul><li>
                                <a href="/vocabulary/organisationLink">organisation</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/recordInfoAlvinPersonGroup">recordInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/recordTypeLink">type</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/validationTypeLink">validationType</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/createdByLink">createdBy</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/tsCreatedTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/updatedGroup">updated</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/updatedByLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/tsUpdatedTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'organisationGroup'">
                <h2>Core class: organisation overview</h2>
                <ul>
                    <li>
                        <a href="/vocabulary/authorityOrganisationGroup">authority</a> (class)<ul><li>
                                <a href="/vocabulary/nameOrganisationGroup">name</a> {corporate} (class)<ul>
                                    <li>
                                        <a href="/vocabulary/namePartOrganisationTextVar">namePart</a> {corporateName} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartSubordinateTextVar">namePart</a> {subordinate} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                </ul>
                            </li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/organisationInfoGroup">organisationInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/variantOrganisationGroup">variant</a> (class)<ul><li>
                                <a href="/vocabulary/nameVariantOrganisationGroup">name</a> {corporate} (class)<ul>
                                    <li>
                                        <a href="/vocabulary/namePartOrganisationTextVar">namePart</a> {corporateName} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartSubordinateTextVar">namePart</a> {subordinate} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/namePartTermsOfAddressTextVar">namePart</a> {termsOfAddress} (property: text)</li>
                                    <li>
                                        <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/noteFieldAuthorityTextVar">note</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/electronicLocatorGroup">electronicLocator</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/externalLinkURLTextVar">url</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/displayLabelTextVar">displayLabel</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/identifierAuthorityTextVar">identifier</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/addressGroup">address</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/addressPostOfficeBoxTextVar">postOfficeBox</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/addressStreetTextVar">street</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/addressPostcodeBoxTextVar">postcode</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/relatedOrganisationTypeGroup">related</a> (class)<ul><li>
                                <a href="/vocabulary/organisationLink">organisation</a> (property: link)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/recordInfoAlvinOrganisationGroup">recordInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/recordTypeLink">type</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/validationTypeLink">validationType</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/createdByLink">createdBy</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/tsCreatedTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/updatedGroup">updated</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/updatedByLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/tsUpdatedTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'placeGroup'">
                <h2>Core class: place overview</h2>
                <ul>
                    <li>
                        <a href="/vocabulary/authorityPlaceGroup">authority</a> (class)<ul><li>
                                <a href="/vocabulary/geographicPlaceTextVar">geographic</a> (property: text)</li></ul>
                    </li>
                    <li>
                        <a href="/vocabulary/variantPlaceGroup">variant</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/geographicPlaceTextVar">geographic</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/pointGroup">point</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/latitudeTextVar">latitude</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/longitudeTextVar">longitude</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/recordInfoAlvinPlaceGroup">recordInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/recordTypeLink">type</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/validationTypeLink">validationType</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/createdByLink">createdBy</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/tsCreatedTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/updatedGroup">updated</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/updatedByLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/tsUpdatedTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
            <xsl:when test="recordInfo/id = 'workGroup'">
                <h2>Core class: work overview</h2>
                <ul>
                    <li>
                        <a href="/vocabulary/titleGroup">title</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/variantTitleGroup">variantTitle</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/mainTitleTextVar">mainTitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/subtitleTextVar">subtitle</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/orientationCodeCollectionVar">orientationCode</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/incipitTextVar">incipit</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/formOfWorkCollectionVar">formOfWork</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/agentPersonGroup">agent</a> {person} (class)<ul>
                            <li>
                                <a href="/vocabulary/personLink">person</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/agentOrganisationGroup">agent</a> {organisation} (class)<ul>
                            <li>
                                <a href="/vocabulary/organisationLink">organisation</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/relatorCodeCollectionVar">role</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/originDateGroup">originDate</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/displayDateTextVar">displayDate</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/dateOtherGroup">dateOther</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/startDateGroup">startDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/endDateGroup">endDate</a> (class)<ul><li>
                                        <a href="/vocabulary/dateGroup">date</a> (class)<ul>
                                            <li>
                                                <a href="/vocabulary/yearTextVar">year</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/monthTextVar">month</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/dayTextVar">day</a> (property: text)</li>
                                            <li>
                                                <a href="/vocabulary/eraCollectionVar">era</a> (property: code)</li>
                                        </ul>
                                    </li></ul>
                            </li>
                            <li>
                                <a href="/vocabulary/noteFieldGeneralTextVar">note</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/originPlaceGroup">originPlace</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/placeLink">place</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/countryCodeCollectionVar">country</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/historicalCountryCollectionVar">historicalCountry</a> (property: code)</li>
                            <li>
                                <a href="/vocabulary/certaintyCollectionVar">certainty</a> (property: code)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/musicMediumCollectionVar">musicMedium</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/musicMediumOtherTextVar">musicMediumOther</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/numericDesignationOfMusicalWorkGroup">numericDesignationOfMusicalWork</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/musicSerialNumberTextVar">musicSerialNumber</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/musicOpusNumberTextVar">musicOpusNumber</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/musicThematicNumberTextVar">musicThematicNumber</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/musicKeyCollectionVar">musicKey</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/musicKeyOtherTextVar">musicKeyOther</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/noteFieldGeneralTextVar">note</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/listBiblTextVar">listBibl</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/genreFormMusicCollectionVar">genreForm</a> (property: code)</li>
                    <li>
                        <a href="/vocabulary/pointGroup">point</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/latitudeTextVar">latitude</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/longitudeTextVar">longitude</a> (property: text)</li>
                        </ul>
                    </li>
                    <li>
                        <a href="/vocabulary/noteFieldThesisTextVar">note</a> (property: text)</li>
                    <li>
                        <a href="/vocabulary/recordInfoAlvinWorkGroup">recordInfo</a> (class)<ul>
                            <li>
                                <a href="/vocabulary/idAlvinTextVar">id</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/recordTypeLink">type</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/validationTypeLink">validationType</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/dataDividerAlvinDataLink">dataDivider</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/createdByLink">createdBy</a> (property: link)</li>
                            <li>
                                <a href="/vocabulary/tsCreatedTextVar">tsCreated</a> (property: text)</li>
                            <li>
                                <a href="/vocabulary/updatedGroup">updated</a> (class)<ul>
                                    <li>
                                        <a href="/vocabulary/updatedByLink">updatedBy</a> (property: link)</li>
                                    <li>
                                        <a href="/vocabulary/tsUpdatedTextVar">tsUpdated</a> (property: text)</li>
                                </ul>
                            </li>
                        </ul>
                    </li>
                </ul>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
