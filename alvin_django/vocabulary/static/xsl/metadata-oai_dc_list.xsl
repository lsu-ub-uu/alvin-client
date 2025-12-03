<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:apply-templates select="dataList/data/record/data/record"/>
    </xsl:template>
    <xsl:template match="record">
        <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ 
            http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
            <xsl:for-each select="title">
                <dc:title>
                    <xsl:value-of select="mainTitle"/>
                    <xsl:if test="string-length(subtitle) &gt; 0">
                        <xsl:text> : </xsl:text>
                        <xsl:value-of select="subtitle"/>
                    </xsl:if>
                </dc:title>
            </xsl:for-each>
            <xsl:for-each select="agent[@type = 'person'][role = 'aut']">
                <dc:creator>
                    <xsl:call-template name="person"/>
                </dc:creator>
            </xsl:for-each>
            <xsl:for-each select="agent[@type = 'organisation'][role = 'aut']">
                <dc:creator>
                    <xsl:call-template name="organisation"/>
                </dc:creator>
            </xsl:for-each>
            <xsl:for-each select="genreForm">
                <dc:subject>
                    <xsl:value-of select="@_value_en"/>
                </dc:subject>
            </xsl:for-each>
            <xsl:for-each select="subject[@type = 'person']">
                <dc:subject>
                    <xsl:call-template name="person"/>
                </dc:subject>
            </xsl:for-each>
            <xsl:for-each select="subject[@type = 'organisation']">
                <dc:subject>
                    <xsl:call-template name="organisation"/>
                </dc:subject>
            </xsl:for-each>
            <xsl:for-each select="subject[@_en = 'Subject']">
                <xsl:for-each select="topic">
                    <dc:subject>
                        <xsl:value-of select="."/>
                    </dc:subject>
                </xsl:for-each>
                <xsl:for-each select="genreForm">
                    <dc:subject>
                        <xsl:value-of select="."/>
                    </dc:subject>
                </xsl:for-each>
                <xsl:for-each select="temporal">
                    <dc:subject>
                        <xsl:value-of select="."/>
                    </dc:subject>
                </xsl:for-each>
                <xsl:for-each select="occupation">
                    <dc:subject>
                        <xsl:value-of select="."/>
                    </dc:subject>
                </xsl:for-each>
                <xsl:for-each select="geographicCoverage">
                    <dc:coverage>
                        <xsl:value-of select="."/>
                    </dc:coverage>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="subject[@type = 'place']">
                <dc:coverage>
                    <xsl:value-of select="place/linkedRecord/place/authority[1]/geographic"/>
                </dc:coverage>
            </xsl:for-each>
            <xsl:for-each select="summary">
                <dc:description>
                    <xsl:value-of select="."/>
                </dc:description>
            </xsl:for-each>
            <xsl:for-each select="publication">
                <dc:publisher>
                    <xsl:value-of select="."/>
                </dc:publisher>
            </xsl:for-each>
            <xsl:for-each select="agent[@type = 'person'][not(role = 'aut')]">
                <dc:contributor>
                    <xsl:call-template name="person"/>
                </dc:contributor>
            </xsl:for-each>
            <xsl:for-each select="agent[@type = 'organisation'][not(role = 'aut')]">
                <dc:contributor>
                    <xsl:call-template name="organisation"/>
                </dc:contributor>
            </xsl:for-each>
            <xsl:for-each select="originDate">
                <dc:date>
                    <xsl:choose>
                        <xsl:when test="string-length(displayDate) &gt; 0">
                            <xsl:value-of select="displayDate"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="string-length(startDate/date/year) &gt; 0">
                                <xsl:value-of select="startDate/date/year"/>
                            </xsl:if>
                            <xsl:if test="string-length(endDate/date/year) &gt; 0">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="endDate/date/year"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </dc:date>
            </xsl:for-each>
            <xsl:for-each select="typeOfResource">
                <dc:type>
                    <xsl:value-of select="@_value_en"/>
                    <xsl:if test="../productionMethod = 'manuscript'">
                        <xsl:text> (manuscript)</xsl:text>
                    </xsl:if>
                </dc:type>
            </xsl:for-each>
            <xsl:for-each select="recordInfo">
                <dc:identifier>
                    <xsl:text>http://urn.kb.se/resolve?urn=</xsl:text>
                    <xsl:value-of select="urn"/>
                </dc:identifier>
            </xsl:for-each>
            <xsl:for-each select="physicalLocation">
                <dc:identifier>
                    <xsl:value-of select="heldBy/location/linkedRecord/location/authority[1]/name/namePart[@type = 'corporateName']"></xsl:value-of>
                    <xsl:if test="string-length(shelfMark) &gt; 0">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="shelfMark"/>
                    </xsl:if>                       
                </dc:identifier>               
            </xsl:for-each>
            <xsl:for-each select="language">
                <dc:language>
                    <xsl:value-of select="@_value_en"/>
                </dc:language>
            </xsl:for-each>
            <xsl:for-each select="extent">
                <dc:format>
                    <xsl:value-of select="."/>
                </dc:format>
            </xsl:for-each>
            <xsl:for-each select="dimensions">
                <dc:format>
                    <xsl:if test="string-length(height) &gt; 0">
                        <xsl:value-of select="height"/>
                    </xsl:if>
                    <xsl:if test="string-length(width) &gt; 0">                        
                        <xsl:text> x </xsl:text>
                        <xsl:value-of select="width"/>
                    </xsl:if>
                    <xsl:if test="string-length(depth) &gt; 0">                        
                        <xsl:text> x </xsl:text>
                        <xsl:value-of select="depth"/>
                    </xsl:if>
                    <xsl:if test="string-length(diameter) &gt; 0">
                        <xsl:value-of select="diameter"/>
                    </xsl:if>
                    <xsl:if test="string-length(unit) &gt; 0">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="unit"/>
                    </xsl:if>
                    <xsl:if test="string-length(scope) &gt; 0">
                        <xsl:text> (</xsl:text>
                        <xsl:value-of select="scope/@_value_en"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </dc:format>
            </xsl:for-each>
            <xsl:for-each select="fileSection">
                <dc:format>
                    <xsl:text>Digital, </xsl:text>
                    <xsl:value-of select="digitalOrigin/@_value_en"/>
                </dc:format>
            </xsl:for-each>
            <xsl:for-each select="fileSection">
                <dc:rights>
                    <xsl:value-of select="rights/@_value_en"/>
                </dc:rights>
            </xsl:for-each>
        </oai_dc:dc>
    </xsl:template>
    <xsl:template name="person">
        <xsl:for-each select="person/linkedRecord/person">
            <xsl:if test="string-length(authority[1]/name/namePart[@type = 'family']) &gt; 0">
                <xsl:value-of select="authority[1]/name/namePart[@type = 'family']"/>
                <xsl:if test="string-length(authority[1]/name/familyName) &gt; 0">
                    <xsl:text> (family)</xsl:text>
                </xsl:if>
                <xsl:if test="string-length(authority[1]/name/namePart[@type = 'given']) &gt; 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="string-length(authority[1]/name/namePart[@type = 'given']) &gt; 0">
                <xsl:value-of select="authority[1]/name/namePart[@type = 'given']"/>
            </xsl:if>
            <xsl:if test="string-length(authority[1]/name/namePart[@type = 'numeration']) &gt; 0">
                <xsl:text> </xsl:text>
                <xsl:value-of select="authority[1]/name/namePart[@type = 'numeration']"/>
            </xsl:if>
            <xsl:if test="string-length(authority[1]/name/namePart[@type = 'termsOfAddress']) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="authority[1]/name/namePart[@type = 'termsOfAddress']"/>
            </xsl:if>
            <xsl:if test="string-length(personInfo/displayDate) &gt; 0 or string-length(personInfo/birthDate/date/year) &gt; 0 or string-length(personInfo/deathDate/date/year) &gt; 0">
                <xsl:text>, </xsl:text>
                <xsl:choose>
                    <xsl:when test="string-length(personInfo/displayDate) &gt; 0">
                        <xsl:value-of select="personInfo/displayDate"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string-length(personInfo/birthDate/date/year) &gt; 0">
                            <xsl:value-of select="personInfo/birthDate/date/year"/>
                        </xsl:if>
                        <xsl:text>-</xsl:text>
                        <xsl:if test="string-length(personInfo/deathDate/date/year) &gt; 0">
                            <xsl:value-of select="personInfo/deathDate/date/year"/>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="organisation">
        <xsl:for-each select="organisation/linkedRecord/organisation">
            <xsl:if test="string-length(authority[1]/name/namePart[@type = 'corporateName']) &gt; 0">
                <xsl:value-of select="authority[1]/name/namePart[@type = 'corporateName']"/>
                <xsl:if test="string-length(authority[1]/name/namePart[@type = 'subordinate']) &gt; 0">
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="authority[1]/name/namePart[@type = 'subordinate']"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
