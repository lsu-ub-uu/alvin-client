<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="host">
        <xsl:value-of select="substring-before($domain_root,'data')"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/record | dataList/data/record/data/record | record/data/work | dataList/data/record/data/work | record/data/place | dataList/data/record/data/place | record/data/person | dataList/data/record/data/person | record/data/organisation | dataList/data/record/data/organisation | record/data/location | dataList/data/record/data/location"/>
    </xsl:template>
    <xsl:template match="record">{<xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="record_type"/>
        <xsl:call-template name="labelTitle"/>
        <xsl:call-template name="typeOfResource"/>
        <xsl:call-template name="title"/>
        <xsl:call-template name="language"/>
        <xsl:call-template name="recordProvenance"/>}</xsl:template>
    <xsl:template match="work">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="linguisticObject_type"/>
        <xsl:call-template name="labelTitle"/>
        <xsl:call-template name="recordProvenance"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="place">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="place_type"/>
        <xsl:call-template name="authority"/>
        <xsl:call-template name="recordProvenance"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="person">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="person_type"/>
        <xsl:call-template name="authority"/>
        <xsl:call-template name="recordProvenance"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="organisation">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="group_type"/>
        <xsl:call-template name="authority"/>
        <xsl:call-template name="recordProvenance"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="location">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="group_type"/>
        <xsl:call-template name="authority"/>
        <xsl:call-template name="recordProvenance"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template name="context"> "@context": [ { "@version": 1.1, "raa": "https://kulturarvsdata.se/resurser/vocab/20/", "schema": "http://schema.org/", "dcterms": "http://purl.org/dc/terms/", "RecordProvenance": "raa:RecordProvenance", "SourceRecord": "raa:SourceRecord", "dateCreated": "schema:dateCreated", "dateModified": "schema:dateModified", "ingestedAt": "raa:ingestedAt", "license": "schema:license", "provider": "raa:provider", "record_provenance": "raa:record_provenance", "replaces": "dcterms:replaces", "sourceRecord": "raa:sourceRecord", "url": "schema:url" }, "https://linked.art/ns/v1/linked-art.json" ], </xsl:template>
    <xsl:template name="id"> "id": "<xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/>", </xsl:template>
    <xsl:template name="record_type">"type": "<xsl:choose>
            <xsl:when test="collection = 'yes'">
                <xsl:text>Set</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>HumanMadeObject</xsl:text>
            </xsl:otherwise>
        </xsl:choose>",</xsl:template>
    <xsl:template name="type_type">
        <xsl:text>"type": "Type",</xsl:text>
    </xsl:template>
    <xsl:template name="linguisticObject_type">
        <xsl:text>"type": "LinguisticObject",</xsl:text>
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
    <xsl:template name="labelTitle">
        <xsl:for-each select="title">
            <xsl:text>"_label": "</xsl:text>
            <xsl:value-of select="mainTitle"/>
            <xsl:if test="string-length(subtitle) &gt; 0">
                <xsl:text> : </xsl:text>
                <xsl:value-of select="subtitle"/>
            </xsl:if>
            <xsl:text>",</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="authority">
        <xsl:for-each select="authority[1]">
            <xsl:text>"_label": "</xsl:text>
            <xsl:call-template name="labelPlace"/>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:text>",</xsl:text>
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
    <xsl:template name="labels">
        <xsl:value-of select="@_value_en"/>
    </xsl:template>
    <xsl:template name="recordProvenance">
        "record_provenance": {
        "id": "<xsl:value-of select="$host"/>
        <xsl:for-each select="physicalLocation/heldBy/location">
            <xsl:value-of select="linkedRecordType"/>/<xsl:value-of select="linkedRecordId"/>
        </xsl:for-each>",
        "type": "RecordProvenance",
        "license": "http://creativecommons.org/publicdomain/zero/1.0/",
        "sourceRecord": {
          "type": "SourceRecord",
          "id": "<xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/>",
          "dateCreated": "<xsl:value-of select="substring(recordInfo/tsCreated,1,19)"/>Z",
          "dateModified": "<xsl:value-of select="substring(recordInfo/updated[last()]/tsUpdated,1,19)"/>Z",
          "url": "<xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/>"
        }
      }		
    </xsl:template>
    <xsl:template name="typeOfResource">
        "classified_as": [
        <xsl:for-each select="productionMethod"> 
            <xsl:choose>
                <xsl:when test=". = 'manuscript'">
                    { "id": "http://vocab.getty.edu/aat/300252927",
                    "type": "Type", 
                    "_label": "handwriting" },   
                </xsl:when>
                <xsl:when test=". = 'print'">
                    { "id": "http://vocab.getty.edu/aat/300053319",
                    "type": "Type", 
                    "_label": "printing (process)" },   
                </xsl:when>
            </xsl:choose>
            { "id": "<xsl:value-of select="$host"/>vocabulary/<xsl:value-of select="."/>ProductionItem",
            "type": "Type", 
            "_label": "<xsl:call-template name="labels"/>" },            
        </xsl:for-each>
        <xsl:for-each select="typeOfResource">
            <xsl:choose>
                <xsl:when test=". = 'col'">
                    { "id": "http://vocab.getty.edu/aat/300379505",
                    "type": "Type", 
                    "_label": "archival materials" },   
                </xsl:when>
                <xsl:when test=". = 'img'">
                    { "id": "http://vocab.getty.edu/aat/300264387",
                    "type": "Type", 
                    "_label": "images (object genre)" },   
                </xsl:when>
                <xsl:when test=". = 'mix'">
                    { "id": "http://vocab.getty.edu/aat/300404586",
                    "type": "Type", 
                    "_label": "mixed media works" },   
                </xsl:when>
                <xsl:when test=". = 'art'">
                    { "id": "http://vocab.getty.edu/aat/300117127",
                    "type": "Type", 
                    "_label": "artifacts (object genre)" },   
                </xsl:when>
                <xsl:when test=". = 'car'">
                    { "id": "http://vocab.getty.edu/aat/300028052",
                    "type": "Type", 
                    "_label": "cartographic materials" },   
                </xsl:when>
                <xsl:when test=". = 'aud'">
                    { "id": "http://vocab.getty.edu/aat/300028633",
                    "type": "Type", 
                    "_label": "sound recordings" },   
                </xsl:when>
                <xsl:when test=". = 'mul'">
                    { "id": "http://vocab.getty.edu/aat/300047910",
                    "type": "Type", 
                    "_label": "multimedia works" },   
                </xsl:when>
                <xsl:when test=". = 'not'">
                    { "id": "http://vocab.getty.edu/aat/300417622",
                    "type": "Type", 
                    "_label": "musical notation" },   
                </xsl:when>
                <xsl:when test=". = 'txt'">
                    { "id": "http://vocab.getty.edu/aat/300263751",
                    "type": "Type", 
                    "_label": "texts (documents)" },   
                </xsl:when>
                <xsl:when test=". = 'mov'">
                    { "id": "http://vocab.getty.edu/aat/300263857",
                    "type": "Type", 
                    "_label": "moving images" },   
                </xsl:when>
            </xsl:choose>                        
            { "id": "<xsl:value-of select="$host"/>vocabulary/<xsl:value-of select="."/>TypeItem",
                "type": "Type", 
                "_label": "<xsl:call-template name="labels"/>" }
        </xsl:for-each>
        ],
    </xsl:template>
    <xsl:template name="title">
        "identified_by": [
        <xsl:for-each select="variantTitle">
            <xsl:for-each select="subtitle">
                {
                "type": "Name",
                "classified_as": [
                {
                "id": "http://vocab.getty.edu/aat/300312006",
                "type": "Type",
                "_label": "Subtitle"
                }
                ],
                "content": "<xsl:value-of select="."/>"
                },                
            </xsl:for-each>
            
            {
            "type": "Name",
            "classified_as": [
            {
            "id": "http://vocab.getty.edu/aat/300404670",
            "type": "Type",
            "_label": "Primary Name"
            }
            ],
            "content": "<xsl:value-of select="mainTitle"/>"    
            },            
        </xsl:for-each>  
        <xsl:for-each select="title">
            <xsl:for-each select="subtitle">
            {
            "type": "Name",
            "classified_as": [
            {
            "id": "http://vocab.getty.edu/aat/300312006",
            "type": "Type",
            "_label": "Subtitle"
            }
            ],
            "content": "<xsl:value-of select="."/>"
            },                
            </xsl:for-each>

            {
            "type": "Name",
            "classified_as": [
            {
            "id": "http://vocab.getty.edu/aat/300404670",
            "type": "Type",
            "_label": "Primary Name"
            }
            ],
            "content": "<xsl:value-of select="mainTitle"/>"                
        </xsl:for-each>     
        }],
    </xsl:template>

    <xsl:template name="language">
        <xsl:choose>
            <xsl:when test="collection = 'yes'">
                "members_exemplified_by": [
                {
                "type": "LinguisticObject",
                "_label": "The text carried by the object",
                "language": [
                <xsl:call-template name="languageLink"/>
                ]
                }
                ],
            </xsl:when>
            <xsl:otherwise>
                "carries": [
                {
                "type": "LinguisticObject",
                "_label": "The text carried by the object",
                "language": [
                <xsl:call-template name="languageLink"/>             
                ]              
                }
                ],
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="languageLink">
        <xsl:for-each select="language">
            {
            "id": "<xsl:value-of select="$host"/>vocabulary/<xsl:value-of select="."/>MarcLanguageItem",
            "type": "Language",
            "_label": "<xsl:call-template name="labels"/>",
            "notation": "<xsl:value-of select="."/>"
            }
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
