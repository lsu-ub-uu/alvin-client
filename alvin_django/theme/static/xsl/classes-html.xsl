<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:alvin="http://127.0.0.1:8000/vocabulary/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="rdf rdfs alvin skos owl xsd dcterms">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="lang"/>
    <xsl:param name="full_url"/>
    <xsl:param name="parent_path">
        <xsl:value-of select="substring-before($full_url,'classes/')"/>
    </xsl:param>
    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <h1 class="text-2xl md:text-3xl font-bold pb-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>Classes</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Klasser</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Klasser</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h1>
        <div class="[&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:Class">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                            </xsl:attribute>
                            <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                        </a>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:value-of select="skos:definition[@xml:lang = 'en']"/>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:value-of select="skos:definition[@xml:lang = 'no']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="skos:definition[@xml:lang = 'sv']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>
