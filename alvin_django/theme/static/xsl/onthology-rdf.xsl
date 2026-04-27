<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:alvin="http://127.0.0.1:8000/vocabulary/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="rdf rdfs alvin skos owl xsd">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="id"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:owl="http://www.w3.org/2002/07/owl#"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#"
            xmlns:dcterms="http://purl.org/dc/terms/" xmlns:cc="http://creativecommons.org/ns#"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
            xml:base="http://127.0.0.1:8000/onthology/">
            <xsl:apply-templates select="rdf:RDF"/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <xsl:variable name="id">
            <xsl:value-of select="$id"/>
        </xsl:variable>
        <xsl:for-each select="owl:Class[substring-after(@rdf:about,'onthology/') = $id]">
            <xsl:copy-of select="."/>
            <xsl:for-each select="../owl:ObjectProperty">
                <xsl:for-each select="rdfs:domain/owl:Class/owl:unionOf/owl:Class">
                    <xsl:if test="substring-after(@rdf:about,'onthology/') = $id">
                        <xsl:copy-of select="../../../.."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="../owl:ObjectProperty">
                <xsl:if test="substring-after(rdfs:domain/@rdf:resource,'onthology/') = $id">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="../owl:DatatypeProperty">
                <xsl:for-each select="rdfs:domain/owl:Class/owl:unionOf/owl:Class">
                    <xsl:if test="substring-after(@rdf:about,'onthology/') = $id">
                        <xsl:copy-of select="../../../.."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="../owl:DatatypeProperty">
                <xsl:if test="substring-after(rdfs:domain/@rdf:resource,'onthology/') = $id">
                    <xsl:copy-of select="."/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="owl:ObjectProperty[substring-after(@rdf:about,'onthology/') = $id]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
        <xsl:for-each select="owl:DatatypeProperty[substring-after(@rdf:about,'onthology/') = $id]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
