<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:alvin="http://127.0.0.1:8000/vocabulary/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="rdf rdfs alvin skos owl xsd dcterms">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="id"/>
    <xsl:param name="lang"/>
    <xsl:param name="i18n">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$lang"/>
        <xsl:text>/</xsl:text>
    </xsl:param>
    <xsl:param name="full_url"/>
    <xsl:param name="parent_path">
        <xsl:value-of select="substring-before($full_url,$id)"/>
    </xsl:param>
    <xsl:param name="rdf_host">
        <xsl:value-of select="substring-before($full_url, $i18n)"/>
    </xsl:param>
    <xsl:param name="rdf_path">
        <xsl:value-of select="substring-after($full_url, $i18n)"/>
    </xsl:param>
    <xsl:param name="rdf_link">
        <xsl:value-of select="$rdf_host"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$rdf_path"/>
    </xsl:param>
    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <xsl:variable name="id">
            <xsl:value-of select="$id"/>
        </xsl:variable>
        <xsl:for-each select="owl:Class[substring-after(@rdf:about,'onthology/') = $id]">
            <h1 class="text-2xl md:text-3xl font-bold pb-4">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text>Class: </xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text>Klasse: </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Klass: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="$id"/>
            </h1>
            <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
                <xsl:call-template name="uri"/>
                <xsl:call-template name="label"/>
                <xsl:call-template name="definition"/>
                <xsl:call-template name="usedwithproperty"/>
                <xsl:call-template name="properties"/>
                <xsl:call-template name="collection"/>
                <xsl:call-template name="modified"/>
            </div>
        </xsl:for-each>
        <xsl:for-each select="owl:ObjectProperty[substring-after(@rdf:about,'onthology/') = $id]">
            <h1 class="text-2xl md:text-3xl font-bold pb-4">
                <xsl:call-template name="propertylabel"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$id"/>
            </h1>
            <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
                <xsl:call-template name="uri"/>
                <xsl:call-template name="label"/>
                <xsl:call-template name="definition"/>
                <xsl:call-template name="usedwithclass"/>
                <xsl:call-template name="expectedvalue"/>
                <xsl:call-template name="category"/>
                <xsl:call-template name="modified"/>
            </div>
        </xsl:for-each>
        <xsl:for-each select="owl:DatatypeProperty[substring-after(@rdf:about,'onthology/') = $id]">
            <h1 class="text-2xl md:text-3xl font-bold pb-4">
                <xsl:call-template name="propertylabel"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="$id"/>
            </h1>
            <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
                <xsl:call-template name="uri"/>
                <xsl:call-template name="label"/>
                <xsl:call-template name="definition"/>
                <xsl:call-template name="usedwithclass"/>
                <xsl:call-template name="literal"/>
                <xsl:call-template name="category"/>
                <xsl:call-template name="modified"/>
            </div>
        </xsl:for-each>
        <div class="footer flex justify-end py-4">
            <a class="flex flex-row bg-orange-600 hover:bg-orange-700 focus:bg-blue-800 text-white font-semibold py-2 px-4 rounded-full">
                <xsl:attribute name="href">
                    <xsl:value-of select="$rdf_link"/>
                    <xsl:text>.rdf</xsl:text>
                </xsl:attribute>
                <xsl:text>RDF/XML </xsl:text>
            </a>
        </div>
    </xsl:template>
    <xsl:template name="uri">
        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
            <div class="md:w-1/4 font-bold pl-2 break-all">
                <xsl:text>URI</xsl:text>
            </div>
            <div class="w-full md:w-3/4 flex flex-grow pl-2" id="uri">
                <xsl:value-of select="$rdf_link"/>
                <button class="btn flex items-right flex justify-end" data-clipboard-action="copy" data-clipboard-target="#uri">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6 float-right">
                        <title>Copy</title>
                        <path stroke-linecap="round" stroke-linejoin="round" d="M15.666 3.888A2.25 2.25 0 0 0 13.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 0 1-.75.75H9a.75.75 0 0 1-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 0 1-2.25 2.25H6.75A2.25 2.25 0 0 1 4.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 0 1 1.927-.184"/>
                    </svg>
                </button>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="label">
        <xsl:for-each select="rdfs:label[@xml:lang = 'en']">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Label [en]</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="rdfs:label[@xml:lang = 'no']">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Benevning  [no]</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="rdfs:label[@xml:lang = 'sv']">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Benämning [sv]</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="definition">
        <xsl:for-each select="skos:definition[@xml:lang = 'en']">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Definition [en]</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="skos:definition[@xml:lang = 'no']">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Definisjon [no]</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="skos:definition[@xml:lang = 'sv']">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:text>Definition [sv]</xsl:text>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="usedwithproperty">
        <xsl:for-each select="../owl:ObjectProperty">
            <xsl:variable name="property">
                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
            </xsl:variable>
            <xsl:if test="substring-after(rdfs:range/@rdf:resource,'onthology/') = $id">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:text>Used with</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:text>Brukes med</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Används med</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="$property"/>
                            </xsl:attribute>
                            <xsl:value-of select="$property"/>
                        </a>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="usedwithclass">
        <xsl:for-each select="rdfs:domain">
            <xsl:choose>
                <xsl:when test="owl:Class">
                    <xsl:for-each select="owl:Class/owl:unionOf/owl:Class">
                        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                            <div class="md:w-1/4 font-bold pl-2 break-all">
                                <xsl:choose>
                                    <xsl:when test="$lang = 'en'">
                                        <xsl:text>Used with</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$lang = 'no'">
                                        <xsl:text>Brukes med</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>Används med</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            <div class="md:w-3/4 pl-2">
                                <a class="text-blue-800 dark:text-blue-200 underline">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$parent_path"/>
                                        <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                                </a>
                            </div>
                        </div>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Used with</xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Brukes med</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Används med</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$parent_path"/>
                                    <xsl:value-of select="substring-after(@rdf:resource,'onthology/')"/>
                                </xsl:attribute>
                                <xsl:value-of select="substring-after(@rdf:resource,'onthology/')"/>
                            </a>
                        </div>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="expectedvalue">
        <xsl:for-each select="rdfs:range">
            <xsl:variable name="expected">
                <xsl:value-of select="substring-after(./@rdf:resource,'onthology/')"/>
            </xsl:variable>
            <xsl:if test="string-length($expected) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:text>Expected value</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:text>Forventet verdi</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Förväntat värde</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="$expected"/>
                            </xsl:attribute>
                            <xsl:value-of select="$expected"/>
                        </a>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="properties">
        <xsl:for-each select="../owl:ObjectProperty">
            <xsl:variable name="property">
                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
            </xsl:variable>
            <xsl:for-each select="rdfs:domain/owl:Class/owl:unionOf/owl:Class">
                <xsl:if test="substring-after(@rdf:about,'onthology/') = $id">
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Property</xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Egenskap</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Egenskap</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$parent_path"/>
                                    <xsl:value-of select="$property"/>
                                </xsl:attribute>
                                <xsl:value-of select="$property"/>
                            </a>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="../owl:ObjectProperty">
            <xsl:variable name="property">
                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
            </xsl:variable>
            <xsl:if test="substring-after(rdfs:domain/@rdf:resource,'onthology/') = $id">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:text>Property</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:text>Egenskap</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Egenskap</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="$property"/>
                            </xsl:attribute>
                            <xsl:value-of select="$property"/>
                        </a>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="../owl:DatatypeProperty">
            <xsl:variable name="property">
                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
            </xsl:variable>
            <xsl:for-each select="rdfs:domain/owl:Class/owl:unionOf/owl:Class">
                <xsl:if test="substring-after(@rdf:about,'onthology/') = $id">
                    <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                        <div class="md:w-1/4 font-bold pl-2 break-all">
                            <xsl:choose>
                                <xsl:when test="$lang = 'en'">
                                    <xsl:text>Property</xsl:text>
                                </xsl:when>
                                <xsl:when test="$lang = 'no'">
                                    <xsl:text>Egenskap</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>Egenskap</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div class="md:w-3/4 pl-2">
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$parent_path"/>
                                    <xsl:value-of select="$property"/>
                                </xsl:attribute>
                                <xsl:value-of select="$property"/>
                            </a>
                        </div>
                    </div>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="../owl:DatatypeProperty">
            <xsl:variable name="property">
                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
            </xsl:variable>
            <xsl:if test="substring-after(rdfs:domain/@rdf:resource,'onthology/') = $id">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:text>Property</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:text>Egenskap</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Egenskap</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="$property"/>
                            </xsl:attribute>
                            <xsl:value-of select="$property"/>
                        </a>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="category">
        <xsl:for-each select="skos:example">
            <xsl:if test="string-length(.) &gt; 0">
                <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <xsl:choose>
                            <xsl:when test="$lang = 'en'">
                                <xsl:text>Category</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lang = 'no'">
                                <xsl:text>Kategori</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Kategori</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="md:w-3/4 pl-2">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="modified">
        <xsl:for-each select="dcterms:modified">
            <xsl:if test="string-length(.) &gt; 0">
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
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="propertylabel">
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <xsl:text>Property</xsl:text>
            </xsl:when>
            <xsl:when test="$lang = 'no'">
                <xsl:text>Egenskap</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Egenskap</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="literal">
        <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
            <div class="md:w-1/4 font-bold pl-2 break-all">
                <xsl:choose>
                    <xsl:when test="$lang = 'en'">
                        <xsl:text>Expected value</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang = 'no'">
                        <xsl:text>Forventet verdi</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Förväntat värde</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="md:w-3/4 pl-2">
                <a class="text-blue-800 dark:text-blue-200 underline">
                    <xsl:attribute name="href">
                        <xsl:text>https://www.w3.org/2000/01/rdf-schema#Literal</xsl:text>
                    </xsl:attribute>
                    <xsl:text>rdfs:Literal</xsl:text>
                </a>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="collection">
        <xsl:for-each select="skos:scopeNote">
            <div class="w-full flex flex-col md:flex-row py-2 flex-grow border-b border-alvin">
                <div class="md:w-1/4 font-bold pl-2 break-all">
                    <xsl:choose>
                        <xsl:when test="$lang = 'en'">
                            <xsl:text>Controlled list</xsl:text>
                        </xsl:when>
                        <xsl:when test="$lang = 'no'">
                            <xsl:text>Kontrollert liste</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Kontrollerad lista</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div class="md:w-3/4 pl-2">
                    <a class="text-blue-800 dark:text-blue-200 underline">
                        <xsl:attribute name="href">
                            <xsl:value-of select="@rdf:resource"/>
                        </xsl:attribute>
                        <xsl:value-of select="@rdf:resource"/>
                    </a>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
