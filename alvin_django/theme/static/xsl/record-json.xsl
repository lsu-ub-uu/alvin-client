<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="host">
        <xsl:value-of select="$domain_root"/>
        <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/record | dataList/data/record/data/record | record/data/work | dataList/data/record/data/work | record/data/place | dataList/data/record/data/place | record/data/person | dataList/data/record/data/person | record/data/organisation | dataList/data/record/data/organisation | record/data/location | dataList/data/record/data/location"/>
    </xsl:template>
    <xsl:template match="record">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="record_type"/>
        <xsl:call-template name="title"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="work">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="type_type"/>
        <xsl:call-template name="title"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="place"> 
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="place_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="person"> 
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="person_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="organisation">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="group_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="location"> 
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="group_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>}</xsl:text>   
    </xsl:template>
    <xsl:template name="context">
        <xsl:text>"@context": "https://linked.art/ns/v1/linked-art.json",</xsl:text>
    </xsl:template>
    <xsl:template name="id">
        <xsl:text>"id": "</xsl:text>
        <xsl:value-of select="$host"/>
        <xsl:value-of select="recordInfo/type/linkedRecordId"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="recordInfo/id"/>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="record_type">
        <xsl:text>"type": "</xsl:text>
        <xsl:choose>
            <xsl:when test="collection = 'yes'">
                <xsl:text>Set</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>HumanMadeObject</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>",</xsl:text>
    </xsl:template>
    <xsl:template name="type_type">
        <xsl:text>"type": "Type",</xsl:text>
    </xsl:template>
    <xsl:template name="person_type">
        <xsl:text>"type": "Person",</xsl:text>
    </xsl:template>
    <xsl:template name="group_type">
        <xsl:text>"type": "Group",</xsl:text>
    </xsl:template>
    <xsl:template name="place_type">
        <xsl:text>"type": "Place",</xsl:text>
    </xsl:template>
    <xsl:template name="title">
        <xsl:for-each select="title">
            <xsl:text>"_label": "</xsl:text>
            <xsl:value-of select="mainTitle"/>
            <xsl:if test="string-length(subtitle) &gt; 0">
                <xsl:text> : </xsl:text>
                <xsl:value-of select="subtitle"/>
            </xsl:if>
            <xsl:text>"</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="authority">
        <xsl:for-each select="authority[1]">
            <xsl:text>"_label": "</xsl:text>
            <xsl:call-template name="labelPlace"/>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:text>"</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labelPlace">
        <xsl:for-each select="geographic">
            <xsl:value-of select="."/>
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
</xsl:stylesheet>
