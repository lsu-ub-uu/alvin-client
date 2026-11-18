<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:param name="ksamsok"/>
    <xsl:param name="raa_code"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="host">
        <xsl:choose>
            <xsl:when test="contains($domain_root,'data')">
                <xsl:value-of select="substring-before($domain_root,'data')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$domain_root"/>
                <xsl:text>/</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="dq">
        <xsl:text>"</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/record | dataList/data/record/data/record | record/data/work | dataList/data/record/data/work | record/data/place | dataList/data/record/data/place | record/data/person | dataList/data/record/data/person | record/data/organisation | dataList/data/record/data/organisation | record/data/location | dataList/data/record/data/location"/>
    </xsl:template>
    <xsl:template match="record">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="record_type"/>
        <xsl:call-template name="labelTitle"/>
        <xsl:call-template name="classified_as"/>
        <xsl:call-template name="current_owner"/>
        <xsl:call-template name="current_location"/>
        <xsl:call-template name="member_of"/>
        <xsl:call-template name="ProductionCreation"/>
        <xsl:if test="not(collection = 'yes')">
            <xsl:call-template name="made_of"/>
        </xsl:if>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="subject_of"/>
        <xsl:if test="not(collection = 'yes')">
            <xsl:call-template name="carries"/>
        </xsl:if>
        <xsl:call-template name="shows"/>
        <xsl:call-template name="identified_by"/>
        <xsl:if test="$ksamsok = 'yes'">
            <xsl:call-template name="record_provenance"/>
        </xsl:if>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="work">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="linguisticObject_type"/>
        <xsl:call-template name="labelTitle"/>
        <xsl:call-template name="classified_as"/>
        <xsl:call-template name="ProductionCreation"/>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="place">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="place_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>,</xsl:text>
        <xsl:call-template name="country"/>
        <xsl:call-template name="defined_by"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="person">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="person_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>,</xsl:text>
        <xsl:call-template name="born"/>
        <xsl:call-template name="died"/>
        <xsl:call-template name="classified_as_person"/>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="subject_of"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="organisation">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="group_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>,</xsl:text>
        <xsl:call-template name="formed_by"/>
        <xsl:call-template name="dissolved_by"/>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="contact_point"/>
        <xsl:call-template name="subject_of"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="location">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="group_type"/>
        <xsl:call-template name="authority"/>
        <xsl:text>,</xsl:text>
        <xsl:call-template name="formed_by"/>
        <xsl:call-template name="dissolved_by"/>
        <xsl:call-template name="classified_as_organisation"/>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="contact_point"/>
        <xsl:call-template name="subject_of"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="context">
        <xsl:choose>
            <xsl:when test="$ksamsok = 'yes'">
                <xsl:call-template name="context-ksamsok"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"@context": "https://linked.art/ns/v1/linked-art.json",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="context-ksamsok">
        <xsl:text>"@context": [ { "@version": 1.1, "raa": "https://kulturarvsdata.se/resurser/vocab/20/", "schema": "http://schema.org/", "dcterms": "http://purl.org/dc/terms/", "RecordProvenance": "raa:RecordProvenance", "SourceRecord": "raa:SourceRecord", "dateCreated": "schema:dateCreated", "dateModified": "schema:dateModified", "ingestedAt": "raa:ingestedAt", "license": "schema:license", "provider": "raa:provider", "record_provenance": "raa:record_provenance", "replaces": "dcterms:replaces", "sourceRecord": "raa:sourceRecord", "url": "schema:url" }, "https://linked.art/ns/v1/linked-art.json" ],</xsl:text>
    </xsl:template>
    <xsl:template name="id">
        <xsl:choose>
            <xsl:when test="$ksamsok = 'yes'">
                <xsl:text>"id": "https://kulturarvsdata.se/</xsl:text>
                <xsl:value-of select="$raa_code"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="recordInfo/type/linkedRecordId"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="recordInfo/id"/>
                <xsl:text>",</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>"id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/><xsl:text>",</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="linkedid"><xsl:text>"id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="linkedRecordType"/>/<xsl:value-of select="linkedRecordId"/><xsl:text>",</xsl:text></xsl:template>
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
            <xsl:value-of select="normalize-space(translate(mainTitle, $dq, ''))"/>
            <xsl:if test="string-length(subtitle) &gt; 0">
                <xsl:text> : </xsl:text>
                <xsl:value-of select="normalize-space(translate(subtitle, $dq, ''))"/>
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
            <xsl:text>"</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="labelPlace">
        <xsl:for-each select="geographic">
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
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
    <xsl:template name="current_owner">
        <xsl:if test="not(collection = 'yes')">
            <xsl:for-each select="physicalLocation/heldBy/location">
                <xsl:text>"current_owner": [{ "id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="linkedRecordType"/>/<xsl:value-of select="linkedRecordId"/><xsl:text>", "type": "Group","_label": "</xsl:text>
                <xsl:value-of select="linkedRecord/location/authority[1]/name"/><xsl:text>"}],</xsl:text>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="current_location">
        <xsl:if test="not(collection = 'yes')">
            <xsl:for-each select="physicalLocation">
                <xsl:text>"current_location": { "id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="heldBy/location/linkedRecordType"/>/<xsl:value-of select="heldBy/location/linkedRecordId"/><xsl:text>","type": "Place",</xsl:text>
                <xsl:choose>
                    <xsl:when test="string-length(sublocation) &gt; 0"><xsl:text>"_label": "</xsl:text><xsl:value-of select="sublocation"/><xsl:text>"</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>"_label": "</xsl:text><xsl:value-of select="heldBy/location/linkedRecord/location/authority[1]/name"/><xsl:text>"</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text>},</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="record_provenance">
        <xsl:text>, "record_provenance": {"id": "https://kulturarvsdata.se/</xsl:text>
        <xsl:value-of select="$raa_code"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="recordInfo/type/linkedRecordId"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="recordInfo/id"/>
        <xsl:text>/prov",</xsl:text>
        <xsl:text>"type": "RecordProvenance", "license": "http://creativecommons.org/publicdomain/zero/1.0/",</xsl:text> 
        <xsl:text>"sourceRecord": { "type": "SourceRecord", "id": "</xsl:text>
        <xsl:value-of select="$host"/>
        <xsl:value-of select="recordInfo/type/linkedRecordId"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="recordInfo/id"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"dateCreated": "</xsl:text>
        <xsl:value-of select="substring(recordInfo/tsCreated,1,19)"/>
        <xsl:text>Z",</xsl:text>
        <xsl:text>"dateModified": "</xsl:text>
        <xsl:value-of select="substring(recordInfo/updated[last()]/tsUpdated,1,19)"/>
        <xsl:text>Z", "url": "</xsl:text>
        <xsl:value-of select="$host"/>
        <xsl:value-of select="recordInfo/type/linkedRecordId"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="recordInfo/id"/>
        <xsl:text>" } }</xsl:text>
    </xsl:template>
    <xsl:template name="classified_as">
        <xsl:text>"classified_as": [ </xsl:text>
        <xsl:for-each select="productionMethod">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>ProductionItem", "type": "Type", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>" },</xsl:text>
            <xsl:choose>
                <xsl:when test=". = 'manuscript'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300252927", "type": "Type", "_label": "Handwriting" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'print'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300053319", "type": "Type", "_label": "Printing (process)" }</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:text>, </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="genre">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>Item", "type": "Type", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300455840", "type": "Type", "_label": "Genre" } ]</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="typeOfResource">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>TypeItem", "type": "Type", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>" },</xsl:text>
            <xsl:choose>
                <xsl:when test=". = 'col'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300379505", "type": "Type", "_label": "Archival materials" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'img'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300264387", "type": "Type", "_label": "Images (object genre)" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'mix'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300404586", "type": "Type", "_label": "Mixed media works" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'art'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300117127", "type": "Type", "_label": "Artifacts (object genre)" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'car'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300028052", "type": "Type", "_label": "Cartographic materials" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'aud'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300028633", "type": "Type", "_label": "Sound recordings" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'mul'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300047910", "type": "Type", "_label": "Multimedia works" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'not'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300417622", "type": "Type", "_label": "Musical notation" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'txt'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300263751", "type": "Type", "_label": "Texts (documents)" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'mov'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300263857", "type": "Type", "_label": "Moving images" }</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="formOfWork">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>FormOfWorkItem", "type": "Type", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>" },</xsl:text>
            <xsl:choose>
                <xsl:when test=". = 'music'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300054146", "type": "Type", "_label": "Music (performing arts genre)" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'cartography'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300053163", "type": "Type", "_label": "Cartography" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'text'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300263751", "type": "Type", "_label": "Texts (documents)" }</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
    </xsl:template>
    <xsl:template name="title">
        <xsl:for-each select="title">
            <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404670", "type": "Type", "_label": "Primary Name" },</xsl:text>
            <xsl:text>{ "id": "http://vocab.getty.edu/aat/300417193", "type": "Type", "_label": "Title (general, names)" } ], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(mainTitle, $dq, ''))"/>
            <xsl:text>"  },</xsl:text>
            <xsl:for-each select="subtitle">
                <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300312006", "type": "Type", "_label": "Subtitle" } ], "content": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>" },</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="variantTitle">
            <xsl:choose>
                <xsl:when test="@variantType = 'abbreviated'">
                    <xsl:for-each select="mainTitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300417210", "type": "Type", "_label": "Abbreviated title" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="subtitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300312006", "type": "Type", "_label": "Abbreviated subtitle" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@variantType = 'translated'">
                    <xsl:for-each select="mainTitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300417194", "type": "Type", "_label": "Translated title" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="subtitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300312006", "type": "Type", "_label": "Translated subtitle" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@variantType = 'uniform'">
                    <xsl:for-each select="mainTitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300417197", "type": "Type", "_label": "Uniform title" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="subtitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300312006", "type": "Type", "_label": "Uniform subtitle" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="mainTitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300417227", "type": "Type", "_label": "Alternate title" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="subtitle">
                        <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300312006", "type": "Type", "_label": "Alternate subtitle" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" },</xsl:text>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="name">
        <xsl:for-each select="authority[1]">
            <xsl:text>{ "type": "Name", "content": "</xsl:text>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:call-template name="labelPlace"/>
            <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404670", "type": "Type", "_label": "Primary Name" } ], "language": [ </xsl:text>
            <xsl:call-template name="aatlanguage">
                <xsl:with-param name="lang" select="@lang"/>
            </xsl:call-template>
            <xsl:text> ] },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="authority[position() > 1]">
            <xsl:text>{ "type": "Name", "content": "</xsl:text>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:call-template name="labelPlace"/>
            <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404670", "type": "Type", "_label": "Primary Name" } ], "language": [ </xsl:text>
            <xsl:call-template name="aatlanguage">
                <xsl:with-param name="lang" select="@lang"/>
            </xsl:call-template>
            <xsl:text> ] },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="variant">
            <xsl:text>{ "type": "Name", "content": "</xsl:text>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:call-template name="labelPlace"/>
            <xsl:choose>
                <xsl:when test="@variantType = 'pseudonym' or @variantType = 'pseudonymAndSignature'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404657", "type": "Type", "_label": "Pseudonym" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'signature'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300028705", "type": "Type", "_label": "Signature" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'nickname'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404656", "type": "Type", "_label": "Nickname" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'maidenName'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404682", "type": "Type", "_label": "Maiden name" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'earlier'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435719", "type": "Type", "_label": "Former name" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'abbreviation'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300194407", "type": "Type", "_label": "Abbreviation" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'acronym'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404659", "type": "Type", "_label": "Acronym" } ]</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'expansion'">
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404688", "type": "Type", "_label": "Full name" } ]</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300458860", "type": "Type", "_label": "Alternate Name" } ]</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>, "language": [ </xsl:text>
            <xsl:call-template name="aatlanguage">
                <xsl:with-param name="lang" select="@lang"/>
            </xsl:call-template>
            <xsl:text> ] },</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="identified_by">
        <xsl:text>"identified_by": [</xsl:text>
        <xsl:call-template name="title"/>
        <xsl:call-template name="name"/>
        <xsl:for-each select="physicalLocation/shelfMark">
            <xsl:text>{"type": "Identifier","classified_as": [{"id": "http://vocab.getty.edu/aat/300404704", "type": "Type", "_label": "Shelf mark"}],"content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"},</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="physicalLocation/formerShelfMark">
            <xsl:text>{"type": "Identifier","classified_as": [{"id": "http://vocab.getty.edu/aat/300404704", "type": "Type", "_label": "Former shelf mark"}],"content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"},</xsl:text>
        </xsl:for-each>
        <xsl:call-template name="identifier"/>
        <xsl:for-each select="recordInfo">
            <xsl:for-each select="urn">
                <xsl:text>{"type": "Identifier","classified_as": [{"id": "http://vocab.getty.edu/aat/300417441", "type": "Type", "_label": "NBN"}],"content": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>"},</xsl:text>
            </xsl:for-each>
            <xsl:text>{"type": "Identifier","classified_as": [{"id": "http://vocab.getty.edu/aat/300435704", "type": "Type", "_label": "Alvin ID"}],"content": "</xsl:text>
            <xsl:value-of select="type/linkedRecordId"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="id"/>
            <xsl:text>"}</xsl:text>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template name="identifier">
        <xsl:for-each select="identifier">
            <xsl:text>{"type": "Identifier","classified_as": [{"id": "http://vocab.getty.edu/aat/</xsl:text>
            <xsl:choose>
                <xsl:when test="@type = 'accessionNumber'">
                    <xsl:text>300312355</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'hdl'">
                    <xsl:text>300417435</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'doi'">
                    <xsl:text>300417432</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'isbn'">
                    <xsl:text>300417443</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'issn'">
                    <xsl:text>300417430</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'ismn'">
                    <xsl:text>300417437</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>300404626</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>", "type": "Type", "_label": "</xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:text>"}],"content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"},</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="member_of">
        <xsl:for-each select="physicalLocation/subcollection">
            <xsl:text>"member_of": [</xsl:text>
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>Item", "type": "Set", "_label": "</xsl:text>
            <xsl:value-of select="*/@_value_en"/>
            <xsl:text>" } ],</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="ProductionCreation">
        <xsl:variable name="collection">
            <xsl:choose>
                <xsl:when test="collection = 'yes'">
                    <xsl:text>yes</xsl:text>
                </xsl:when>
                <xsl:when test="recordInfo/type/linkedRecordId = 'alvin-work'">
                    <xsl:text>yes</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>no</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="appliedMaterial or editionStatement or originDate or agent or originPlace">
            <xsl:choose>
                <xsl:when test="$collection = 'yes'">
                    <xsl:text>"created_by": { "type": "Creation"</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>"produced_by": { "type": "Production"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="appliedMaterial">
                <xsl:text>, "technique": [ </xsl:text>
                <xsl:for-each select="appliedMaterial">
                    <xsl:text>{ "id": "</xsl:text>
                    <xsl:value-of select="$host"/>
                    <xsl:text>vocabulary/</xsl:text>
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                    <xsl:text>Item</xsl:text>
                    <xsl:text>", "type": "Type", "_label": "</xsl:text>
                    <xsl:value-of select="@_value_en"/>
                    <xsl:text>" }</xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:if test="editionStatement or originDate/displayDate">
                <xsl:text>, "referred_to_by": [</xsl:text>
                <xsl:if test="editionStatement">
                    <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435435", "type": "Type", "_label": "Edition description" }  ], "content": "</xsl:text>
                    <xsl:value-of select="editionStatement"/>
                    <xsl:text>" }</xsl:text>
                    <xsl:if test="originDate/displayDate">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="originDate/displayDate">
                    <xsl:for-each select="originDate/displayDate">
                        <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435447", "type": "Type", "_label": "Creation date description" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" }</xsl:text>
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:if test="originDate">
                <xsl:for-each select="originDate">
                    <xsl:if test="startDate or endDate">
                        <xsl:text>, "timespan": { "type": "TimeSpan", "_label": "</xsl:text>
                        <xsl:for-each select="startDate/date">
                            <xsl:for-each select="year">
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:for-each select="month">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:for-each select="day">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:if test="era = 'bc'">
                                <xsl:text> BC</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="endDate/date">
                            <xsl:text>-</xsl:text>
                            <xsl:for-each select="year">
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:for-each select="month">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:for-each select="day">
                                <xsl:text>-</xsl:text>
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:if test="era = 'bc'">
                                <xsl:text> BC</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>", "begin_of_the_begin": "</xsl:text>
                        <xsl:choose>
                            <xsl:when test="startDate">
                                <xsl:for-each select="startDate/date">
                                    <xsl:if test="era = 'bc'">
                                        <xsl:text>-</xsl:text>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="year">
                                            <xsl:value-of select="year"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>0001</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="month">
                                            <xsl:value-of select="month"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>01</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="day">
                                            <xsl:value-of select="day"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>01</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="endDate/date">
                                    <xsl:if test="era = 'bc'">
                                        <xsl:text>-</xsl:text>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="year">
                                            <xsl:value-of select="year"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>0001</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="month">
                                            <xsl:value-of select="month"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>01</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="day">
                                            <xsl:value-of select="day"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>01</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>T00:00:00Z</xsl:text>
                        <xsl:text>", "end_of_the_end": "</xsl:text>
                        <xsl:choose>
                            <xsl:when test="endDate">
                                <xsl:for-each select="endDate/date">
                                    <xsl:if test="era = 'bc'">
                                        <xsl:text>-</xsl:text>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="year">
                                            <xsl:value-of select="year"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>0001</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="month">
                                            <xsl:value-of select="month"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>12</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="day">
                                            <xsl:value-of select="day"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="month = '02'">
                                                    <xsl:text>28</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="month = '04' or month = '06' or month = '09' or month = '11'">
                                                    <xsl:text>30</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>31</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="startDate/date">
                                    <xsl:if test="era = 'bc'">
                                        <xsl:text>-</xsl:text>
                                    </xsl:if>
                                    <xsl:choose>
                                        <xsl:when test="year">
                                            <xsl:value-of select="year"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>0001</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="month">
                                            <xsl:value-of select="month"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>12</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="day">
                                            <xsl:value-of select="day"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <xsl:when test="month = '02'">
                                                    <xsl:text>28</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="month = '04' or month = '06' or month = '09' or month = '11'">
                                                    <xsl:text>30</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>31</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>T23:59:59Z</xsl:text>
                        <xsl:text>" }</xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="agent">
                <xsl:text>, "part": [ </xsl:text>
                <xsl:for-each select="agent">
                    <xsl:choose>
                        <xsl:when test="$collection = 'yes'">
                            <xsl:text>{ "type": "Creation", "classified_as": [ </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>{ "type": "Production", "classified_as": [ </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="role">
                        <xsl:text>{ "id": "</xsl:text>
                        <xsl:value-of select="$host"/>
                        <xsl:text>vocabulary/</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>MarcRelatorItem</xsl:text>
                        <xsl:text>", "type": "Type", "_label": "</xsl:text>
                        <xsl:value-of select="@_value_en"/>
                        <xsl:text>"</xsl:text>
                        <xsl:text> }</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>], </xsl:text>
                    <xsl:text> "carried_out_by": [</xsl:text>
                    <xsl:text> { </xsl:text>
                    <xsl:for-each select="person | organisation">
                        <xsl:call-template name="linkedid"/>
                        <xsl:choose>
                            <xsl:when test="linkedRecordType = 'alvin-organisation'">
                                <xsl:call-template name="group_type"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="person_type"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:for-each select="linkedRecord/person | linkedRecord/organisation">
                            <xsl:for-each select="authority[1]">
                                <xsl:text>"_label": "</xsl:text>
                                <xsl:call-template name="labelPerson"/>
                                <xsl:call-template name="labelOrganisation"/>
                                <xsl:if test="../../../../certainty = 'uncertain'">
                                    <xsl:text> (uncertain)</xsl:text>
                                </xsl:if>
                                <xsl:text>"</xsl:text>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:text>} ] }</xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:if test="originPlace">
                <xsl:text>, "took_place_at": [ </xsl:text>
                <xsl:for-each select="originPlace">
                    <xsl:for-each select="place">
                        <xsl:text> { </xsl:text>
                        <xsl:call-template name="linkedid"/>
                        <xsl:text>"type": "Place", "_label": "</xsl:text>
                        <xsl:for-each select="linkedRecord/place">
                            <xsl:for-each select="authority[1]/geographic">
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:if test="../../../certainty = 'uncertain'">
                                <xsl:text> (uncertain)</xsl:text>
                            </xsl:if>
                            <xsl:text>"</xsl:text>
                        </xsl:for-each>
                        <xsl:text>} </xsl:text>
                    </xsl:for-each>
                    <xsl:if test="country">
                        <xsl:if test="place">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:for-each select="country">
                            <xsl:text> { </xsl:text>
                            <xsl:text>"id": "</xsl:text>
                            <xsl:value-of select="$host"/>
                            <xsl:text>vocabulary/</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            <xsl:text>MarcCountryItem</xsl:text>
                            <xsl:text>",</xsl:text>
                            <xsl:text>"type": "Place", "_label": "</xsl:text>
                            <xsl:value-of select="@_value_en"/>
                            <xsl:if test="../certainty = 'uncertain'">
                                <xsl:text> (uncertain)</xsl:text>
                            </xsl:if>
                            <xsl:text>" }</xsl:text>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="historicalCountry">
                        <xsl:if test="place or country">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:for-each select="historicalCountry">
                            <xsl:text> { </xsl:text>
                            <xsl:text>"id": "</xsl:text>
                            <xsl:value-of select="$host"/>
                            <xsl:text>vocabulary/</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            <xsl:text>HistoricalCountryItem</xsl:text>
                            <xsl:text>",</xsl:text>
                            <xsl:text>"type": "Place", "_label": "</xsl:text>
                            <xsl:value-of select="@_value_en"/>
                            <xsl:if test="../certainty = 'uncertain'">
                                <xsl:text> (uncertain)</xsl:text>
                            </xsl:if>
                            <xsl:text>" }</xsl:text>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>},</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="referred_to_by">
        <xsl:text>"referred_to_by": [</xsl:text>
        <xsl:for-each select="personInfo/displayDate">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300393178", "type": "Type", "_label": "Flourishing" } ], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="organisationInfo/displayDate">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300393178", "type": "Type", "_label": "Flourishing" } ], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="publication">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300202362", "type": "Type", "_label": "Imprint (publication statement)" } ], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="dateOther">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Date/time statement (</xsl:text>
            <xsl:value-of select="translate(@type,'_',' ')"/>
            <xsl:text>)" } ], "content": "</xsl:text>
            <xsl:for-each select="startDate/date">
                <xsl:for-each select="year">
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                </xsl:for-each>
                <xsl:for-each select="month">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                </xsl:for-each>
                <xsl:for-each select="day">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                </xsl:for-each>
                <xsl:if test="era = 'bc'">
                    <xsl:text> BC</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="endDate/date">
                <xsl:text>-</xsl:text>
                <xsl:for-each select="year">
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                </xsl:for-each>
                <xsl:for-each select="month">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                </xsl:for-each>
                <xsl:for-each select="day">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                </xsl:for-each>
                <xsl:if test="era = 'bc'">
                    <xsl:text> BC</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:if test="startDate or endDate">
                <xsl:for-each select="note">
                    <xsl:text>, "referred_to_by": [{  "type": "LinguisticObject", "classified_as": [{  "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Note" }],  "content": "</xsl:text>
                    <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                    <xsl:text>" }]</xsl:text>
                </xsl:for-each>
            </xsl:if>
            <xsl:text>},</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="extent">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300266036", "type": "Type", "_label": "Extent" } ], "content": "</xsl:text>
            <xsl:if test="@unit">
                <xsl:value-of select="@_en"/>
                <xsl:text>: </xsl:text>
            </xsl:if>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="locus">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300266036", "type": "Type", "_label": "Locus" } ], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="dimensions">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300266036", "type": "Type", "_label": "Dimensions" } ], "content": "</xsl:text>
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
            <xsl:text>" }, </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="measure">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300056240", "type": "Type", "_label": "Weight" } ], "content": "</xsl:text>
            <xsl:if test="string-length(weight) &gt; 0">
                <xsl:value-of select="weight"/>
            </xsl:if>
            <xsl:if test="string-length(unit) &gt; 0">
                <xsl:text> </xsl:text>
                <xsl:value-of select="unit/@_value_en"/>
            </xsl:if>
            <xsl:text>" }, </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="physicalDescription/note">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435452", "type": "Type", "_label": "Physical description (</xsl:text>
            <xsl:value-of select="@noteType"/>
            <xsl:text>)" } ], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" }, </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="subject">
            <xsl:variable name="sub">
                <xsl:for-each select="topic">
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="genreForm">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="geographicCoverage">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="temporal">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:for-each select="occupation">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300311841", "type": "Type", "_label": "Keyword" }</xsl:text>
            <xsl:for-each select="@authority">
                <xsl:if test="not(. = 'general')">
                    <xsl:text>, { "id": "http://vocab.getty.edu/aat/300265266", "type": "Type", "_label": "</xsl:text>
                    <xsl:value-of select="translate(.,'_',' ')"/>
                    <xsl:text>" } </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="organisation">
                <xsl:text>, { "id": "http://vocab.getty.edu/aat/300025948", "type": "Type", "_label": "</xsl:text>
                <xsl:text>Organization</xsl:text>
                <xsl:text>" } </xsl:text>
            </xsl:if>
            <xsl:if test="person">
                <xsl:text>, { "id": "http://vocab.getty.edu/aat/300024979", "type": "Type", "_label": "</xsl:text>
                <xsl:text>People</xsl:text>
                <xsl:text>" } </xsl:text>
            </xsl:if>
            <xsl:if test="place">
                <xsl:text>, { "id": "http://vocab.getty.edu/aat/300248475", "type": "Type", "_label": "</xsl:text>
                <xsl:text>Place</xsl:text>
                <xsl:text>" } </xsl:text>
            </xsl:if>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate($sub, $dq, ''))"/>
            <xsl:for-each select="person | organisation  | place">
                <xsl:for-each select="linkedRecord/person | linkedRecord/organisation | linkedRecord/place">
                    <xsl:for-each select="authority[1]">
                        <xsl:call-template name="labelPerson"/>
                        <xsl:call-template name="labelOrganisation"/>
                        <xsl:call-template name="labelPlace"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="classification">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435444", "type": "Type", "_label": "Classification" }</xsl:text>
            <xsl:for-each select="@authority">
                <xsl:if test="not(. = 'general')">
                    <xsl:text>, { "id": "http://vocab.getty.edu/aat/300265266", "type": "Type", "_label": "</xsl:text>
                    <xsl:value-of select="translate(.,'_',' ')"/>
                    <xsl:text>" } </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="summary">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300139067", "type": "Type", "_label": "Summary" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:if test="@lang">
                <xsl:text>, "language": [ </xsl:text>
                <xsl:call-template name="aatlanguage">
                    <xsl:with-param name="lang" select="@lang"/>
                </xsl:call-template>
                <xsl:text> ] </xsl:text>
            </xsl:if>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="transcription">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404333", "type": "Type", "_label": "Transcription" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="tableOfContents">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300195187", "type": "Type", "_label": "Table of contents" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="note">
            <xsl:if test="not(@noteType = 'internal')">
                <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Descriptive note (</xsl:text>
                <xsl:value-of select="@noteType"/>
                <xsl:text>)" }</xsl:text>
                <xsl:text>], "content": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>"</xsl:text>
                <xsl:text> },</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="language">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300389739", "type": "Type", "_label": "The language used to convey the content of the described materials" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="@_value_en"/>
            <xsl:text>"</xsl:text>
            <xsl:text>, "language": [ </xsl:text>
            <xsl:call-template name="aatlanguage">
                <xsl:with-param name="lang" select="."/>
            </xsl:call-template>
            <xsl:text>] },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="adminMetadata/descriptionLanguage">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435433", "type": "Type", "_label": "The language of the catalogue record" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="@_value_en"/>
            <xsl:text>"</xsl:text>
            <xsl:text>, "language": [ </xsl:text>
            <xsl:call-template name="aatlanguage">
                <xsl:with-param name="lang" select="."/>
            </xsl:call-template>
            <xsl:text>] },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="listBibl">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300311705", "type": "Type", "_label": "Citations (bibliographic references)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="accessPolicy">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300068844", "type": "Type", "_label": "Use" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="decoNote">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300056257", "type": "Type", "_label": "Decoration" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="bindingDesc">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300053592", "type": "Type", "_label": "Bookbinding" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="binding">
                <xsl:text>Binding: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:for-each select="decoNote">
                <xsl:if test="../binding">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:text>Decoration: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="cartographicAttributes">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300028052", "type": "Type", "_label": "Cartographic materials" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="scale">
                <xsl:text>Scale: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:for-each select="projection">
                <xsl:if test="../scale">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:text>Projection: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:for-each select="coordinates">
                <xsl:if test="../scale or ../projection">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:text>Coordinates: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="numericDesignationOfMusicalWork">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300417447", "type": "Type", "_label": "Identification numbers and codes" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="musicSerialNumber">
                <xsl:text>Serial number: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:for-each select="musicOpusNumber">
                <xsl:if test="../musicSerialNumber">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:text>Opus Number: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:for-each select="musicThematicNumber">
                <xsl:if test="../musicSerialNumber or ../usicOpusNumber">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:text>Thematic index number: </xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="weeding">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404112", "type": "Type", "_label": "Activity (weeding)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="arrangement">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300444118", "type": "Type", "_label": "Arrangement description" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="accruals">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300055458", "type": "Type", "_label": "Additions" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="incipit">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300055029", "type": "Type", "_label": "Incipit" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="explicit">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300201053", "type": "Type", "_label": "Explicit" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="rubric">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300196121", "type": "Type", "_label": "Rubric (beginning)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="finalRubric">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300196121", "type": "Type", "_label": "Rubric (end)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="musicKey">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Descriptive note (key (music))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="musicKeyOther">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Descriptive note (key (music))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="musicMedium">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Descriptive note (music medium)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="musicMediumOther">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Descriptive note (music medium)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="musicNotation">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300417622", "type": "Type", "_label": "Musical notation" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="axis">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Descriptive note (axis (coins (money))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="clock">
                <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="conservationState">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435425", "type": "Type", "_label": "Condition/examination (coins (money))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="countermark">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300189318", "type": "Type", "_label": "Countermark (coins (money))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="appraisal">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300411993", "type": "Type", "_label": "Currency/value (coins (money))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="value">
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:for-each select="currency">
                <xsl:if test="../value">
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="edge">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300190699", "type": "Type", "_label": "Edge (coins (money))" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="edgeDescription">
                <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:for-each select="legend">
                <xsl:text>, "referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300191074", "type": "Type", "_label": "Legend" } ], "content": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>" } ] </xsl:text>
            </xsl:for-each>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="obverse">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300078814", "type": "Type", "_label": "Obverse" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="description">
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:for-each select="legend">
                <xsl:text>, "referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300191074", "type": "Type", "_label": "Legend" } ], "content": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>" } ] </xsl:text>
            </xsl:for-each>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="reverse">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300078820", "type": "Type", "_label": "Reverse" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:for-each select="description">
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            </xsl:for-each>
            <xsl:text>"</xsl:text>
            <xsl:for-each select="legend">
                <xsl:text>, "referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300191074", "type": "Type", "_label": "Legend" } ], "content": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>" } ] </xsl:text>
            </xsl:for-each>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="otherfindaid">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300026539", "type": "Type", "_label": "Finding aids" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="relatedmaterial">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300444119", "type": "Type", "_label": "Related material" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="fieldOfEndeavor">
            <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435610", "type": "Type", "_label": "Job (occupation)" }</xsl:text>
            <xsl:text>], "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="fileSection">
            <xsl:for-each select="rights">
                <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435434", "type": "Type", "_label": "Copyright/licensing statement" } ], "content": "</xsl:text>
                <xsl:text>License for the digital surrogate: </xsl:text>
                <xsl:value-of select="@_value_en"/>
                <xsl:text>" },</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:text>{ "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435434", "type": "Type", "_label": "Copyright/licensing statement" } ],</xsl:text>
        <xsl:text>"content": "This metadata record is licensed under CC0 (Creative Commons Zero)" } </xsl:text>
        <xsl:text>],</xsl:text>
    </xsl:template>
    <xsl:template name="made_of">
        <xsl:if test="baseMaterial">
            <xsl:text>"made_of": [</xsl:text>
            <xsl:for-each select="baseMaterial">
                <xsl:text>{ "id": "</xsl:text>
                <xsl:value-of select="$host"/>
                <xsl:text>vocabulary/</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>Item</xsl:text>
                <xsl:text>", "type": "Material", "_label": "</xsl:text>
                <xsl:value-of select="@_value_en"/>
                <xsl:text>" }</xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="subject_of">
        <xsl:if test="electronicLocator or relatedTo or related">
            <xsl:text>"subject_of": [</xsl:text>
            <xsl:for-each select="electronicLocator | relatedTo | related">
                <xsl:text>{ "type": "LinguisticObject", "_label": "Related web pages", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300266024", "type": "Type", "_label": "Links" } ], "digitally_carried_by": [</xsl:text>
                <xsl:text>{ "type": "DigitalObject", "_label": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(displayLabel, $dq, ''))"/>
                <xsl:for-each select="person/linkedRecord/person/authority[1]">
                    <xsl:call-template name="labelPerson"/>
                </xsl:for-each>
                <xsl:for-each select="organisation/linkedRecord/organisation/authority[1]">
                    <xsl:call-template name="labelOrganisation"/>
                </xsl:for-each>
                <xsl:for-each select="record/linkedRecord">
                    <xsl:for-each select="record">
                        <xsl:value-of select="normalize-space(translate(title/mainTitle, $dq, ''))"/>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300264578", "type": "Type", "_label": "Web pages"</xsl:text>
                <xsl:for-each select="record | person | organisation">
                    <xsl:variable name="url">
                        <xsl:text> } ], "access_point": [ { "id": "</xsl:text>
                        <xsl:value-of select="$host"/>
                        <xsl:value-of select="linkedRecordType"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="linkedRecordId"/>
                    </xsl:variable>
                    <xsl:value-of select="$url"/>
                </xsl:for-each>
                <xsl:if test="url">
                    <xsl:text> } ], "access_point": [ { "id": "</xsl:text>
                    <xsl:value-of select="url"/>
                </xsl:if>
                <xsl:text>", "type": "DigitalObject" } ] } ] }</xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text> ],</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="carries">
        <xsl:if test="work">
            <xsl:text>"carries": [</xsl:text>
            <xsl:for-each select="work">
                <xsl:variable name="url">
                    <xsl:value-of select="$host"/>
                    <xsl:value-of select="linkedRecordType"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="linkedRecordId"/>
                </xsl:variable>
                <xsl:text> { "id": "</xsl:text>
                <xsl:value-of select="$url"/>
                <xsl:text>", "type": "LinguisticObject", "_label": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(linkedRecord/work/title/mainTitle, $dq, ''))"/>
                <xsl:text>" }</xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>], </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="born">
        <xsl:for-each select="personInfo">
            <xsl:if test="birthDate or birthPlace">
                <xsl:text>"born": { "type": "Birth", </xsl:text>
                <xsl:for-each select="birthDate">
                    <xsl:text>"timespan": { "type": "TimeSpan", "_label": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:for-each select="year">
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="month">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="day">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:if test="era = 'bc'">
                            <xsl:text> BC</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>", "begin_of_the_begin": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T00:00:00Z</xsl:text>
                    <xsl:text>", "end_of_the_end": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>12</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="month = '02'">
                                        <xsl:text>28</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="month = '04' or month = '06' or month = '09' or month = '11'">
                                        <xsl:text>30</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>31</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T23:59:59Z</xsl:text>
                    <xsl:text>" }</xsl:text>
                    <xsl:if test="../birthPlace">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="birthPlace">
                    <xsl:text>"took_place_at": [ {</xsl:text>
                    <xsl:for-each select="place">
                        <xsl:call-template name="linkedid"/>
                        <xsl:text>"type": "Place", "_label": "</xsl:text>
                        <xsl:for-each select="linkedRecord/place">
                            <xsl:for-each select="authority[1]/geographic">
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:if test="../../../certainty = 'uncertain'">
                                <xsl:text> (uncertain)</xsl:text>
                            </xsl:if>
                            <xsl:text>"</xsl:text>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:text>}]</xsl:text>
                </xsl:for-each>
                <xsl:text>},</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="died">
        <xsl:for-each select="personInfo">
            <xsl:if test="deathDate or deathPlace">
                <xsl:text>"died": { "type": "Death", </xsl:text>
                <xsl:for-each select="deathDate">
                    <xsl:text>"timespan": { "type": "TimeSpan", "_label": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:for-each select="year">
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="month">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="day">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:if test="era = 'bc'">
                            <xsl:text> BC</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>", "begin_of_the_begin": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T00:00:00Z</xsl:text>
                    <xsl:text>", "end_of_the_end": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>12</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="month = '02'">
                                        <xsl:text>28</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="month = '04' or month = '06' or month = '09' or month = '11'">
                                        <xsl:text>30</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>31</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T23:59:59Z</xsl:text>
                    <xsl:text>" }</xsl:text>
                    <xsl:if test="../deathPlace">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="deathPlace">
                    <xsl:text>"took_place_at": [ {</xsl:text>
                    <xsl:for-each select="place">
                        <xsl:call-template name="linkedid"/>
                        <xsl:text>"type": "Place", "_label": "</xsl:text>
                        <xsl:for-each select="linkedRecord/place">
                            <xsl:for-each select="authority[1]/geographic">
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            </xsl:for-each>
                            <xsl:if test="../../../certainty = 'uncertain'">
                                <xsl:text> (uncertain)</xsl:text>
                            </xsl:if>
                            <xsl:text>"</xsl:text>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:text>}]</xsl:text>
                </xsl:for-each>
                <xsl:text>},</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="formed_by">
        <xsl:for-each select="organisationInfo">
            <xsl:if test="startDate">
                <xsl:text>"formed_by": { "type": "Formation", </xsl:text>
                <xsl:for-each select="startDate">
                    <xsl:text>"timespan": { "type": "TimeSpan", "_label": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:for-each select="year">
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="month">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="day">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:if test="era = 'bc'">
                            <xsl:text> BC</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>", "begin_of_the_begin": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T00:00:00Z</xsl:text>
                    <xsl:text>", "end_of_the_end": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>12</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="month = '02'">
                                        <xsl:text>28</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="month = '04' or month = '06' or month = '09' or month = '11'">
                                        <xsl:text>30</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>31</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T23:59:59Z</xsl:text>
                    <xsl:text>" }</xsl:text>
                </xsl:for-each>
                <xsl:text>},</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="dissolved_by">
        <xsl:for-each select="organisationInfo">
            <xsl:if test="endDate">
                <xsl:text>"dissolved_by": { "type": "Dissolution", </xsl:text>
                <xsl:for-each select="endDate">
                    <xsl:text>"timespan": { "type": "TimeSpan", "_label": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:for-each select="year">
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="month">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:for-each select="day">
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        </xsl:for-each>
                        <xsl:if test="era = 'bc'">
                            <xsl:text> BC</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>", "begin_of_the_begin": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>01</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T00:00:00Z</xsl:text>
                    <xsl:text>", "end_of_the_end": "</xsl:text>
                    <xsl:for-each select="date">
                        <xsl:if test="era = 'bc'">
                            <xsl:text>-</xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="year">
                                <xsl:value-of select="year"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0001</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="month">
                                <xsl:value-of select="month"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>12</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>-</xsl:text>
                        <xsl:choose>
                            <xsl:when test="day">
                                <xsl:value-of select="day"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="month = '02'">
                                        <xsl:text>28</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="month = '04' or month = '06' or month = '09' or month = '11'">
                                        <xsl:text>30</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>31</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>T23:59:59Z</xsl:text>
                    <xsl:text>" }</xsl:text>
                </xsl:for-each>
                <xsl:text>},</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="classified_as_person">
        <xsl:if test="personInfo/nationality or personInfo/gender">
            <xsl:text>"classified_as": [ </xsl:text>
            <xsl:for-each select="personInfo">
                <xsl:if test="nationality">
                    <xsl:for-each select="nationality">
                        <xsl:for-each select="country">
                            <xsl:text>{ "id": "</xsl:text>
                            <xsl:value-of select="$host"/>
                            <xsl:text>vocabulary/</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            <xsl:text>MarcCountryItem</xsl:text>
                            <xsl:text>",</xsl:text>
                            <xsl:text>"type": "Type", "_label": "</xsl:text>
                            <xsl:value-of select="@_value_en"/>
                            <xsl:text>", "classified_as": [{ "id": "http://vocab.getty.edu/page/aat/300379842", "type": "Type", "_label": "Nationality" }] }</xsl:text>
                        </xsl:for-each>
                        <xsl:if test="position() != last() or ..//gender">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="gender">
                    <xsl:for-each select="gender">
                        <xsl:text>{ "id": "</xsl:text>
                        <xsl:value-of select="$host"/>
                        <xsl:text>vocabulary/</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., '-', ''))"/>
                        <xsl:text>Item", "type": "Type", "_label": "</xsl:text>
                        <xsl:value-of select="@_value_en"/>
                        <xsl:text>", "classified_as": [{ "id": "http://vocab.getty.edu/aat/300411835", "type": "Type", "_label": "Gender (sociological concept)" } ] }</xsl:text>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="classified_as_organisation">
        <xsl:if test="organisationInfo/descriptor">
            <xsl:text>"classified_as": [ </xsl:text>
            <xsl:for-each select="organisationInfo">
                <xsl:if test="descriptor">
                    <xsl:for-each select="descriptor">
                        <xsl:text>{ "id": "</xsl:text>
                        <xsl:value-of select="$host"/>
                        <xsl:text>vocabulary/</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., '-', ''))"/>
                        <xsl:text>Item", "type": "Type", "_label": "</xsl:text>
                        <xsl:value-of select="@_value_en"/>
                        <xsl:text>", "classified_as": [{ "id": "http://vocab.getty.edu/aat/300263077", "type": "Type", "_label": "Member" } ] }</xsl:text>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="country">
        <xsl:if test="country">
            <xsl:text>"part_of": [ </xsl:text>
            <xsl:for-each select="country">
                <xsl:text>{ "id": "</xsl:text>
                <xsl:value-of select="$host"/>
                <xsl:text>vocabulary/</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>MarcCountryItem</xsl:text>
                <xsl:text>",</xsl:text>
                <xsl:text>"type": "Place", "_label": "</xsl:text>
                <xsl:value-of select="@_value_en"/>
                <xsl:text>" } ],</xsl:text>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="defined_by">
        <xsl:for-each select="point">
            <xsl:text>"defined_by": "POINT(</xsl:text>
            <xsl:value-of select="longitude"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="latitude"/>
            <xsl:text>)",</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="contact_point">
        <xsl:if test="address or email">
            <xsl:text>"contact_point": [</xsl:text>
            <xsl:if test="email">
                <xsl:text>{ "type": "Identifier", "_label": "Email", "content": "</xsl:text>
                <xsl:value-of select="email"/>
                <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435686", "type": "Type", "_label": "Email address" } ] } </xsl:text>
                <xsl:if test="address">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="address">
                <xsl:text> { "type": "Identifier", "_label": "Address", "content": "</xsl:text>
                <xsl:for-each select="address">
                    <xsl:for-each select="postOfficeBox">
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="street">
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="postcode">
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="place">
                        <xsl:value-of select="normalize-space(translate(linkedRecord/place/authority[1]/geographic, $dq, ''))"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="country">
                        <xsl:value-of select="normalize-space(translate(@_value_en, $dq, ''))"/>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:text>", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435687", "type": "Type", "_label": "Mailing address" } ] }</xsl:text>
            </xsl:if>
            <xsl:text>],</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="shows">
        <xsl:if test="fileSection">
            <xsl:text>"shows": [ { "id": "</xsl:text>
            <xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/>
            <xsl:text>#VisualItem</xsl:text>
            <xsl:text>", "type": "VisualItem", "_label": "Digital surrogate"</xsl:text>
            <!--
            <xsl:for-each select="fileSection">
                <xsl:for-each select="rights"><xsl:text>"referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435434", "type": "Type", "_label": "Copyright/licensing statement" } ], "content": "</xsl:text>
                    <xsl:text>License for the digital surrogate: </xsl:text>
                    <xsl:value-of select="@_value_en"/>
                    <xsl:text>" } ],</xsl:text>
                </xsl:for-each>
            </xsl:for-each>               .
            -->
            <xsl:text> } ],</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="aatlanguage">
        <xsl:param name="lang"/>
        <xsl:choose>
            <xsl:when test="$lang = 'abk'">{ "id": "http://vocab.getty.edu/aat/300387766", "type": "Language", "_label": "Abkhaz" }</xsl:when>
            <xsl:when test="$lang = 'aar'">{ "id": "http://vocab.getty.edu/aat/300387779", "type": "Language", "_label": "Afar" }</xsl:when>
            <xsl:when test="$lang = 'afr'">{ "id": "http://vocab.getty.edu/aat/300387782", "type": "Language", "_label": "Afrikaans" }</xsl:when>
            <xsl:when test="$lang = 'aka'">{ "id": "http://vocab.getty.edu/aat/300387794", "type": "Language", "_label": "Akan" }</xsl:when>
            <xsl:when test="$lang = 'alb'">{ "id": "http://vocab.getty.edu/aat/300387803", "type": "Language", "_label": "Albanian" }</xsl:when>
            <xsl:when test="$lang = 'amh'">{ "id": "http://vocab.getty.edu/aat/300387824", "type": "Language", "_label": "Amharic" }</xsl:when>
            <xsl:when test="$lang = 'grc'">{ "id": "http://vocab.getty.edu/aat/300387827", "type": "Language", "_label": "Ancient Greek" }</xsl:when>
            <xsl:when test="$lang = 'ara'">{ "id": "http://vocab.getty.edu/aat/300387843", "type": "Language", "_label": "Arabic" }</xsl:when>
            <xsl:when test="$lang = 'arg'">{ "id": "http://vocab.getty.edu/aat/300387855", "type": "Language", "_label": "Aragonese" }</xsl:when>
            <xsl:when test="$lang = 'arm'">{ "id": "http://vocab.getty.edu/aat/300387870", "type": "Language", "_label": "Armenian" }</xsl:when>
            <xsl:when test="$lang = 'asm'">{ "id": "http://vocab.getty.edu/aat/300387878", "type": "Language", "_label": "Assamese" }</xsl:when>
            <xsl:when test="$lang = 'ava'">{ "id": "http://vocab.getty.edu/aat/300387895", "type": "Language", "_label": "Avaric" }</xsl:when>
            <xsl:when test="$lang = 'ave'">{ "id": "http://vocab.getty.edu/aat/300443616", "type": "Language", "_label": "Avestan" }</xsl:when>
            <xsl:when test="$lang = 'aym'">{ "id": "http://vocab.getty.edu/aat/300387901", "type": "Language", "_label": "Aymara" }</xsl:when>
            <xsl:when test="$lang = 'aze'">{ "id": "http://vocab.getty.edu/aat/300387903", "type": "Language", "_label": "Azerbaijani" }</xsl:when>
            <xsl:when test="$lang = 'bam'">{ "id": "http://vocab.getty.edu/aat/300387937", "type": "Language", "_label": "Bambara" }</xsl:when>
            <xsl:when test="$lang = 'bak'">{ "id": "http://vocab.getty.edu/aat/300387954", "type": "Language", "_label": "Bashkir" }</xsl:when>
            <xsl:when test="$lang = 'baq'">{ "id": "http://vocab.getty.edu/aat/300387955", "type": "Language", "_label": "Basque" }</xsl:when>
            <xsl:when test="$lang = 'bel'">{ "id": "http://vocab.getty.edu/aat/300387967", "type": "Language", "_label": "Belarusian" }</xsl:when>
            <xsl:when test="$lang = 'bih'">{ "id": "http://vocab.getty.edu/aat/300443807", "type": "Language", "_label": "Bihari" }</xsl:when>
            <xsl:when test="$lang = 'bis'">{ "id": "http://vocab.getty.edu/aat/300387999", "type": "Language", "_label": "Bislama" }</xsl:when>
            <xsl:when test="$lang = 'bos'">{ "id": "http://vocab.getty.edu/aat/300388023", "type": "Language", "_label": "Bosnian" }</xsl:when>
            <xsl:when test="$lang = 'bre'">{ "id": "http://vocab.getty.edu/aat/300388025", "type": "Language", "_label": "Breton" }</xsl:when>
            <xsl:when test="$lang = 'bul'">{ "id": "http://vocab.getty.edu/aat/300388034", "type": "Language", "_label": "Bulgarian" }</xsl:when>
            <xsl:when test="$lang = 'bur'">{ "id": "http://vocab.getty.edu/aat/300388042", "type": "Language", "_label": "Burmese" }</xsl:when>
            <xsl:when test="$lang = 'cat'">{ "id": "http://vocab.getty.edu/aat/300388072", "type": "Language", "_label": "Catalan; Valencian" }</xsl:when>
            <xsl:when test="$lang = 'cha'">{ "id": "http://vocab.getty.edu/aat/300388087", "type": "Language", "_label": "Chamorro" }</xsl:when>
            <xsl:when test="$lang = 'che'">{ "id": "http://vocab.getty.edu/aat/300388095", "type": "Language", "_label": "Chechen" }</xsl:when>
            <xsl:when test="$lang = 'nya'">{ "id": "http://vocab.getty.edu/aat/300391410", "type": "Language", "_label": "Chichewa; Chewa; Nyanja" }</xsl:when>
            <xsl:when test="$lang = 'chi'">{ "id": "http://vocab.getty.edu/aat/300388113", "type": "Language", "_label": "Chinese" }</xsl:when>
            <xsl:when test="$lang = 'chv'">{ "id": "http://vocab.getty.edu/aat/300388162", "type": "Language", "_label": "Chuvash" }</xsl:when>
            <xsl:when test="$lang = 'cor'">{ "id": "http://vocab.getty.edu/aat/300388179", "type": "Language", "_label": "Cornish" }</xsl:when>
            <xsl:when test="$lang = 'cos'">{ "id": "http://vocab.getty.edu/aat/300388180", "type": "Language", "_label": "Corsican" }</xsl:when>
            <xsl:when test="$lang = 'cre'">{ "id": "http://vocab.getty.edu/aat/300388182", "type": "Language", "_label": "Cree" }</xsl:when>
            <xsl:when test="$lang = 'hrv'">{ "id": "http://vocab.getty.edu/aat/300388185", "type": "Language", "_label": "Croatian" }</xsl:when>
            <xsl:when test="$lang = 'cze'">{ "id": "http://vocab.getty.edu/aat/300388191", "type": "Language", "_label": "Czech" }</xsl:when>
            <xsl:when test="$lang = 'dan'">{ "id": "http://vocab.getty.edu/aat/300388204", "type": "Language", "_label": "Danish" }</xsl:when>
            <xsl:when test="$lang = 'div'">{ "id": "http://vocab.getty.edu/aat/300388791", "type": "Language", "_label": "Divehi" }</xsl:when>
            <xsl:when test="$lang = 'dut'">{ "id": "http://vocab.getty.edu/aat/300388256", "type": "Language", "_label": "Dutch" }</xsl:when>
            <xsl:when test="$lang = 'dzo'">{ "id": "http://vocab.getty.edu/aat/300388260", "type": "Language", "_label": "Dzongkha" }</xsl:when>
            <xsl:when test="$lang = 'eng'">{ "id": "http://vocab.getty.edu/aat/300388277", "type": "Language", "_label": "English" }</xsl:when>
            <xsl:when test="$lang = 'epo'">{ "id": "http://vocab.getty.edu/aat/300388282", "type": "Language", "_label": "Esperanto" }</xsl:when>
            <xsl:when test="$lang = 'est'">{ "id": "http://vocab.getty.edu/aat/300388283", "type": "Language", "_label": "Estonian" }</xsl:when>
            <xsl:when test="$lang = 'ewe'">{ "id": "http://vocab.getty.edu/aat/300388287", "type": "Language", "_label": "Ewe" }</xsl:when>
            <xsl:when test="$lang = 'fao'">{ "id": "http://vocab.getty.edu/aat/300388293", "type": "Language", "_label": "Faroese" }</xsl:when>
            <xsl:when test="$lang = 'fij'">{ "id": "http://vocab.getty.edu/aat/300388298", "type": "Language", "_label": "Fijian" }</xsl:when>
            <xsl:when test="$lang = 'fin'">{ "id": "http://vocab.getty.edu/aat/300388299", "type": "Language", "_label": "Finnish" }</xsl:when>
            <xsl:when test="$lang = 'fre'">{ "id": "http://vocab.getty.edu/aat/300388306", "type": "Language", "_label": "French" }</xsl:when>
            <xsl:when test="$lang = 'ful'">{ "id": "http://vocab.getty.edu/aat/300388310", "type": "Language", "_label": "Fula" }</xsl:when>
            <xsl:when test="$lang = 'glg'">{ "id": "http://vocab.getty.edu/aat/300388327", "type": "Language", "_label": "Galician" }</xsl:when>
            <xsl:when test="$lang = 'lug'">{ "id": "http://vocab.getty.edu/aat/300388333", "type": "Language", "_label": "Ganda" }</xsl:when>
            <xsl:when test="$lang = 'geo'">{ "id": "http://vocab.getty.edu/aat/300388343", "type": "Language", "_label": "Georgian" }</xsl:when>
            <xsl:when test="$lang = 'ger'">{ "id": "http://vocab.getty.edu/aat/300388344", "type": "Language", "_label": "German" }</xsl:when>
            <xsl:when test="$lang = 'gre'">{ "id": "http://vocab.getty.edu/aat/300388361", "type": "Language", "_label": "Greek, Modern" }</xsl:when>
            <xsl:when test="$lang = 'guj'">{ "id": "http://vocab.getty.edu/aat/300388369", "type": "Language", "_label": "Guaraní" }</xsl:when>
            <xsl:when test="$lang = 'guj'">{ "id": "http://vocab.getty.edu/aat/300388371", "type": "Language", "_label": "Gujarati" }</xsl:when>
            <xsl:when test="$lang = 'hat'">{ "id": "http://vocab.getty.edu/aat/300388389", "type": "Language", "_label": "Haitian; Haitian Creole" }</xsl:when>
            <xsl:when test="$lang = 'hau'">{ "id": "http://vocab.getty.edu/aat/300388399", "type": "Language", "_label": "Hausa" }</xsl:when>
            <xsl:when test="$lang = 'heb'">{ "id": "http://vocab.getty.edu/aat/300388401", "type": "Language", "_label": "Hebrew (modern)" }</xsl:when>
            <xsl:when test="$lang = 'her'">{ "id": "http://vocab.getty.edu/aat/300388407", "type": "Language", "_label": "Herero" }</xsl:when>
            <xsl:when test="$lang = 'hin'">{ "id": "http://vocab.getty.edu/aat/300388412", "type": "Language", "_label": "Hindi" }</xsl:when>
            <xsl:when test="$lang = 'hmo'">{ "id": "http://vocab.getty.edu/aat/300391423", "type": "Language", "_label": "Hiri Motu" }</xsl:when>
            <xsl:when test="$lang = 'hun'">{ "id": "http://vocab.getty.edu/aat/300388770", "type": "Language", "_label": "Hungarian" }</xsl:when>
            <xsl:when test="$lang = 'ice'">{ "id": "http://vocab.getty.edu/aat/300388449", "type": "Language", "_label": "Icelandic" }</xsl:when>
            <xsl:when test="$lang = 'ido'">{ "id": "http://vocab.getty.edu/aat/300443815", "type": "Language", "_label": "Ido" }</xsl:when>
            <xsl:when test="$lang = 'ibo'">{ "id": "http://vocab.getty.edu/aat/300388453", "type": "Language", "_label": "Igbo" }</xsl:when>
            <xsl:when test="$lang = 'ind'">{ "id": "http://vocab.getty.edu/aat/300388460", "type": "Language", "_label": "Indonesian" }</xsl:when>
            <xsl:when test="$lang = 'ile'">{ "id": "http://vocab.getty.edu/aat/300443817", "type": "Language", "_label": "Interlingue, Occidental" }</xsl:when>
            <xsl:when test="$lang = 'iku'">{ "id": "http://vocab.getty.edu/aat/300443664", "type": "Language", "_label": "Inuktitut" }</xsl:when>
            <xsl:when test="$lang = 'ipk'">{ "id": "http://vocab.getty.edu/aat/300443818", "type": "Language", "_label": "Inupiaq" }</xsl:when>
            <xsl:when test="$lang = 'gle'">{ "id": "http://vocab.getty.edu/aat/300388467", "type": "Language", "_label": "Irish" }</xsl:when>
            <xsl:when test="$lang = 'ita'">{ "id": "http://vocab.getty.edu/aat/300388474", "type": "Language", "_label": "Italian" }</xsl:when>
            <xsl:when test="$lang = 'jpn'">{ "id": "http://vocab.getty.edu/aat/300388486", "type": "Language", "_label": "Japanese" }</xsl:when>
            <xsl:when test="$lang = 'jav'">{ "id": "http://vocab.getty.edu/aat/300388490", "type": "Language", "_label": "Javanese" }</xsl:when>
            <xsl:when test="$lang = 'kal'">{ "id": "http://vocab.getty.edu/aat/300388363", "type": "Language", "_label": "Kalaallisut, Greenlandic" }</xsl:when>
            <xsl:when test="$lang = 'kan'">{ "id": "http://vocab.getty.edu/aat/300388538", "type": "Language", "_label": "Kannada" }</xsl:when>
            <xsl:when test="$lang = 'kau'">{ "id": "http://vocab.getty.edu/aat/300388542", "type": "Language", "_label": "Kanuri" }</xsl:when>
            <xsl:when test="$lang = 'kas'">{ "id": "http://vocab.getty.edu/aat/300388558", "type": "Language", "_label": "Kashmiri" }</xsl:when>
            <xsl:when test="$lang = 'kaz'">{ "id": "http://vocab.getty.edu/aat/300388568", "type": "Language", "_label": "Kazakh" }</xsl:when>
            <xsl:when test="$lang = 'khm'">{ "id": "http://vocab.getty.edu/aat/300388591", "type": "Language", "_label": "Khmer" }</xsl:when>
            <xsl:when test="$lang = 'kik'">{ "id": "http://vocab.getty.edu/aat/300443672", "type": "Language", "_label": "Kikuyu, Gikuyu" }</xsl:when>
            <xsl:when test="$lang = 'kin'">{ "id": "http://vocab.getty.edu/aat/300389172", "type": "Language", "_label": "Kinyarwanda" }</xsl:when>
            <xsl:when test="$lang = 'kom'">{ "id": "http://vocab.getty.edu/aat/300443820", "type": "Language", "_label": "Komi" }</xsl:when>
            <xsl:when test="$lang = 'kon'">{ "id": "http://vocab.getty.edu/aat/300388623", "type": "Language", "_label": "Kongo" }</xsl:when>
            <xsl:when test="$lang = 'kor'">{ "id": "http://vocab.getty.edu/aat/300388633", "type": "Language", "_label": "Korean" }</xsl:when>
            <xsl:when test="$lang = 'kua'">{ "id": "http://vocab.getty.edu/aat/300451689", "type": "Language", "_label": "Kuanyama, Kwanyama" }</xsl:when>
            <xsl:when test="$lang = 'kur'">{ "id": "http://vocab.getty.edu/aat/300388656", "type": "Language", "_label": "Kurdish" }</xsl:when>
            <xsl:when test="$lang = 'kir'">{ "id": "http://vocab.getty.edu/aat/300388668", "type": "Language", "_label": "Kyrgyz" }</xsl:when>
            <xsl:when test="$lang = 'lao'">{ "id": "http://vocab.getty.edu/aat/300388688", "type": "Language", "_label": "Lao" }</xsl:when>
            <xsl:when test="$lang = 'lat'">{ "id": "http://vocab.getty.edu/aat/300388693", "type": "Language", "_label": "Latin" }</xsl:when>
            <xsl:when test="$lang = 'lav'">{ "id": "http://vocab.getty.edu/aat/300388696", "type": "Language", "_label": "Latvian" }</xsl:when>
            <xsl:when test="$lang = 'lim'">{ "id": "http://vocab.getty.edu/aat/300443822", "type": "Language", "_label": "Limburgan, Limburger, Limburgish" }</xsl:when>
            <xsl:when test="$lang = 'lin'">{ "id": "http://vocab.getty.edu/aat/300388719", "type": "Language", "_label": "Lingala" }</xsl:when>
            <xsl:when test="$lang = 'lit'">{ "id": "http://vocab.getty.edu/aat/300388723", "type": "Language", "_label": "Lithuanian" }</xsl:when>
            <xsl:when test="$lang = 'lub'">{ "id": "http://vocab.getty.edu/aat/300443690", "type": "Language", "_label": "Luba-Katanga" }</xsl:when>
            <xsl:when test="$lang = 'ltz'">{ "id": "http://vocab.getty.edu/aat/300388709", "type": "Language", "_label": "Luxembourgish, Letzeburgesch" }</xsl:when>
            <xsl:when test="$lang = 'mac'">{ "id": "http://vocab.getty.edu/aat/300388760", "type": "Language", "_label": "Macedonian" }</xsl:when>
            <xsl:when test="$lang = 'mlg'">{ "id": "http://vocab.getty.edu/aat/300388783", "type": "Language", "_label": "Malagasy" }</xsl:when>
            <xsl:when test="$lang = 'may'">{ "id": "http://vocab.getty.edu/aat/300388786", "type": "Language", "_label": "Malay" }</xsl:when>
            <xsl:when test="$lang = 'mal'">{ "id": "http://vocab.getty.edu/aat/300388787", "type": "Language", "_label": "Malayalam" }</xsl:when>
            <xsl:when test="$lang = 'mlt'">{ "id": "http://vocab.getty.edu/aat/300388796", "type": "Language", "_label": "Maltese" }</xsl:when>
            <xsl:when test="$lang = 'glv'">{ "id": "http://vocab.getty.edu/aat/300388324", "type": "Language", "_label": "Manx" }</xsl:when>
            <xsl:when test="$lang = 'mar'">{ "id": "http://vocab.getty.edu/aat/300388821", "type": "Language", "_label": "Marathi (Marāṭhī)" }</xsl:when>
            <xsl:when test="$lang = 'mah'">{ "id": "http://vocab.getty.edu/aat/300388831", "type": "Language", "_label": "Marshallese" }</xsl:when>
            <xsl:when test="$lang = 'mon'">{ "id": "http://vocab.getty.edu/aat/300388900", "type": "Language", "_label": "Mongolian" }</xsl:when>
            <xsl:when test="$lang = 'mao'">{ "id": "http://vocab.getty.edu/aat/300388818", "type": "Language", "_label": "Māori" }</xsl:when>
            <xsl:when test="$lang = 'nau'">{ "id": "http://vocab.getty.edu/aat/300388951", "type": "Language", "_label": "Nauru" }</xsl:when>
            <xsl:when test="$lang = 'nav'">{ "id": "http://vocab.getty.edu/aat/300388952", "type": "Language", "_label": "Navajo, Navaho" }</xsl:when>
            <xsl:when test="$lang = 'ndo'">{ "id": "http://vocab.getty.edu/aat/300388958", "type": "Language", "_label": "Ndonga" }</xsl:when>
            <xsl:when test="$lang = 'nep'">{ "id": "http://vocab.getty.edu/aat/300443704", "type": "Language", "_label": "Nepali" }</xsl:when>
            <xsl:when test="$lang = 'nde'">{ "id": "http://vocab.getty.edu/aat/300443703", "type": "Language", "_label": "North Ndebele" }</xsl:when>
            <xsl:when test="$lang = 'sme'">{ "id": "http://vocab.getty.edu/aat/300443601", "type": "Language", "_label": "Northern Sami" }</xsl:when>
            <xsl:when test="$lang = 'nor'">{ "id": "http://vocab.getty.edu/aat/300443706", "type": "Language", "_label": "Norwegian" }</xsl:when>
            <xsl:when test="$lang = 'nob'">{ "id": "http://vocab.getty.edu/aat/300391418", "type": "Language", "_label": "Norwegian Bokmål" }</xsl:when>
            <xsl:when test="$lang = 'nno'">{ "id": "http://vocab.getty.edu/aat/300388992", "type": "Language", "_label": "Norwegian Nynorsk" }</xsl:when>
            <xsl:when test="$lang = 'oci'">{ "id": "http://vocab.getty.edu/aat/300391532", "type": "Language", "_label": "Occitan" }</xsl:when>
            <xsl:when test="$lang = 'oji'">{ "id": "http://vocab.getty.edu/aat/300389015", "type": "Language", "_label": "Ojibwe, Ojibwa" }</xsl:when>
            <xsl:when test="$lang = 'ori'">{ "id": "http://vocab.getty.edu/aat/300389030", "type": "Language", "_label": "Oriya" }</xsl:when>
            <xsl:when test="$lang = 'orm'">{ "id": "http://vocab.getty.edu/aat/300389033", "type": "Language", "_label": "Oromo" }</xsl:when>
            <xsl:when test="$lang = 'oss'">{ "id": "http://vocab.getty.edu/aat/300443712", "type": "Language", "_label": "Ossetian, Ossetic" }</xsl:when>
            <xsl:when test="$lang = 'pan'">{ "id": "http://vocab.getty.edu/aat/300389057", "type": "Language", "_label": "Panjabi, Punjabi" }</xsl:when>
            <xsl:when test="$lang = 'pus'">{ "id": "http://vocab.getty.edu/aat/300389070", "type": "Language", "_label": "Pashto, Pushto" }</xsl:when>
            <xsl:when test="$lang = 'per'">{ "id": "http://vocab.getty.edu/aat/300389087", "type": "Language", "_label": "Persian" }</xsl:when>
            <xsl:when test="$lang = 'pol'">{ "id": "http://vocab.getty.edu/aat/300389109", "type": "Language", "_label": "Polish" }</xsl:when>
            <xsl:when test="$lang = 'por'">{ "id": "http://vocab.getty.edu/aat/300389115", "type": "Language", "_label": "Portuguese" }</xsl:when>
            <xsl:when test="$lang = 'pli'">{ "id": "http://vocab.getty.edu/aat/300404714", "type": "Language", "_label": "Pāli" }</xsl:when>
            <xsl:when test="$lang = 'que'">{ "id": "http://vocab.getty.edu/aat/300389128", "type": "Language", "_label": "Quechua" }</xsl:when>
            <xsl:when test="$lang = 'rum'">{ "id": "http://vocab.getty.edu/aat/300389157", "type": "Language", "_label": "Romanian, Moldavian" }</xsl:when>
            <xsl:when test="$lang = 'roh'">{ "id": "http://vocab.getty.edu/aat/300389162", "type": "Language", "_label": "Romansh" }</xsl:when>
            <xsl:when test="$lang = 'run'">{ "id": "http://vocab.getty.edu/aat/300389166", "type": "Language", "_label": "Rundi" }</xsl:when>
            <xsl:when test="$lang = 'rus'">{ "id": "http://vocab.getty.edu/aat/300389168", "type": "Language", "_label": "Russian" }</xsl:when>
            <xsl:when test="$lang = 'smo'">{ "id": "http://vocab.getty.edu/aat/300389198", "type": "Language", "_label": "Samoan" }</xsl:when>
            <xsl:when test="$lang = 'sag'">{ "id": "http://vocab.getty.edu/aat/300389203", "type": "Language", "_label": "Sango" }</xsl:when>
            <xsl:when test="$lang = 'san'">{ "id": "http://vocab.getty.edu/aat/300389205", "type": "Language", "_label": "Sanskrit (Saṁskṛta)" }</xsl:when>
            <xsl:when test="$lang = 'srd'">{ "id": "http://vocab.getty.edu/aat/300389214", "type": "Language", "_label": "Sardinian" }</xsl:when>
            <xsl:when test="$lang = 'gla'">{ "id": "http://vocab.getty.edu/aat/300388323", "type": "Language", "_label": "Scottish Gaelic; Gaelic" }</xsl:when>
            <xsl:when test="$lang = 'srp'">{ "id": "http://vocab.getty.edu/aat/300389247", "type": "Language", "_label": "Serbian" }</xsl:when>
            <xsl:when test="$lang = 'sna'">{ "id": "http://vocab.getty.edu/aat/300389263", "type": "Language", "_label": "Shona" }</xsl:when>
            <xsl:when test="$lang = 'iii'">{ "id": "http://vocab.getty.edu/aat/300443897", "type": "Language", "_label": "Sichuan Yi, Nuosu" }</xsl:when>
            <xsl:when test="$lang = 'snd'">{ "id": "http://vocab.getty.edu/aat/300389278", "type": "Language", "_label": "Sindhi" }</xsl:when>
            <xsl:when test="$lang = 'sin'">{ "id": "http://vocab.getty.edu/aat/300389279", "type": "Language", "_label": "Sinhala, Sinhalese" }</xsl:when>
            <xsl:when test="$lang = 'slo'">{ "id": "http://vocab.getty.edu/aat/300389290", "type": "Language", "_label": "Slovak" }</xsl:when>
            <xsl:when test="$lang = 'slv'">{ "id": "http://vocab.getty.edu/aat/300389291", "type": "Language", "_label": "Slovene" }</xsl:when>
            <xsl:when test="$lang = 'som'">{ "id": "http://vocab.getty.edu/aat/300389295", "type": "Language", "_label": "Somali" }</xsl:when>
            <xsl:when test="$lang = 'nbl'">{ "id": "http://vocab.getty.edu/aat/300388955", "type": "Language", "_label": "South Ndebele" }</xsl:when>
            <xsl:when test="$lang = 'sot'">{ "id": "http://vocab.getty.edu/aat/300389308", "type": "Language", "_label": "Southern Sotho" }</xsl:when>
            <xsl:when test="$lang = 'spa'">{ "id": "http://vocab.getty.edu/aat/300389311", "type": "Language", "_label": "Spanish; Castilian" }</xsl:when>
            <xsl:when test="$lang = 'sun'">{ "id": "http://vocab.getty.edu/aat/300389326", "type": "Language", "_label": "Sundanese" }</xsl:when>
            <xsl:when test="$lang = 'swa'">{ "id": "http://vocab.getty.edu/aat/300389334", "type": "Language", "_label": "Swahili" }</xsl:when>
            <xsl:when test="$lang = 'ssw'">{ "id": "http://vocab.getty.edu/aat/300389335", "type": "Language", "_label": "Swati" }</xsl:when>
            <xsl:when test="$lang = 'swe'">{ "id": "http://vocab.getty.edu/aat/300389336", "type": "Language", "_label": "Swedish" }</xsl:when>
            <xsl:when test="$lang = 'tgl'">{ "id": "http://vocab.getty.edu/aat/300389344", "type": "Language", "_label": "Tagalog" }</xsl:when>
            <xsl:when test="$lang = 'tah'">{ "id": "http://vocab.getty.edu/aat/300389346", "type": "Language", "_label": "Tahitian" }</xsl:when>
            <xsl:when test="$lang = 'tgk'">{ "id": "http://vocab.getty.edu/aat/300389350", "type": "Language", "_label": "Tajik" }</xsl:when>
            <xsl:when test="$lang = 'tam'">{ "id": "http://vocab.getty.edu/aat/300389365", "type": "Language", "_label": "Tamil" }</xsl:when>
            <xsl:when test="$lang = 'tat'">{ "id": "http://vocab.getty.edu/aat/300389381", "type": "Language", "_label": "Tatar" }</xsl:when>
            <xsl:when test="$lang = 'tel'">{ "id": "http://vocab.getty.edu/aat/300389389", "type": "Language", "_label": "Telugu" }</xsl:when>
            <xsl:when test="$lang = 'tha'">{ "id": "http://vocab.getty.edu/aat/300389405", "type": "Language", "_label": "Thai" }</xsl:when>
            <xsl:when test="$lang = 'tib'">{ "id": "http://vocab.getty.edu/aat/300389410", "type": "Language", "_label": "Tibetan Standard" }</xsl:when>
            <xsl:when test="$lang = 'tir'">{ "id": "http://vocab.getty.edu/aat/300389414", "type": "Language", "_label": "Tigrinya" }</xsl:when>
            <xsl:when test="$lang = 'ton'">{ "id": "http://vocab.getty.edu/aat/300389432", "type": "Language", "_label": "Tonga (Tonga Islands)" }</xsl:when>
            <xsl:when test="$lang = 'tso'">{ "id": "http://vocab.getty.edu/aat/300389452", "type": "Language", "_label": "Tsonga" }</xsl:when>
            <xsl:when test="$lang = 'tsn'">{ "id": "http://vocab.getty.edu/aat/300389454", "type": "Language", "_label": "Tswana" }</xsl:when>
            <xsl:when test="$lang = 'tur'">{ "id": "http://vocab.getty.edu/aat/300389470", "type": "Language", "_label": "Turkish" }</xsl:when>
            <xsl:when test="$lang = 'tuk'">{ "id": "http://vocab.getty.edu/aat/300389473", "type": "Language", "_label": "Turkmen" }</xsl:when>
            <xsl:when test="$lang = 'twi'">{ "id": "http://vocab.getty.edu/aat/300443904", "type": "Language", "_label": "Twi" }</xsl:when>
            <xsl:when test="$lang = 'uig'">{ "id": "http://vocab.getty.edu/aat/300389509", "type": "Language", "_label": "Uighur, Uyghur" }</xsl:when>
            <xsl:when test="$lang = 'ukr'">{ "id": "http://vocab.getty.edu/aat/300389489", "type": "Language", "_label": "Ukrainian" }</xsl:when>
            <xsl:when test="$lang = 'urd'">{ "id": "http://vocab.getty.edu/aat/300389502", "type": "Language", "_label": "Urdu" }</xsl:when>
            <xsl:when test="$lang = 'uzb'">{ "id": "http://vocab.getty.edu/aat/300389510", "type": "Language", "_label": "Uzbek" }</xsl:when>
            <xsl:when test="$lang = 'ven'">{ "id": "http://vocab.getty.edu/aat/300389522", "type": "Language", "_label": "Venda" }</xsl:when>
            <xsl:when test="$lang = 'vie'">{ "id": "http://vocab.getty.edu/aat/300389525", "type": "Language", "_label": "Vietnamese" }</xsl:when>
            <xsl:when test="$lang = 'vol'">{ "id": "http://vocab.getty.edu/aat/300443757", "type": "Language", "_label": "Volapük" }</xsl:when>
            <xsl:when test="$lang = 'wln'">{ "id": "http://vocab.getty.edu/aat/300389541", "type": "Language", "_label": "Walloon" }</xsl:when>
            <xsl:when test="$lang = 'wel'">{ "id": "http://vocab.getty.edu/aat/300389555", "type": "Language", "_label": "Welsh" }</xsl:when>
            <xsl:when test="$lang = 'fry'">{ "id": "http://vocab.getty.edu/aat/300388308", "type": "Language", "_label": "Western Frisian" }</xsl:when>
            <xsl:when test="$lang = 'wol'">{ "id": "http://vocab.getty.edu/aat/300389568", "type": "Language", "_label": "Wolof" }</xsl:when>
            <xsl:when test="$lang = 'xho'">{ "id": "http://vocab.getty.edu/aat/300389577", "type": "Language", "_label": "Xhosa" }</xsl:when>
            <xsl:when test="$lang = 'yid'">{ "id": "http://vocab.getty.edu/aat/300389602", "type": "Language", "_label": "Yiddish" }</xsl:when>
            <xsl:when test="$lang = 'yor'">{ "id": "http://vocab.getty.edu/aat/300389608", "type": "Language", "_label": "Yoruba" }</xsl:when>
            <xsl:when test="$lang = 'zha'">{ "id": "http://vocab.getty.edu/aat/300389631", "type": "Language", "_label": "Zhuang, Chuan" }</xsl:when>
            <xsl:when test="$lang = 'zul'">{ "id": "http://vocab.getty.edu/aat/300389637", "type": "Language", "_label": "Zulu" }</xsl:when>

            <xsl:otherwise>
                <xsl:text>{ "id": "http://vocab.getty.edu/aat/300389645", "type": "Language", "_label": "Undetermined (language)", "notation": "und" }</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
