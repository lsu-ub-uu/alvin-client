<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:alvin="https://www.alvin-portal.org/vocabulary/" 
    xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
    xmlns:owl="http://www.w3.org/2002/07/owl#" 
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    exclude-result-prefixes="rdf rdfs skos alvin owl xsd">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="host">
        <xsl:value-of select="$domain_root"/>
        <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/record | dataList/data/record/data/record"/>
    </xsl:template>
    <xsl:template match="record">
        <record>
            <header>
                <identifier>
                    <xsl:text>oai:ALVIN.org:</xsl:text>
                    <xsl:value-of select="recordInfo/id"/>
                </identifier>
                <datestamp>
                    <xsl:for-each select="recordInfo/updated/tsUpdated[position() = last()]">
                        <xsl:value-of select="substring-before(.,'.')"/>
                        <xsl:text>Z</xsl:text>
                    </xsl:for-each>
                </datestamp>
                <setSpec>
                    <xsl:value-of select="physicalLocation/heldBy/location/linkedRecordId"/>
                </setSpec>
            </header>
            <metadata>
                <xsl:element name="rdf:RDF">
                    <xsl:copy-of select="document('')/*/namespace::rdfs"/>
                    <xsl:copy-of select="document('')/*/namespace::alvin"/>
                    <xsl:copy-of select="document('')/*/namespace::skos"/>
                    <xsl:copy-of select="document('')/*/namespace::owl"/>
                    <xsl:copy-of select="document('')/*/namespace::xsd"/>
                    <alvin:Record>
                        <xsl:call-template name="about"/>
                        <xsl:call-template name="typeOfResource"/>
                        <xsl:call-template name="collection"/>
                        <xsl:call-template name="productionMethod"/>
                        <xsl:call-template name="title"/>
                        <xsl:call-template name="variantTitle"/>
                        <xsl:call-template name="physicalLocation"/>
                        <xsl:call-template name="agent"/>
                        <xsl:call-template name="language"/>
                        <xsl:call-template name="adminMetadata"/>
                        <xsl:call-template name="editionStatement"/>
                        <xsl:call-template name="originPlace"/>
                        <xsl:call-template name="publication"/>
                        <xsl:call-template name="originDate"/>
                        <xsl:call-template name="dateOther"/>
                        <xsl:call-template name="extent"/>
                        <xsl:call-template name="dimensions"/>
                        <xsl:call-template name="measure"/>
                        <xsl:call-template name="physicalDescription"/>
                        <xsl:call-template name="baseMaterial"/>
                        <xsl:call-template name="appliedMaterial"/>
                        <xsl:call-template name="summary"/>
                        <xsl:call-template name="transcription"/>
                        <xsl:call-template name="tableOfContents"/>
                        <xsl:call-template name="listBibl"/>
                        <xsl:call-template name="note"/>
                        <xsl:call-template name="relatedTo"/>
                        <xsl:call-template name="electronicLocator"/>
                        <xsl:call-template name="genre"/>
                        <xsl:call-template name="subject"/>
                        <xsl:call-template name="classification"/>
                        <xsl:call-template name="bindingDesc"/>
                        <xsl:call-template name="decoNote"/>
                        <xsl:call-template name="urn"/>
                        <xsl:call-template name="identifier"/>
                        <xsl:call-template name="work"/>
                        <xsl:call-template name="accessPolicy"/>
                        <xsl:call-template name="level"/>
                        <xsl:call-template name="otherfindaid"/>
                        <xsl:call-template name="weeding"/>
                        <xsl:call-template name="relatedmaterial"/>
                        <xsl:call-template name="arrangement"/>
                        <xsl:call-template name="accruals"/>
                        <xsl:call-template name="locus"/>
                        <xsl:call-template name="incipit"/>
                        <xsl:call-template name="explicit"/>
                        <xsl:call-template name="rubric"/>
                        <xsl:call-template name="finalRubric"/>
                        <xsl:call-template name="musicKey"/>
                        <xsl:call-template name="musicKeyOther"/>
                        <xsl:call-template name="musicMedium"/>
                        <xsl:call-template name="musicMediumOther"/>
                        <xsl:call-template name="musicNotation"/>
                        <xsl:call-template name="cartographicAttributes"/>
                        <xsl:call-template name="appraisal"/>
                        <xsl:call-template name="axis"/>
                        <xsl:call-template name="countermark"/>
                        <xsl:call-template name="edge"/>
                        <xsl:call-template name="conservationState"/>
                        <xsl:call-template name="obverse"/>
                        <xsl:call-template name="reverse"/>
                        <xsl:call-template name="msContents"/>
                        <xsl:call-template name="descriptionOfSubordinateComponents"/>
                        <xsl:call-template name="recordInfo"/>
                        <xsl:call-template name="fileSection"/>
                    </alvin:Record>
                </xsl:element>
            </metadata>        
        </record>
    </xsl:template>
        <xsl:template name="linkedPerson">
        <xsl:for-each select="person">
            <alvin:person>
                <alvin:Person>
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$host"/>
                        <xsl:value-of select="linkedRecordType"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="linkedRecordId"/>
                    </xsl:attribute>
                    <xsl:for-each select="linkedRecord/person/authority">
                        <rdfs:label>
                            <xsl:call-template name="authlang"/>
                            <xsl:call-template name="labelPerson"/>
                        </rdfs:label>
                    </xsl:for-each>
                </alvin:Person>
            </alvin:person>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labelPerson">
        <xsl:if test="string-length(name/namePart[@type = 'family']) &gt; 0">
            <xsl:value-of select="name/namePart[@type = 'family']"/>
            <xsl:if test="string-length(name/familyName) &gt; 0">
                <xsl:text> (family)</xsl:text>
            </xsl:if>
            <xsl:if test="string-length(name/namePart[@type = 'given']) &gt; 0">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="string-length(name/namePart[@type = 'given']) &gt; 0">
            <xsl:value-of select="name/namePart[@type = 'given']"/>
        </xsl:if>
        <xsl:if test="string-length(name/namePart[@type = 'numeration']) &gt; 0">
            <xsl:text> </xsl:text>
            <xsl:value-of select="name/namePart[@type = 'numeration']"/>
        </xsl:if>
        <xsl:if test="name/@type = 'personal'">
            <xsl:if test="string-length(name/namePart[@type = 'termsOfAddress']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="name/namePart[@type = 'termsOfAddress']"/>
            </xsl:if>
        </xsl:if>
        <xsl:if test="string-length(../personInfo/displayDate) &gt; 0 or string-length(../personInfo/birthDate/date/year) &gt; 0 or string-length(../personInfo/deathDate/date/year) &gt; 0">
            <xsl:text>, </xsl:text>
            <xsl:choose>
                <xsl:when test="string-length(../personInfo/displayDate) &gt; 0">
                    <xsl:value-of select="../personInfo/displayDate"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length(../personInfo/birthDate/date/year) &gt; 0">
                        <xsl:value-of select="../personInfo/birthDate/date/year"/>
                    </xsl:if>
                    <xsl:text>-</xsl:text>
                    <xsl:if test="string-length(../personInfo/deathDate/date/year) &gt; 0">
                        <xsl:value-of select="../personInfo/deathDate/date/year"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="linkedOrganisation">
        <xsl:for-each select="organisation">
            <alvin:organisation>
                <alvin:Organisation>
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$host"/>
                        <xsl:value-of select="linkedRecordType"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="linkedRecordId"/>
                    </xsl:attribute>
                    <xsl:for-each select="linkedRecord/organisation/authority">
                        <rdfs:label>
                            <xsl:call-template name="authlang"/>
                            <xsl:call-template name="labelOrganisation"/>
                        </rdfs:label>
                    </xsl:for-each>
                </alvin:Organisation>
            </alvin:organisation>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labelOrganisation">
        <xsl:if test="string-length(name/namePart[@type = 'corporateName']) &gt; 0">
            <xsl:value-of select="name/namePart[@type = 'corporateName']"/>
            <xsl:if test="string-length(name/namePart[@type = 'subordinate']) &gt; 0">
                <xsl:text>. </xsl:text>
                <xsl:value-of select="name/namePart[@type = 'subordinate']"/>
            </xsl:if>
            <xsl:if test="name/@type = 'corporate'">
                <xsl:if test="string-length(name/namePart[@type = 'termsOfAddress']) &gt; 0">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="name/namePart[@type = 'termsOfAddress']"/>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template name="linkedPlace">
        <xsl:for-each select="place">
            <alvin:place>
                <alvin:Place>
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$host"/>
                        <xsl:value-of select="linkedRecordType"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="linkedRecordId"/>
                    </xsl:attribute>
                    <xsl:for-each select="linkedRecord/place/authority">
                        <rdfs:label>
                            <xsl:call-template name="authlang"/>
                            <xsl:call-template name="labelPlace"/>
                        </rdfs:label>
                    </xsl:for-each>
                </alvin:Place>
            </alvin:place>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labelPlace">
        <xsl:for-each select="geographic">
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labels">
        <rdfs:label xml:lang="en">
            <xsl:value-of select="@_value_en"/>
        </rdfs:label>
        <rdfs:label xml:lang="no">
            <xsl:value-of select="@_value_no"/>
        </rdfs:label>
        <rdfs:label xml:lang="sv">
            <xsl:value-of select="@_value_sv"/>
        </rdfs:label>
    </xsl:template>
    <xsl:template name="authlang">
        <xsl:attribute name="xml:lang">
            <xsl:choose>
                <xsl:when test="@lang = 'swe'">
                    <xsl:text>sv</xsl:text>
                </xsl:when>
                <xsl:when test="@lang = 'eng'">
                    <xsl:text>en</xsl:text>
                </xsl:when>
                <xsl:when test="@lang = 'nor'">
                    <xsl:text>no</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="date">
        <xsl:for-each select="date">
            <alvin:Date>
                <xsl:for-each select="year">
                    <alvin:year>
                        <xsl:value-of select="."/>
                    </alvin:year>
                </xsl:for-each>
                <xsl:for-each select="month">
                    <alvin:month>
                        <xsl:value-of select="."/>
                    </alvin:month>
                </xsl:for-each>
                <xsl:for-each select="day">
                    <alvin:day>
                        <xsl:value-of select="."/>
                    </alvin:day>
                </xsl:for-each>
                <xsl:for-each select="era">
                    <alvin:era>
                        <alvin:Era>
                            <xsl:call-template name="labels"/>
                            <skos:notation>
                                <xsl:value-of select="."/>
                            </skos:notation>
                        </alvin:Era>
                    </alvin:era>
                </xsl:for-each>
            </alvin:Date>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="locus">
        <xsl:for-each select="locus">
            <alvin:locus>
                <xsl:value-of select="."/>
            </alvin:locus>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="title">
        <xsl:for-each select="title">
            <alvin:title>
                <alvin:Title>
                    <rdfs:label>
                        <xsl:value-of select="mainTitle"/>
                        <xsl:if test="string-length(subtitle) &gt; 0">
                            <xsl:text> : </xsl:text>
                            <xsl:value-of select="subtitle"/>
                        </xsl:if>
                    </rdfs:label>
                    <xsl:for-each select="mainTitle">
                        <alvin:mainTitle>
                            <xsl:value-of select="."/>
                        </alvin:mainTitle>
                    </xsl:for-each>
                    <xsl:for-each select="subtitle">
                        <alvin:subtitle>
                            <xsl:value-of select="."/>
                        </alvin:subtitle>
                    </xsl:for-each>
                    <xsl:call-template name="orientationCode"/>
                </alvin:Title>
            </alvin:title>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="variantTitle">
        <xsl:for-each select="variantTitle">
            <alvin:variantTitle>
                <alvin:VariantTitle>
                    <rdfs:label>
                        <xsl:value-of select="mainTitle"/>
                        <xsl:if test="string-length(subtitle) &gt; 0">
                            <xsl:text> : </xsl:text>
                            <xsl:value-of select="subtitle"/>
                        </xsl:if>
                    </rdfs:label>
                    <xsl:for-each select="mainTitle">
                        <alvin:mainTitle>
                            <xsl:value-of select="."/>
                        </alvin:mainTitle>
                    </xsl:for-each>
                    <xsl:for-each select="subtitle">
                        <alvin:subTitle>
                            <xsl:value-of select="."/>
                        </alvin:subTitle>
                    </xsl:for-each>
                    <xsl:for-each select="@variantType">
                        <alvin:variantType>
                            <alvin:VariantType>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:VariantType>
                        </alvin:variantType>
                    </xsl:for-each>
                    <xsl:call-template name="orientationCode"/>
                </alvin:VariantTitle>
            </alvin:variantTitle>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="agent">
        <xsl:for-each select="agent">
            <alvin:agent>
                <alvin:Agent>
                    <xsl:call-template name="linkedPerson"/>
                    <xsl:call-template name="linkedOrganisation"/>
                    <xsl:for-each select="role">
                        <alvin:role>
                            <alvin:Role>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Role>
                        </alvin:role>
                    </xsl:for-each>
                </alvin:Agent>
            </alvin:agent>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="language">
        <xsl:for-each select="language">
            <alvin:language>
                <alvin:Language>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:Language>
            </alvin:language>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="lang">
        <xsl:for-each select="@lang">
            <alvin:language>
                <alvin:Language>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:Language>
            </alvin:language>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="originPlace">
        <xsl:for-each select="originPlace">
            <alvin:originPlace>
                <alvin:OriginPlace>
                    <xsl:for-each select="place">
                        <alvin:place>
                            <alvin:Place>
                                <xsl:attribute name="rdf:about">
                                    <xsl:value-of select="$host"/>
                                    <xsl:value-of select="linkedRecordType"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:for-each select="linkedRecord/place/authority">
                                    <rdfs:label>
                                        <xsl:call-template name="authlang"/>
                                        <xsl:for-each select="geographic">
                                            <xsl:value-of select="."/>
                                        </xsl:for-each>
                                    </rdfs:label>
                                </xsl:for-each>
                            </alvin:Place>
                        </alvin:place>
                    </xsl:for-each>
                    <xsl:call-template name="country"/>
                    <xsl:for-each select="historicalCountry">
                        <alvin:historicalCountry>
                            <alvin:HistoricalCountry>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:HistoricalCountry>
                        </alvin:historicalCountry>
                    </xsl:for-each>
                    <xsl:for-each select="certainty">
                        <alvin:certainty>
                            <alvin:Certainty>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Certainty>
                        </alvin:certainty>
                    </xsl:for-each>
                </alvin:OriginPlace>
            </alvin:originPlace>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="originDate">
        <xsl:for-each select="originDate">
            <alvin:originDate>
                <alvin:OriginDate>
                    <xsl:for-each select="startDate">
                        <alvin:startDate>
                            <xsl:call-template name="date"/>
                        </alvin:startDate>
                    </xsl:for-each>
                    <xsl:for-each select="endDate">
                        <alvin:endDate>
                            <xsl:call-template name="date"/>
                        </alvin:endDate>
                    </xsl:for-each>
                    <xsl:for-each select="displayDate">
                        <alvin:displayDate>
                            <xsl:value-of select="."/>
                        </alvin:displayDate>
                    </xsl:for-each>
                </alvin:OriginDate>
            </alvin:originDate>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="dateOther">
        <xsl:for-each select="dateOther">
            <alvin:dateOther>
                <alvin:DateOther>
                    <xsl:for-each select="startDate">
                        <alvin:startDate>
                            <xsl:call-template name="date"/>
                        </alvin:startDate>
                    </xsl:for-each>
                    <xsl:for-each select="endDate">
                        <alvin:endDate>
                            <xsl:call-template name="date"/>
                        </alvin:endDate>
                    </xsl:for-each>
                    <xsl:for-each select="@type">
                        <alvin:dateType>
                            <alvin:DateType>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:DateType>
                        </alvin:dateType>
                    </xsl:for-each>
                    <xsl:call-template name="note"/>
                </alvin:DateOther>
            </alvin:dateOther>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="extent">
        <xsl:for-each select="extent">
            <alvin:extent>
                <xsl:value-of select="."/>
                <xsl:if test="@unit = 'shelfMetres'">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="translate(@_en, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                </xsl:if>
                <xsl:if test="@unit = 'archivalUnits'">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="translate(@_en, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                </xsl:if>
            </alvin:extent>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="physicalDescription">
        <xsl:for-each select="physicalDescription">
            <alvin:physicalDescription>
                <alvin:PhysicalDescription>
                    <xsl:call-template name="note"/>
                </alvin:PhysicalDescription>
            </alvin:physicalDescription>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="identifier">
        <xsl:for-each select="identifier">
            <alvin:identifier>
                <alvin:Identifier>
                    <rdf:value>
                        <xsl:value-of select="."/>
                    </rdf:value>
                    <xsl:for-each select="@type">
                        <alvin:identifierType>
                            <alvin:IdentifierType>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:IdentifierType>
                        </alvin:identifierType>
                    </xsl:for-each>
                </alvin:Identifier>
            </alvin:identifier>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="accessPolicy">
        <xsl:for-each select="accessPolicy">
            <alvin:accessPolicy>
                <xsl:value-of select="."/>
            </alvin:accessPolicy>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="incipit">
        <xsl:for-each select="incipit">
            <alvin:incipit>
                <xsl:value-of select="."/>
            </alvin:incipit>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="explicit">
        <xsl:for-each select="explicit">
            <alvin:explicit>
                <xsl:value-of select="."/>
            </alvin:explicit>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="rubric">
        <xsl:for-each select="rubric">
            <alvin:rubric>
                <xsl:value-of select="."/>
            </alvin:rubric>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="finalRubric">
        <xsl:for-each select="finalRubric">
            <alvin:finalRubric>
                <xsl:value-of select="."/>
            </alvin:finalRubric>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="listBibl">
        <xsl:for-each select="listBibl">
            <alvin:listBibl>
                <xsl:value-of select="."/>
            </alvin:listBibl>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="note">
        <xsl:for-each select="note">
            <xsl:if test="not(@noteType = 'internal')">
                <alvin:note>
                    <alvin:Note>
                        <rdfs:label>
                            <xsl:value-of select="."/>
                        </rdfs:label>
                        <xsl:for-each select="@noteType">
                            <alvin:noteType>
                                <alvin:NoteType>
                                    <skos:notation>
                                        <xsl:value-of select="."/>
                                    </skos:notation>
                                </alvin:NoteType>
                            </alvin:noteType>
                        </xsl:for-each>
                    </alvin:Note>
                </alvin:note>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="relatedTo">
        <xsl:for-each select="relatedTo">
            <alvin:relatedTo>
                <alvin:RelatedTo>
                    <xsl:for-each select="record">
                        <alvin:record>
                            <alvin:Record>
                                <xsl:attribute name="rdf:about">
                                    <xsl:value-of select="$host"/>
                                    <xsl:value-of select="linkedRecordType"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="linkedRecordId"/>
                                </xsl:attribute>
                                <xsl:for-each select="linkedRecord/record/title">
                                    <rdfs:label>
                                        <xsl:value-of select="mainTitle"/>
                                        <xsl:if test="string-length(subtitle) &gt; 0">
                                            <xsl:text> : </xsl:text>
                                            <xsl:value-of select="subtitle"/>
                                        </xsl:if>
                                    </rdfs:label>
                                </xsl:for-each>
                            </alvin:Record>
                        </alvin:record>
                    </xsl:for-each>
                    <xsl:for-each select="@relatedToType">
                        <alvin:relatedToType>
                            <alvin:RelatedToType>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:RelatedToType>
                        </alvin:relatedToType>
                    </xsl:for-each>
                    <xsl:for-each select="part">
                        <alvin:part>
                            <alvin:Part>
                                <xsl:for-each select="partNumber">
                                    <alvin:partNumber>
                                        <xsl:value-of select="."/>
                                    </alvin:partNumber>
                                </xsl:for-each>
                                <xsl:for-each select="extent">
                                    <alvin:extent>
                                        <xsl:value-of select="."/>
                                    </alvin:extent>
                                </xsl:for-each>
                                <xsl:for-each select="@partType">
                                    <alvin:partType>
                                        <alvin:PartType>
                                            <skos:notation>
                                                <xsl:value-of select="."/>
                                            </skos:notation>
                                        </alvin:PartType>
                                    </alvin:partType>
                                </xsl:for-each>
                            </alvin:Part>
                        </alvin:part>
                    </xsl:for-each>
                </alvin:RelatedTo>
            </alvin:relatedTo>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="electronicLocator">
        <xsl:for-each select="electronicLocator">
            <alvin:electronicLocator>
                <alvin:ElectronicLocator>
                    <xsl:for-each select="url">
                        <alvin:url>
                            <xsl:value-of select="."/>
                        </alvin:url>
                    </xsl:for-each>
                    <xsl:for-each select="displayLabel">
                        <alvin:displayLabel>
                            <xsl:value-of select="."/>
                        </alvin:displayLabel>
                    </xsl:for-each>
                </alvin:ElectronicLocator>
            </alvin:electronicLocator>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="level">
        <xsl:for-each select="level">
            <alvin:level>
                <alvin:Level>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:Level>
            </alvin:level>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="recordInfo">
        <xsl:for-each select="recordInfo">
            <alvin:recordInfo>
                <alvin:RecordInfo>
                    <xsl:for-each select="id">
                        <alvin:recordIdentifier>
                            <xsl:value-of select="../type/linkedRecordId"/>
                            <xsl:text>:</xsl:text>
                            <xsl:value-of select="."/>
                        </alvin:recordIdentifier>
                    </xsl:for-each>
                    <xsl:for-each select="tsCreated">
                        <alvin:recordCreationDate>
                            <xsl:value-of select="."/>
                        </alvin:recordCreationDate>
                    </xsl:for-each>
                    <xsl:for-each select="updated/tsUpdated">
                        <xsl:if test="position() = last()">
                            <alvin:recordChangeDate>
                                <xsl:value-of select="."/>
                            </alvin:recordChangeDate>
                        </xsl:if>
                    </xsl:for-each>
                </alvin:RecordInfo>
            </alvin:recordInfo>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="msItem">
        <xsl:call-template name="locus"/>
        <xsl:call-template name="title"/>
        <xsl:call-template name="agent"/>
        <xsl:call-template name="language"/>
        <xsl:call-template name="originPlace"/>
        <xsl:call-template name="originDate"/>
        <xsl:call-template name="physicalDescription"/>
        <xsl:call-template name="incipit"/>
        <xsl:call-template name="explicit"/>
        <xsl:call-template name="rubric"/>
        <xsl:call-template name="finalRubric"/>
        <xsl:call-template name="listBibl"/>
        <xsl:call-template name="note"/>
        <xsl:call-template name="relatedTo"/>
    </xsl:template>
    <xsl:template name="component">
        <xsl:call-template name="level"/>
        <xsl:for-each select="unitid">
            <alvin:unitid>
                <xsl:value-of select="."/>
            </alvin:unitid>
        </xsl:for-each>
        <xsl:call-template name="title"/>
        <xsl:call-template name="agent"/>
        <xsl:call-template name="linkedPlace"/>
        <xsl:call-template name="originDate"/>
        <xsl:call-template name="extent"/>
        <xsl:call-template name="note"/>
        <xsl:call-template name="identifier"/>
        <xsl:call-template name="relatedTo"/>
        <xsl:call-template name="electronicLocator"/>
        <xsl:call-template name="accessPolicy"/>
    </xsl:template>
    <xsl:template name="musicKey">
        <xsl:for-each select="musicKey">
            <alvin:musicKey>
                <alvin:MusicKey>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:MusicKey>
            </alvin:musicKey>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="musicKeyOther">
        <xsl:for-each select="musicKeyOther">
            <alvin:musicKey>
                <alvin:MusicKey>
                    <rdfs:label>
                        <xsl:value-of select="."/>
                    </rdfs:label>
                </alvin:MusicKey>
            </alvin:musicKey>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="musicMedium">
        <xsl:for-each select="musicMedium">
            <alvin:musicMedium>
                <alvin:MusicMedium>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:MusicMedium>
            </alvin:musicMedium>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="musicMediumOther">
        <xsl:for-each select="musicMediumOther">
            <alvin:musicMedium>
                <alvin:MusicMedium>
                    <rdfs:label>
                        <xsl:value-of select="."/>
                    </rdfs:label>
                </alvin:MusicMedium>
            </alvin:musicMedium>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="genre">
        <xsl:for-each select="genre">
            <alvin:genre>
                <alvin:Genre>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:Genre>
            </alvin:genre>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="point">
        <xsl:for-each select="point">
            <alvin:point>
                <alvin:Point>
                    <xsl:for-each select="latitude">
                        <alvin:latitude>
                            <xsl:value-of select="."/>
                        </alvin:latitude>
                    </xsl:for-each>
                    <xsl:for-each select="longitude">
                        <alvin:longitude>
                            <xsl:value-of select="."/>
                        </alvin:longitude>
                    </xsl:for-each>
                </alvin:Point>
            </alvin:point>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="country">
        <xsl:for-each select="country">
            <alvin:country>
                <alvin:Country>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:Country>
            </alvin:country>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="about">
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$host"/>
            <xsl:value-of select="recordInfo/type/linkedRecordId"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="recordInfo/id"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="orientationCode">
        <xsl:for-each select="orientationCode">
            <alvin:orientationCode>
                <alvin:OrientationCode>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:OrientationCode>
            </alvin:orientationCode>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="summary">
        <xsl:for-each select="summary">
            <alvin:summary>
                <alvin:Summary>
                    <rdfs:label>
                        <xsl:value-of select="."/>
                    </rdfs:label>
                    <xsl:call-template name="lang"/>
                </alvin:Summary>
            </alvin:summary>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="fileLocation">
        <xsl:for-each select="*/actionLinks/read">
            <alvin:fileLocation>
                <xsl:value-of select="url"/>
            </alvin:fileLocation>
        </xsl:for-each>
        <xsl:for-each select="originalFileName">
            <alvin:originalName>
                <xsl:value-of select="."/>
            </alvin:originalName>
        </xsl:for-each>
        <xsl:for-each select="fileSize">
            <alvin:size>
                <xsl:value-of select="."/>
            </alvin:size>
        </xsl:for-each>
        <xsl:for-each select="mimeType">
            <alvin:mimeType>
                <xsl:value-of select="."/>
            </alvin:mimeType>
        </xsl:for-each>
        <xsl:for-each select="width">
            <alvin:width>
                <xsl:value-of select="."/>
            </alvin:width>
        </xsl:for-each>
        <xsl:for-each select="height">
            <alvin:height>
                <xsl:value-of select="."/>
            </alvin:height>
        </xsl:for-each>
        <xsl:for-each select="checksum">
            <alvin:checksum>
                <alvin:Checksum>
                    <rdf:value>
                        <xsl:value-of select="."/>
                    </rdf:value>
                    <xsl:for-each select="../checksumType">
                        <alvin:checksumType>
                            <xsl:value-of select="."/>
                        </alvin:checksumType>
                    </xsl:for-each>
                </alvin:Checksum>
            </alvin:checksum>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="typeOfResource">
        <xsl:for-each select="typeOfResource">
            <alvin:typeOfResource>
                <alvin:TypeOfResource>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:TypeOfResource>
            </alvin:typeOfResource>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="collection">
        <xsl:for-each select="collection">
            <alvin:collection>
                <alvin:Collection>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:Collection>
            </alvin:collection>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="productionMethod">
        <xsl:for-each select="productionMethod">
            <alvin:productionMethod>
                <alvin:ProductionMethod>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:ProductionMethod>
            </alvin:productionMethod>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="physicalLocation">
        <xsl:for-each select="physicalLocation">
            <alvin:physicalLocation>
                <alvin:PhysicalLocation>
                    <xsl:for-each select="heldBy">
                        <alvin:heldBy>
                            <alvin:HeldBy>
                                <xsl:for-each select="location">
                                    <alvin:location>
                                        <alvin:Location>
                                            <xsl:attribute name="rdf:about">
                                                <xsl:value-of select="$host"/>
                                                <xsl:value-of select="linkedRecordType"/>
                                                <xsl:text>/</xsl:text>
                                                <xsl:value-of select="linkedRecordId"/>
                                            </xsl:attribute>
                                            <xsl:for-each select="linkedRecord/location/authority">
                                                <rdfs:label>
                                                    <xsl:call-template name="authlang"/>
                                                    <xsl:for-each select="name/namePart[@type = 'corporateName']">
                                                        <xsl:value-of select="."/>
                                                    </xsl:for-each>
                                                </rdfs:label>
                                            </xsl:for-each>
                                        </alvin:Location>
                                    </alvin:location>
                                </xsl:for-each>
                            </alvin:HeldBy>
                        </alvin:heldBy>
                    </xsl:for-each>
                    <xsl:for-each select="shelfMark">
                        <alvin:shelfMark>
                            <xsl:value-of select="."/>
                        </alvin:shelfMark>
                    </xsl:for-each>
                    <xsl:for-each select="formerShelfMark">
                        <alvin:formerShelfMark>
                            <xsl:value-of select="."/>
                        </alvin:formerShelfMark>
                    </xsl:for-each>
                    <xsl:for-each select="sublocation">
                        <alvin:sublocation>
                            <xsl:value-of select="."/>
                        </alvin:sublocation>
                    </xsl:for-each>
                    <xsl:for-each select="subcollection/*">
                        <alvin:subcollection>
                            <alvin:Subcollection>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Subcollection>
                        </alvin:subcollection>
                    </xsl:for-each>
                    <xsl:call-template name="note"/>
                </alvin:PhysicalLocation>
            </alvin:physicalLocation>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="adminMetadata">
        <xsl:for-each select="adminMetadata">
            <alvin:adminMetadata>
                <alvin:AdminMetadata>
                    <xsl:for-each select="descriptionLanguage">
                        <alvin:descriptionLanguage>
                            <alvin:DescriptionLanguage>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:DescriptionLanguage>
                        </alvin:descriptionLanguage>
                    </xsl:for-each>
                </alvin:AdminMetadata>
            </alvin:adminMetadata>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="editionStatement">
        <xsl:for-each select="editionStatement">
            <alvin:editionStatement>
                <xsl:value-of select="."/>
            </alvin:editionStatement>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="publication">
        <xsl:for-each select="publication">
            <alvin:publication>
                <xsl:value-of select="."/>
            </alvin:publication>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="dimensions">
        <xsl:for-each select="dimensions">
            <alvin:dimensions>
                <alvin:Dimensions>
                    <xsl:for-each select="height">
                        <alvin:height>
                            <xsl:value-of select="."/>
                        </alvin:height>
                    </xsl:for-each>
                    <xsl:for-each select="width">
                        <alvin:width>
                            <xsl:value-of select="."/>
                        </alvin:width>
                    </xsl:for-each>
                    <xsl:for-each select="depth">
                        <alvin:depth>
                            <xsl:value-of select="."/>
                        </alvin:depth>
                    </xsl:for-each>
                    <xsl:for-each select="diameter">
                        <alvin:diameter>
                            <xsl:value-of select="."/>
                        </alvin:diameter>
                    </xsl:for-each>
                    <xsl:for-each select="unit">
                        <alvin:unit>
                            <alvin:Unit>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Unit>
                        </alvin:unit>
                    </xsl:for-each>
                    <xsl:for-each select="scope">
                        <alvin:scope>
                            <alvin:Scope>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Scope>
                        </alvin:scope>
                    </xsl:for-each>
                </alvin:Dimensions>
            </alvin:dimensions>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="measure">
        <xsl:for-each select="measure">
            <alvin:measure>
                <alvin:Measure>
                    <xsl:for-each select="weight">
                        <alvin:weight>
                            <xsl:value-of select="."/>
                        </alvin:weight>
                    </xsl:for-each>
                    <xsl:for-each select="unit">
                        <alvin:unit>
                            <alvin:Unit>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Unit>
                        </alvin:unit>
                    </xsl:for-each>
                </alvin:Measure>
            </alvin:measure>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="baseMaterial">
        <xsl:for-each select="baseMaterial">
            <alvin:baseMaterial>
                <alvin:BaseMaterial>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:BaseMaterial>
            </alvin:baseMaterial>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="appliedMaterial">
        <xsl:for-each select="appliedMaterial">
            <alvin:appliedMaterial>
                <alvin:AppliedMaterial>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:AppliedMaterial>
            </alvin:appliedMaterial>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="transcription">
        <xsl:for-each select="transcription">
            <alvin:transcription>
                <xsl:value-of select="."/>
            </alvin:transcription>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="tableOfContents">
        <xsl:for-each select="tableOfContents">
            <alvin:tableOfContents>
                <xsl:value-of select="."/>
            </alvin:tableOfContents>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="subject">
        <xsl:for-each select="subject">
            <alvin:subject>
                <alvin:Subject>
                    <xsl:for-each select="topic">
                        <alvin:topic>
                            <xsl:value-of select="."/>
                        </alvin:topic>
                    </xsl:for-each>
                    <xsl:for-each select="genreForm">
                        <alvin:genreForm>
                            <xsl:value-of select="."/>
                        </alvin:genreForm>
                    </xsl:for-each>
                    <xsl:for-each select="geographicCoverage">
                        <alvin:geographicCoverage>
                            <xsl:value-of select="."/>
                        </alvin:geographicCoverage>
                    </xsl:for-each>
                    <xsl:for-each select="temporal">
                        <alvin:temporal>
                            <xsl:value-of select="."/>
                        </alvin:temporal>
                    </xsl:for-each>
                    <xsl:for-each select="occupation">
                        <alvin:occupation>
                            <xsl:value-of select="."/>
                        </alvin:occupation>
                    </xsl:for-each>
                    <xsl:call-template name="linkedPerson"/>
                    <xsl:call-template name="linkedOrganisation"/>
                    <xsl:call-template name="linkedPlace"/>
                    <xsl:if test="@authority">
                        <xsl:if test="not(@authority = 'general')">
                            <skos:inScheme>
                                <skos:ConceptScheme>
                                    <skos:notion>
                                        <xsl:value-of select="@authority"/>
                                    </skos:notion>
                                    <xsl:if test="@authority = 'humord'">
                                        <owl:sameAs rdf:resource="https://data.ub.uio.no/skosmos/humord/"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'iph'">
                                        <owl:sameAs rdf:resource="https://www.paperhistory.org/standard.htm"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'kvinnsam'">
                                        <owl:sameAs rdf:resource="https://kvinnsam.ub.gu.se/databaser/databasen-kvinnsam#amnesordlista"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'lcsh'">
                                        <owl:sameAs rdf:resource="https://id.loc.gov/authorities/subjects.html"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'lob'">
                                        <owl:sameAs rdf:resource="https://lob.is.ed.ac.uk/"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'nad'">
                                        <owl:sameAs rdf:resource="https://sok.riksarkivet.se/nad"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'queerlit'">
                                        <owl:sameAs rdf:resource="https://queerlit.dh.gu.se/subjects"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'sao'">
                                        <owl:sameAs rdf:resource="https://id.kb.se/term/sao"/>
                                    </xsl:if>
                                    <xsl:if test="@authority = 'tgm_II'">
                                        <owl:sameAs rdf:resource="https://id.kb.se/term/gmgpc/swe"/>
                                    </xsl:if>
                                </skos:ConceptScheme>
                            </skos:inScheme>
                        </xsl:if>
                    </xsl:if>
                </alvin:Subject>
            </alvin:subject>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="classification">
        <xsl:for-each select="classification">
            <alvin:classification>
                <alvin:Classification>
                    <rdf:value>
                        <xsl:value-of select="."/>
                    </rdf:value>
                    <skos:inScheme>
                        <skos:ConceptScheme>
                            <skos:notion>
                                <xsl:value-of select="@authority"/>
                            </skos:notion>
                            <xsl:if test="@authority = 'kssb'">
                                <owl:sameAs rdf:resource="https://id.kb.se/term/kssb"/>
                            </xsl:if>
                            <xsl:if test="@authority = 'ddc'">
                                <owl:sameAs rdf:resource="https://www.oclc.org/en/dewey.html"/>
                            </xsl:if>
                            <xsl:if test="@authority = 'iph'">
                                <owl:sameAs rdf:resource="https://www.paperhistory.org/standard.htm"/>
                            </xsl:if>
                            <xsl:if test="@authority = 'iconclass'">
                                <owl:sameAs rdf:resource="https://iconclass.org/"/>
                            </xsl:if>
                        </skos:ConceptScheme>
                    </skos:inScheme>
                </alvin:Classification>
            </alvin:classification>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="bindingDesc">
        <xsl:for-each select="bindingDesc">
            <alvin:bindingDesc>
                <alvin:BindingDesc>
                    <xsl:for-each select="binding">
                        <alvin:binding>
                            <xsl:value-of select="."/>
                        </alvin:binding>
                    </xsl:for-each>
                    <xsl:call-template name="decoNote"/>
                </alvin:BindingDesc>
            </alvin:bindingDesc>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="decoNote">
        <xsl:for-each select="decoNote">
            <alvin:decoNote>
                <xsl:value-of select="."/>
            </alvin:decoNote>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="urn">
        <xsl:for-each select="recordInfo/urn">
            <alvin:identifier>
                <alvin:Identifier>
                    <rdf:value>
                        <xsl:value-of select="."/>
                    </rdf:value>
                    <alvin:identifierType>
                        <alvin:IdentifierType>
                            <rdfs:label xml:lang="en">URN</rdfs:label>
                            <rdfs:label xml:lang="no">URN</rdfs:label>
                            <rdfs:label xml:lang="sv">URN</rdfs:label>
                            <skos:notation>
                                <xsl:text>urn</xsl:text>
                            </skos:notation>
                        </alvin:IdentifierType>
                    </alvin:identifierType>
                </alvin:Identifier>
            </alvin:identifier>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="work">
        <xsl:for-each select="work">
            <alvin:work>
                <alvin:Work>
                    <xsl:attribute name="rdf:about">
                        <xsl:value-of select="$host"/>
                        <xsl:value-of select="linkedRecordType"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="linkedRecordId"/>
                    </xsl:attribute>
                    <xsl:for-each select="linkedRecord/work/title">
                        <rdfs:label>
                            <xsl:value-of select="mainTitle"/>
                            <xsl:if test="string-length(subtitle) &gt; 0">
                                <xsl:text> : </xsl:text>
                                <xsl:value-of select="subtitle"/>
                            </xsl:if>
                        </rdfs:label>
                    </xsl:for-each>
                </alvin:Work>
            </alvin:work>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="otherfindaid">
        <xsl:for-each select="otherfindaid">
            <alvin:otherfindaid>
                <xsl:value-of select="."/>
            </alvin:otherfindaid>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="weeding">
        <xsl:for-each select="weeding">
            <alvin:weeding>
                <xsl:value-of select="."/>
            </alvin:weeding>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="relatedmaterial">
        <xsl:for-each select="relatedmaterial">
            <alvin:relatedmaterial>
                <xsl:value-of select="."/>
            </alvin:relatedmaterial>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="arrangement">
        <xsl:for-each select="arrangement">
            <alvin:arrangement>
                <xsl:value-of select="."/>
            </alvin:arrangement>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="accruals">
        <xsl:for-each select="accruals">
            <alvin:accruals>
                <xsl:value-of select="."/>
            </alvin:accruals>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="musicNotation">
        <xsl:for-each select="musicNotation">
            <alvin:musicNotation>
                <alvin:MusicNotation>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:MusicNotation>
            </alvin:musicNotation>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="cartographicAttributes">
        <xsl:for-each select="cartographicAttributes">
            <alvin:cartographicAttributes>
                <alvin:CartographicAttributes>
                    <xsl:for-each select="scale">
                        <alvin:scale>
                            <xsl:value-of select="."/>
                        </alvin:scale>
                    </xsl:for-each>
                    <xsl:for-each select="projection">
                        <alvin:projection>
                            <xsl:value-of select="."/>
                        </alvin:projection>
                    </xsl:for-each>
                    <xsl:for-each select="coordinates">
                        <alvin:coordinates>
                            <xsl:value-of select="."/>
                        </alvin:coordinates>
                    </xsl:for-each>
                </alvin:CartographicAttributes>
            </alvin:cartographicAttributes>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="appraisal">
        <xsl:for-each select="appraisal">
            <alvin:appraisal>
                <alvin:Appraisal>
                    <xsl:for-each select="value">
                        <alvin:monetaryValue>
                            <xsl:value-of select="."/>
                        </alvin:monetaryValue>
                    </xsl:for-each>
                    <xsl:for-each select="currency">
                        <alvin:currency>
                            <xsl:value-of select="."/>
                        </alvin:currency>
                    </xsl:for-each>
                </alvin:Appraisal>
            </alvin:appraisal>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="axis">
        <xsl:for-each select="axis">
            <alvin:axis>
                <alvin:Axis>
                    <xsl:for-each select="clock">
                        <alvin:clock>
                            <alvin:Clock>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:Clock>
                        </alvin:clock>
                    </xsl:for-each>
                </alvin:Axis>
            </alvin:axis>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="countermark">
        <xsl:for-each select="countermark">
            <alvin:countermark>
                <xsl:value-of select="."/>
            </alvin:countermark>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="edge">
        <xsl:for-each select="edge">
            <alvin:edge>
                <alvin:Edge>
                    <xsl:for-each select="description">
                        <alvin:edgeDescription>
                            <alvin:EdgeDescription>
                                <xsl:call-template name="labels"/>
                                <skos:notation>
                                    <xsl:value-of select="."/>
                                </skos:notation>
                            </alvin:EdgeDescription>
                        </alvin:edgeDescription>
                    </xsl:for-each>
                    <xsl:for-each select="legend">
                        <alvin:legend>
                            <xsl:value-of select="."/>
                        </alvin:legend>
                    </xsl:for-each>
                </alvin:Edge>
            </alvin:edge>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="conservationState">
        <xsl:for-each select="conservationState">
            <alvin:conservationState>
                <alvin:ConservationState>
                    <xsl:call-template name="labels"/>
                    <skos:notation>
                        <xsl:value-of select="."/>
                    </skos:notation>
                </alvin:ConservationState>
            </alvin:conservationState>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="obverse">
        <xsl:for-each select="obverse">
            <alvin:obverse>
                <alvin:Obverse>
                    <xsl:for-each select="description">
                        <alvin:description>
                            <xsl:value-of select="."/>
                        </alvin:description>
                    </xsl:for-each>
                    <xsl:for-each select="legend">
                        <alvin:legend>
                            <xsl:value-of select="."/>
                        </alvin:legend>
                    </xsl:for-each>
                </alvin:Obverse>
            </alvin:obverse>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="reverse">
        <xsl:for-each select="reverse">
            <alvin:reverse>
                <alvin:Reverse>
                    <xsl:for-each select="description">
                        <alvin:description>
                            <xsl:value-of select="."/>
                        </alvin:description>
                    </xsl:for-each>
                    <xsl:for-each select="legend">
                        <alvin:legend>
                            <xsl:value-of select="."/>
                        </alvin:legend>
                    </xsl:for-each>
                </alvin:Reverse>
            </alvin:reverse>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="msContents">
        <xsl:for-each select="msContents">
            <alvin:msContents>
                <alvin:MsContents>
                    <xsl:for-each select="msItem01">
                        <alvin:msItem>
                            <alvin:MsItem>
                                <xsl:call-template name="msItem"/>
                                <xsl:for-each select="msItem02">
                                    <alvin:msItem>
                                        <alvin:MsItem>
                                            <xsl:call-template name="msItem"/>
                                            <xsl:for-each select="msItem03">
                                                <alvin:msItem>
                                                    <alvin:MsItem>
                                                        <xsl:call-template name="msItem"/>
                                                        <xsl:for-each select="msItem04">
                                                            <alvin:msItem>
                                                                <alvin:MsItem>
                                                                    <xsl:call-template name="msItem"/>
                                                                    <xsl:for-each select="msItem05">
                                                                        <alvin:msItem>
                                                                            <alvin:MsItem>
                                                                                <xsl:call-template name="msItem"/>
                                                                                <xsl:for-each select="msItem06">
                                                                                    <alvin:msItem>
                                                                                        <alvin:MsItem>
                                                                                            <xsl:call-template name="msItem"/>
                                                                                        </alvin:MsItem>
                                                                                    </alvin:msItem>
                                                                                </xsl:for-each>
                                                                            </alvin:MsItem>
                                                                        </alvin:msItem>
                                                                    </xsl:for-each>
                                                                </alvin:MsItem>
                                                            </alvin:msItem>
                                                        </xsl:for-each>
                                                    </alvin:MsItem>
                                                </alvin:msItem>
                                            </xsl:for-each>
                                        </alvin:MsItem>
                                    </alvin:msItem>
                                </xsl:for-each>
                            </alvin:MsItem>
                        </alvin:msItem>
                    </xsl:for-each>
                </alvin:MsContents>
            </alvin:msContents>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="descriptionOfSubordinateComponents">
        <xsl:for-each select="descriptionOfSubordinateComponents">
            <alvin:descriptionOfSubordinateComponents>
                <alvin:DescriptionOfSubordinateComponents>
                    <xsl:for-each select="component01">
                        <alvin:component>
                            <alvin:Component>
                                <xsl:call-template name="component"/>
                                <xsl:for-each select="component02">
                                    <alvin:component>
                                        <alvin:Component>
                                            <xsl:call-template name="component"/>
                                            <xsl:for-each select="component03">
                                                <alvin:component>
                                                    <alvin:Component>
                                                        <xsl:call-template name="component"/>
                                                        <xsl:for-each select="component04">
                                                            <alvin:component>
                                                                <alvin:Component>
                                                                    <xsl:call-template name="component"/>
                                                                    <xsl:for-each select="component05">
                                                                        <alvin:component>
                                                                            <alvin:Component>
                                                                                <xsl:call-template name="component"/>
                                                                                <xsl:for-each select="component06">
                                                                                    <alvin:component>
                                                                                        <alvin:Component>
                                                                                            <xsl:call-template name="component"/>
                                                                                        </alvin:Component>
                                                                                    </alvin:component>
                                                                                </xsl:for-each>
                                                                            </alvin:Component>
                                                                        </alvin:component>
                                                                    </xsl:for-each>
                                                                </alvin:Component>
                                                            </alvin:component>
                                                        </xsl:for-each>
                                                    </alvin:Component>
                                                </alvin:component>
                                            </xsl:for-each>
                                        </alvin:Component>
                                    </alvin:component>
                                </xsl:for-each>
                            </alvin:Component>
                        </alvin:component>
                    </xsl:for-each>
                </alvin:DescriptionOfSubordinateComponents>
            </alvin:descriptionOfSubordinateComponents>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="fileSection">
        <xsl:for-each select="fileSection">
            <xsl:if test="fileGroup/file/fileLocation/linkedRecord">
                <alvin:fileSection>
                    <alvin:FileSection>
                        <xsl:for-each select="rights">
                            <alvin:rights>
                                <alvin:Rights>
                                    <xsl:call-template name="labels"/>
                                    <skos:notation>
                                        <xsl:value-of select="."/>
                                    </skos:notation>
                                </alvin:Rights>
                            </alvin:rights>
                        </xsl:for-each>
                        <xsl:for-each select="digitalOrigin">
                            <alvin:digitalOrigin>
                                <alvin:DigitalOrigin>
                                    <xsl:call-template name="labels"/>
                                    <skos:notation>
                                        <xsl:value-of select="."/>
                                    </skos:notation>
                                </alvin:DigitalOrigin>
                            </alvin:digitalOrigin>
                        </xsl:for-each>
                        <xsl:for-each select="fileGroup">
                            <xsl:if test="file/fileLocation/linkedRecord">
                                <alvin:fileGroup>
                                    <alvin:FileGroup>
                                        <xsl:for-each select="internetMediaType">
                                            <alvin:internetMediaType>
                                                <alvin:InternetMediaType>
                                                    <xsl:call-template name="labels"/>
                                                    <skos:notation>
                                                        <xsl:value-of select="."/>
                                                    </skos:notation>
                                                </alvin:InternetMediaType>
                                            </alvin:internetMediaType>
                                        </xsl:for-each>
                                        <xsl:for-each select="type">
                                            <alvin:type>
                                                <alvin:Type>
                                                    <xsl:call-template name="labels"/>
                                                    <skos:notation>
                                                        <xsl:value-of select="."/>
                                                    </skos:notation>
                                                </alvin:Type>
                                            </alvin:type>
                                        </xsl:for-each>
                                        <xsl:for-each select="file">
                                            <xsl:if test="fileLocation/linkedRecord">
                                                <alvin:file>
                                                    <alvin:File>
                                                        <xsl:for-each select="type">
                                                            <alvin:type>
                                                                <alvin:Type>
                                                                    <xsl:call-template name="labels"/>
                                                                    <skos:notation>
                                                                        <xsl:value-of select="."/>
                                                                    </skos:notation>
                                                                </alvin:Type>
                                                            </alvin:type>
                                                        </xsl:for-each>
                                                        <xsl:for-each select="label">
                                                            <alvin:label>
                                                                <xsl:value-of select="."/>
                                                            </alvin:label>
                                                        </xsl:for-each>
                                                        <xsl:for-each select="fileLocation">
                                                            <xsl:for-each select="linkedRecord/binary">
                                                                <xsl:for-each select="master">
                                                                    <xsl:call-template name="fileLocation"/>
                                                                </xsl:for-each>
                                                            </xsl:for-each>
                                                        </xsl:for-each>
                                                    </alvin:File>
                                                </alvin:file>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </alvin:FileGroup>
                                </alvin:fileGroup>
                            </xsl:if>
                        </xsl:for-each>
                    </alvin:FileSection>
                </alvin:fileSection>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
