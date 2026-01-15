<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:alvin="https://www.alvin-portal.org/vocabulary">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data"/>
    </xsl:template>
    <xsl:template match="data">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:alvin="https://www.alvin-portal.org/vocabulary">
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:text>https://www.alvin-portal.org/</xsl:text>
                    <xsl:value-of select="*/recordInfo/type/linkedRecordId"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="*/recordInfo/id"/>
                </xsl:attribute>
                <xsl:apply-templates select="person"/>
            </rdf:Description>          
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="person">
        <rdfs:label>
            <xsl:call-template name="personlabel"></xsl:call-template>
        </rdfs:label>
        <alvin:person>
            <xsl:apply-templates select="authority"/>
            <xsl:apply-templates select="variant"/>
        </alvin:person>
    </xsl:template>
    <xsl:template match="authority">
        <alvin:authority xml:lang="sv"> 
            <xsl:call-template name="personname"></xsl:call-template>
        </alvin:authority>        
    </xsl:template>
    <xsl:template match="variant">
        <alvin:variant rdf:parseType="Collection">
            <xsl:call-template name="personname"></xsl:call-template>
        </alvin:variant>        
    </xsl:template>
    <xsl:template name="personlabel">
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
    </xsl:template>
    <xsl:template name="personname">
        <rdf:Description rdf:about="alvin:Coffee1">
        <xsl:for-each select="name/namePart[@type = 'family']">
            <alvin:familyName>
                <xsl:value-of select="."/>
            </alvin:familyName>
        </xsl:for-each>
        <xsl:for-each select="name/namePart[@type = 'given']">
            <alvin:givenName>
                <xsl:value-of select="."/>
            </alvin:givenName>
        </xsl:for-each>     
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>
