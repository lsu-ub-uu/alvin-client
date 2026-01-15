<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
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
        <rdf:RDF xml:base="http://127.0.0.1:8000/vocabulary/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#">
            <xsl:choose>
                <xsl:when test="@type = 'group'">
                    <owl:Class>
                        <xsl:call-template name="rdf">
                            <xsl:with-param name="uri" select="$uri"/>
                        </xsl:call-template>
                    </owl:Class>
                </xsl:when>
                <xsl:when test="@type = 'recordLink'">
                    <owl:Class>
                        <xsl:call-template name="rdf">
                            <xsl:with-param name="uri" select="$uri"/>
                        </xsl:call-template>
                    </owl:Class>
                </xsl:when>
                <xsl:when test="@type = 'itemCollection'">
                    <xsl:variable name="list">
                        <xsl:value-of select="recordInfo/id"/>
                    </xsl:variable>
                    <owl:Class>
                        <xsl:call-template name="rdf">
                            <xsl:with-param name="uri" select="$uri"/>
                        </xsl:call-template>
                    </owl:Class>
                    <xsl:for-each select="collectionItemReferences/ref">
                        <xsl:sort select="linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']/text"/>
                        <xsl:variable name="uriref">
                            <xsl:value-of select="$baseURL"/>
                            <xsl:value-of select="linkedRecordId"/>
                        </xsl:variable>
                        <owl:DatatypeProperty>
                            <xsl:call-template name="rdfitem">
                                <xsl:with-param name="uri" select="$uriref"/>
                                <xsl:with-param name="sub" select="$list"/>
                            </xsl:call-template>
                        </owl:DatatypeProperty>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <owl:DatatypeProperty>
                        <xsl:call-template name="rdf">
                            <xsl:with-param name="uri" select="$uri"/>
                        </xsl:call-template>
                        <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                    </owl:DatatypeProperty>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:RDF>
    </xsl:template>
    <xsl:template name="sub">
        <xsl:param name="baseURL" select="$baseURL"/>
        <xsl:param name="sub" select="$sub"/>
        <xsl:if test="not(@type = 'itemCollection')">
            <xsl:if test="not(contains($sub, 'New'))">
                <xsl:if test="not(contains($sub, 'Update'))">
                    <xsl:if test="not(contains($sub, 'Search'))">
                        <xsl:if test="not(contains($sub, 'Update'))">
                            <xsl:choose>
                                <xsl:when test="contains(recordInfo/id,'Group')">
                                    <rdfs:subClassOf>
                                        <xsl:attribute name="rdf:resource">
                                            <xsl:value-of select="$baseURL"/>
                                            <xsl:value-of select="$sub"/>
                                        </xsl:attribute>
                                    </rdfs:subClassOf>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdfs:domain>
                                        <xsl:attribute name="rdf:resource">
                                            <xsl:value-of select="$baseURL"/>
                                            <xsl:value-of select="$sub"/>
                                        </xsl:attribute>
                                    </rdfs:domain>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="rdf">
        <xsl:param name="uri"/>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$uri"/>
        </xsl:attribute>
        <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'en'] | linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'en']">
            <xsl:if test="string-length(.) &gt; 0">
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="text"/>
                </rdfs:label>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'no'] | linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'no']">
            <xsl:if test="string-length(.) &gt; 0">
                <rdfs:label xml:lang="no">
                    <xsl:value-of select="text"/>
                </rdfs:label>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'sv'] | linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']">
            <xsl:if test="string-length(.) &gt; 0">
                <rdfs:label xml:lang="sv">
                    <xsl:value-of select="text"/>
                </rdfs:label>
            </xsl:if>
        </xsl:for-each>

        <xsl:if test="not(@type = 'itemCollection')">
            <xsl:if test="not(contains($sub, 'New'))">
                <xsl:if test="not(contains($sub, 'Update'))">
                    <xsl:if test="not(contains($sub, 'Search'))">
                        <xsl:if test="not(contains($sub, 'User'))">
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
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'en'] | linkedRecord/metadata/defTextId/linkedRecord/text/textPart[@lang = 'en']">
            <xsl:if test="string-length(.) &gt; 0">
                <skos:definition xml:lang="en">
                    <xsl:value-of select="text"/>
                </skos:definition>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'no'] | linkedRecord/metadata/defTextId/linkedRecord/text/textPart[@lang = 'no']">
            <xsl:if test="string-length(.) &gt; 0">
                <skos:definition xml:lang="no">
                    <xsl:value-of select="text"/>
                </skos:definition>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'sv'] | linkedRecord/metadata/defTextId/linkedRecord/text/textPart[@lang = 'sv']">
            <xsl:if test="string-length(.) &gt; 0">
                <skos:definition xml:lang="sv">
                    <xsl:value-of select="text"/>
                </skos:definition>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="recordInfo/updated[last()]/tsUpdated  | linkedRecord/metadata/recordInfo/updated[last()]/tsUpdated">
            <dcterms:modified>
                <xsl:value-of select="substring-before(.,'T')"/>
            </dcterms:modified>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="rdfitem">
        <xsl:param name="uri"/>
        <xsl:param name="sub"/>
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$uri"/>
        </xsl:attribute>
        <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'en'] | linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'en']">
            <xsl:if test="string-length(.) &gt; 0">
                <rdfs:label xml:lang="en">
                    <xsl:value-of select="text"/>
                </rdfs:label>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'no'] | linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'no']">
            <xsl:if test="string-length(.) &gt; 0">
                <rdfs:label xml:lang="no">
                    <xsl:value-of select="text"/>
                </rdfs:label>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="textId/linkedRecord/text/textPart[@lang = 'sv'] | linkedRecord/metadata/textId/linkedRecord/text/textPart[@lang = 'sv']">
            <xsl:if test="string-length(.) &gt; 0">
                <rdfs:label xml:lang="sv">
                    <xsl:value-of select="text"/>
                </rdfs:label>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="linkedRecord/metadata/nameInData">
            <skos:notation>
                <xsl:value-of select="."/>
            </skos:notation>
        </xsl:for-each>
        <rdfs:domain>
            <xsl:attribute name="rdf:resource">
                <xsl:value-of select="$baseURL"/>
                <xsl:value-of select="$sub"/>
            </xsl:attribute>
        </rdfs:domain>
        <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'en'] | linkedRecord/metadata/defTextId/linkedRecord/text/textPart[@lang = 'en']">
            <xsl:if test="string-length(.) &gt; 0">
                <skos:definition xml:lang="en">
                    <xsl:value-of select="text"/>
                </skos:definition>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'no'] | linkedRecord/metadata/defTextId/linkedRecord/text/textPart[@lang = 'no']">
            <xsl:if test="string-length(.) &gt; 0">
                <skos:definition xml:lang="no">
                    <xsl:value-of select="text"/>
                </skos:definition>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="defTextId/linkedRecord/text/textPart[@lang = 'sv'] | linkedRecord/metadata/defTextId/linkedRecord/text/textPart[@lang = 'sv']">
            <xsl:if test="string-length(.) &gt; 0">
                <skos:definition xml:lang="sv">
                    <xsl:value-of select="text"/>
                </skos:definition>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="recordInfo/updated[last()]/tsUpdated  | linkedRecord/metadata/recordInfo/updated[last()]/tsUpdated">
            <dcterms:modified>
                <xsl:value-of select="substring-before(.,'T')"/>
            </dcterms:modified>
        </xsl:for-each>
        <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
    </xsl:template>
</xsl:stylesheet>
