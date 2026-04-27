<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:alvin="http://127.0.0.1:8000/vocabulary/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="rdf rdfs alvin skos owl xsd dcterms">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="lang"/>
    <xsl:param name="full_url"/>
    <xsl:param name="parent_path">
        <xsl:value-of select="substring-before($full_url,'category/')"/>
    </xsl:param>
    <xsl:template match="/">
        <xsl:apply-templates select="rdf:RDF"/>
    </xsl:template>
    <xsl:template match="rdf:RDF">
        <h1 class="text-2xl md:text-3xl font-bold pb-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>By category</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Etter kategori</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Efter kategori</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h1>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Administrative information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Administrative information'] | owl:ObjectProperty[skos:example = 'Administrative information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Agent information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Agent information'] | owl:ObjectProperty[skos:example = 'Agent information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Authority information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Authority information'] | owl:ObjectProperty[skos:example = 'Authority information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Carrier information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Carrier information'] | owl:ObjectProperty[skos:example = 'Carrier information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Description information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Description information'] | owl:ObjectProperty[skos:example = 'Description information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>File information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'File information'] | owl:ObjectProperty[skos:example = 'File information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>General property</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'General property'] | owl:ObjectProperty[skos:example = 'General property']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Language information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Language information'] | owl:ObjectProperty[skos:example = 'Language information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Location information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Location information'] | owl:ObjectProperty[skos:example = 'Location information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Origin information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Origin information'] | owl:ObjectProperty[skos:example = 'Origin information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Related information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Related information'] | owl:ObjectProperty[skos:example = 'Related information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Subject term, category and classification information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Subject term, category and classification information'] | owl:ObjectProperty[skos:example = 'Subject term, category and classification information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
        <div class="bg-dark-alvin text-white font-bold p-2">
            <xsl:text>Title information</xsl:text>
        </div>
        <xsl:call-template name="divheader"/>
        <div class=" [&amp;>*:nth-child(odd)]:bg-off-white [&amp;>*:nth-child(even)]:bg-white pb-4 dark:[&amp;>*:nth-child(odd)]:bg-gray-700 dark:[&amp;>*:nth-child(even)]:bg-gray-800">
            <xsl:for-each select="owl:DatatypeProperty[skos:example = 'Title information'] | owl:ObjectProperty[skos:example = 'Title information']">
                <div class="w-full flex flex-col sm:flex-row flex-wrap sm:flex-nowrap py-2 flex-grow border-b border-alvin">
                    <xsl:call-template name="name"/>
                    <xsl:call-template name="definition"/>
                    <xsl:call-template name="usedwithclass"/>
                    <xsl:call-template name="expectedvalue"/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template name="usedwithclass">
        <xsl:for-each select="rdfs:domain">
            <xsl:choose>
                <xsl:when test="owl:Class">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <div class="block sm:hidden font-bold">
                            <xsl:call-template name="usedwithclasstext"/>
                        </div>
                        <xsl:for-each select="owl:Class/owl:unionOf/owl:Class">
                            <div>
                                <a class="text-blue-800 dark:text-blue-200 underline">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$parent_path"/>
                                        <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                                </a>
                            </div>
                        </xsl:for-each>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <div class="block sm:hidden font-bold">
                            <xsl:call-template name="usedwithclasstext"/>
                        </div>
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="substring-after(@rdf:resource,'onthology/alvin/')"/>
                            </xsl:attribute>
                            <xsl:value-of select="substring-after(@rdf:resource,'onthology/alvin/')"/>
                        </a>
                    </div>

                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="expectedvalue">
        <xsl:for-each select="rdfs:range">
            <xsl:variable name="expected">
                <xsl:value-of select="substring-after(./@rdf:resource,'onthology/alvin/')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($expected) &gt; 0">
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <div class="block sm:hidden font-bold">
                            <xsl:call-template name="expectedvaluetext"/>
                        </div>
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$parent_path"/>
                                <xsl:value-of select="$expected"/>
                            </xsl:attribute>
                            <xsl:value-of select="$expected"/>
                        </a>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="md:w-1/4 font-bold pl-2 break-all">
                        <div class="block sm:hidden font-bold">
                            <xsl:call-template name="expectedvaluetext"/>
                        </div>
                        <a class="text-blue-800 dark:text-blue-200 underline">
                            <xsl:attribute name="href">
                                <xsl:text>https://www.w3.org/2000/01/rdf-schema#Literal</xsl:text>
                            </xsl:attribute>
                            <xsl:text>rdfs:Literal</xsl:text>
                        </a>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="name">
        <div class="md:w-1/4 font-bold pl-2 break-all">
            <div class="block sm:hidden font-bold">
                <xsl:call-template name="nametext"/>
            </div>
            <a class="text-blue-800 dark:text-blue-200 underline">
                <xsl:attribute name="href">
                    <xsl:value-of select="$parent_path"/>
                    <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
                </xsl:attribute>
                <xsl:value-of select="substring-after(@rdf:about,'onthology/')"/>
            </a>
        </div>
    </xsl:template>
    <xsl:template name="definition">
        <div class="w-full flex-grow pl-2">
            <div class="block sm:hidden font-bold">
                <xsl:call-template name="definitiontext"/>
            </div>
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
    </xsl:template>
    <xsl:template name="nametext">
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <xsl:text>Name</xsl:text>
            </xsl:when>
            <xsl:when test="$lang = 'no'">
                <xsl:text>Navn</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Namn</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="definitiontext">
        <xsl:choose>
            <xsl:when test="$lang = 'en'">
                <xsl:text>Definition</xsl:text>
            </xsl:when>
            <xsl:when test="$lang = 'no'">
                <xsl:text>Definisjon</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Definition</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="usedwithclasstext">
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
    </xsl:template>
    <xsl:template name="expectedvaluetext">
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
    </xsl:template>
    <xsl:template name="divheader">
        <div class="w-full flex md:flex-row py-2 border-b border-alvin max-sm:hidden">
            <div class="md:w-1/4 font-bold pl-2 break-all">
                <xsl:call-template name="nametext"/>
            </div>
            <div class="w-full font-bold flex-grow pl-2">
                <xsl:call-template name="definitiontext"/>
            </div>
            <div class="md:w-1/4 font-bold pl-2 break-all">
                <xsl:call-template name="usedwithclasstext"/>
            </div>
            <div class="md:w-1/4 font-bold pl-2 break-all">
                <xsl:call-template name="expectedvaluetext"/>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
