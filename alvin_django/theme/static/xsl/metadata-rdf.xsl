<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
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
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#">
           <xsl:attribute name="xml:base">
               <xsl:value-of select="$baseURL"/>
           </xsl:attribute>
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
