<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:dcterms="http://purl.org/dc/terms/">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="full_url"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="issued">
        <xsl:text>2026-03-12</xsl:text>
    </xsl:variable>
    <xsl:variable name="modified">
        <xsl:text>2026-03-12</xsl:text>
    </xsl:variable>
    <xsl:variable name="delimiter">
        <xsl:text>,</xsl:text>
    </xsl:variable>
    <xsl:key name="by-category" match="Cell[3]" use="Data"/>
    <xsl:template match="/">
        <xsl:apply-templates select="Workbook"/>
    </xsl:template>
    <xsl:template match="Workbook">
        <xsl:apply-templates select="Worksheet"/>
    </xsl:template>
    <xsl:template match="Worksheet">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#">
            <xsl:attribute name="xml:base">
                <xsl:value-of select="$full_url"/>
                <xsl:text>/</xsl:text>
            </xsl:attribute>
            <owl:Ontology rdf:about="">
                <rdfs:label xml:lang="en">Alvin vocabulary</rdfs:label>
                <dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                    <xsl:value-of select="$issued"/>
                </dcterms:issued>
                <dcterms:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                    <xsl:value-of select="$modified"/>
                </dcterms:modified>
                <dcterms:description xml:lang="en">
                    <xsl:text>Alvin's data model is specifically designed for descriptions of materials in cultural heritage collections in libraries, museums and archives. In order to be able to handle different types of resources in one and the same system, it is based on a combination of concepts from different international standards for libraries and archives including BIBFRAME, MODS, MARC, EAD, TEI, NUDS, MADS, METS, PREMIS, WGS 84 and ISO 8601. The model is built around five basic core classes: Record (a bibliographic record that describes a single item or a collection of items), Person, Organisation, Place, Work and Location (the archival institution that holds the object or from which it is available).</xsl:text>
                </dcterms:description>
                <dcterms:creator>
                    <xsl:text>Uppsala university library</xsl:text>
                </dcterms:creator>
                <dcterms:publisher>
                    <xsl:text>Uppsala university library</xsl:text>
                </dcterms:publisher>
                <dcterms:rights rdf:resource="https://creativecommons.org/publicdomain/zero/1.0/"/>
                <cc:license rdf:resource="https://creativecommons.org/publicdomain/zero/1.0/"/>
            </owl:Ontology>
            <xsl:apply-templates select="Table"/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="Table">
        <xsl:for-each select="Row/Cell[3][generate-id() = generate-id(key('by-category', Data)[1])]">
            <xsl:sort select="Data"/>
            <xsl:variable name="text">
                <xsl:text>https://cora.alvin-portal.org/rest/record/text/</xsl:text>
                <xsl:choose>
                    <xsl:when test="../Cell[1]/Data = 'record'">
                        <xsl:text>recordGroupText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'person'">
                        <xsl:text>personGroupText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'organisation'">
                        <xsl:text>organisationGroupText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'place'">
                        <xsl:text>placeGroupText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'work'">
                        <xsl:text>workGroupText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'location'">
                        <xsl:text>locationGroupText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'endDate'">
                        <xsl:text>dateGroupText</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../Cell[1]/Data"/>
                        <xsl:value-of select="../Cell[4]/Data"/>
                        <xsl:text>Text</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="defText">
                <xsl:text>https://cora.alvin-portal.org/rest/record/text/</xsl:text>
                <xsl:choose>
                    <xsl:when test="../Cell[1]/Data = 'record'">
                        <xsl:text>recordGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'person'">
                        <xsl:text>personGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'organisation'">
                        <xsl:text>organisationGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'place'">
                        <xsl:text>placeGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'work'">
                        <xsl:text>workGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'location'">
                        <xsl:text>locationGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:when test="../Cell[1]/Data = 'endDate'">
                        <xsl:text>dateGroupDefText</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="../Cell[1]/Data"/>
                        <xsl:value-of select="../Cell[4]/Data"/>
                        <xsl:text>DefText</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(Data = 'Literal')">
                <owl:Class>
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$full_url"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="Data"/>
                    </xsl:attribute>
                    <xsl:for-each select="document($text)/record/data/text/textPart">
                        <rdfs:label>
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="@lang"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(text)"/>
                        </rdfs:label>
                    </xsl:for-each>
                    <xsl:for-each select="document($defText)/record/data/text/textPart">
                        <skos:definition>
                            <xsl:attribute name="xml:lang">
                                <xsl:value-of select="@lang"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(text)"/>
                        </skos:definition>
                    </xsl:for-each>
                    <xsl:if test="../Cell[4]/Data = 'CollectionVar'">
                        <skos:scopeNote>
                            <xsl:attribute name="rdf:resource">
                                <xsl:value-of select="$domain_root"/>
                                <xsl:text>/vocabulary/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="../Cell[1]/Data = 'descriptionLanguage'">
                                       <xsl:text>language</xsl:text> 
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="../Cell[1]/Data"/>  
                                    </xsl:otherwise>
                                </xsl:choose>                               
                                <xsl:text>Collection</xsl:text>
                            </xsl:attribute>
                        </skos:scopeNote>
                    </xsl:if>
                    <dcterms:modified>
                        <xsl:value-of select="$modified"/>
                    </dcterms:modified>
                </owl:Class>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="Row">
            <xsl:sort select="Cell[1]/Data"/>
            <xsl:variable name="text">
                <xsl:text>https://cora.alvin-portal.org/rest/record/text/</xsl:text>
                <xsl:value-of select="Cell[1]/Data"/>
                <xsl:value-of select="Cell[4]/Data"/>
                <xsl:text>Text</xsl:text>
            </xsl:variable>
            <xsl:variable name="defText">
                <xsl:text>https://cora.alvin-portal.org/rest/record/text/</xsl:text>
                <xsl:value-of select="Cell[1]/Data"/>
                <xsl:value-of select="Cell[4]/Data"/>
                <xsl:text>DefText</xsl:text>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="Cell[3] = 'Literal'">
                    <owl:DatatypeProperty>
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="$full_url"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="Cell[1]/Data"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="contains(Cell[2]/Data,',')">
                                <rdfs:domain>
                                    <owl:Class>
                                        <owl:unionOf rdf:parseType="Collection">
                                            <xsl:call-template name="domain"/>
                                        </owl:unionOf>
                                    </owl:Class>
                                </rdfs:domain>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdfs:domain>
                                    <xsl:attribute name="rdf:resource">
                                        <xsl:value-of select="$full_url"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="Cell[2]/Data"/>
                                    </xsl:attribute>
                                </rdfs:domain>
                            </xsl:otherwise>
                        </xsl:choose>
                        <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                        <xsl:for-each select="document($text)/record/data/text/textPart">
                            <rdfs:label>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="@lang"/>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(text)"/>
                            </rdfs:label>
                        </xsl:for-each>
                        <xsl:for-each select="document($defText)/record/data/text/textPart">
                            <skos:definition>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="@lang"/>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(text)"/>
                            </skos:definition>
                        </xsl:for-each>
                        <xsl:call-template name="example"/>
                        <dcterms:modified>
                            <xsl:value-of select="$modified"/>
                        </dcterms:modified>
                    </owl:DatatypeProperty>
                </xsl:when>
                <xsl:otherwise>
                    <owl:ObjectProperty>
                        <xsl:attribute name="rdf:about">
                            <xsl:value-of select="$full_url"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="Cell[1]/Data"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="contains(Cell[2]/Data,',')">
                                <rdfs:domain>
                                    <owl:Class>
                                        <owl:unionOf rdf:parseType="Collection">
                                            <xsl:call-template name="domain"/>
                                        </owl:unionOf>
                                    </owl:Class>
                                </rdfs:domain>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdfs:domain>
                                    <xsl:attribute name="rdf:resource">
                                        <xsl:value-of select="$full_url"/>
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="Cell[2]/Data"/>
                                    </xsl:attribute>
                                </rdfs:domain>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="Cell[3]">
                            <rdfs:range>
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="$full_url"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="Data"/>
                                </xsl:attribute>
                            </rdfs:range>
                        </xsl:for-each>
                        <xsl:for-each select="document($text)/record/data/text/textPart">
                            <rdfs:label>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="@lang"/>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(text)"/>
                            </rdfs:label>
                        </xsl:for-each>
                        <xsl:for-each select="document($defText)/record/data/text/textPart">
                            <skos:definition>
                                <xsl:attribute name="xml:lang">
                                    <xsl:value-of select="@lang"/>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(text)"/>
                            </skos:definition>
                        </xsl:for-each>
                        <xsl:call-template name="example"/>
                        <dcterms:modified>
                            <xsl:value-of select="$modified"/>
                        </dcterms:modified>
                    </owl:ObjectProperty>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="domain">
        <xsl:for-each select="Cell[2]/Data">
            <xsl:variable name="dataList">
                <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:call-template name="processingTemplate">
                <xsl:with-param name="datalist" select="$dataList"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="processingTemplate">
        <xsl:param name="datalist"/>
        <xsl:choose>
            <xsl:when test="contains($datalist,$delimiter)">
                <xsl:element name="owl:Class">
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$full_url"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="substring-before($datalist,$delimiter)"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:call-template name="processingTemplate">
                    <xsl:with-param name="datalist" select="substring-after($datalist,$delimiter)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="example">
        <xsl:for-each select="Cell[5]">
            <skos:example xml:lang="en">
                <xsl:choose>
                    <xsl:when test="Data = 'adminMetadata'">
                        <xsl:text>Administrative information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'agent'">
                        <xsl:text>Agent information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'authority'">
                        <xsl:text>Authority information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'fileSection'">
                        <xsl:text>File information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'general'">
                        <xsl:text>General property</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'language'">
                        <xsl:text>Language information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'originInfo'">
                        <xsl:text>Origin information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'physicalDescription'">
                        <xsl:text>Carrier information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'physicalLocation'">
                        <xsl:text>Location information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'related'">
                        <xsl:text>Related information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'subject'">
                        <xsl:text>Subject term, category and classification information</xsl:text>
                    </xsl:when>
                    <xsl:when test="Data = 'title'">
                        <xsl:text>Title information</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Description information</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </skos:example>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
