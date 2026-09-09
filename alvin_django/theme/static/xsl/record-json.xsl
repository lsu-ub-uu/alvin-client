<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:param name="domain_root"/>
    <xsl:variable name="host">
        <xsl:value-of select="substring-before($domain_root,'data')"/>
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
        <xsl:call-template name="language"/>
        <xsl:call-template name="current_owner"/>
        <xsl:call-template name="current_location"/>
        <xsl:call-template name="member_of"/>
        <xsl:call-template name="Production"/>
        <xsl:call-template name="publication"/>
        <xsl:call-template name="made_of"/>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="subject_of"/>
        <xsl:call-template name="carries"/>
        <xsl:call-template name="shows"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="work">
        <xsl:text>{</xsl:text>
        <xsl:call-template name="context"/>
        <xsl:call-template name="id"/>
        <xsl:call-template name="linguisticObject_type"/>
        <xsl:call-template name="labelTitle"/>
        <xsl:call-template name="classified_as"/>
        <xsl:call-template name="Production"/>
        <xsl:call-template name="referred_to_by"/>
        <xsl:call-template name="defined_by"/>
        <xsl:call-template name="identified_by"/>
        <xsl:text>}</xsl:text>
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
    </xsl:template>
    <xsl:template name="context">
        <xsl:text>"@context": "https://linked.art/ns/v1/linked-art.json",</xsl:text>
    </xsl:template>
    <xsl:template name="context-ksamsok"> "@context": [ { "@version": 1.1, "raa": "https://kulturarvsdata.se/resurser/vocab/20/", "schema": "http://schema.org/", "dcterms": "http://purl.org/dc/terms/", "RecordProvenance": "raa:RecordProvenance", "SourceRecord": "raa:SourceRecord", "dateCreated": "schema:dateCreated", "dateModified": "schema:dateModified", "ingestedAt": "raa:ingestedAt", "license": "schema:license", "provider": "raa:provider", "record_provenance": "raa:record_provenance", "replaces": "dcterms:replaces", "sourceRecord": "raa:sourceRecord", "url": "schema:url" }, "https://linked.art/ns/v1/linked-art.json" ], </xsl:template>
    <xsl:template name="id"><xsl:text>"id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/><xsl:text>",</xsl:text></xsl:template>
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
        <xsl:for-each select="physicalLocation/heldBy/location">
            <xsl:text>"current_owner": [{ "id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="linkedRecordType"/>/<xsl:value-of select="linkedRecordId"/><xsl:text>", "type": "Group","_label": "</xsl:text>
            <xsl:value-of select="linkedRecord/location/authority[1]/name"/><xsl:text>"}],</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="current_location">
        <xsl:for-each select="physicalLocation">
            <xsl:text>"current_location": { "id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="heldBy/location/linkedRecordType"/>/<xsl:value-of select="heldBy/location/linkedRecordId"/><xsl:text>","type": "Place",</xsl:text>
            <xsl:choose>
                <xsl:when test="string-length(sublocation) &gt; 0"><xsl:text>"_label": "</xsl:text><xsl:value-of select="sublocation"/><xsl:text>",</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>"_label": "</xsl:text><xsl:value-of select="heldBy/location/linkedRecord/location/authority[1]/name"/><xsl:text>"</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="string-length(sublocation) &gt; 0">
                <xsl:text>"classified_as": [{ "id": "http://vocab.getty.edu/aat/300004044", "type": "Type", "_label": "Rooms (interior spaces)" }], "part_of": [{ "id": "</xsl:text><xsl:value-of select="$host"/><xsl:value-of select="heldBy/location/linkedRecordType"/>/<xsl:value-of select="heldBy/location/linkedRecordId"/><xsl:text>", "type": "Place", "_label": "</xsl:text><xsl:value-of select="heldBy/location/linkedRecord/location/authority[1]/name"/><xsl:text>"}]</xsl:text>
            </xsl:if>
            <xsl:for-each select="note[@noteType = 'general']">
                <xsl:text>, "referred_to_by": [{ "type": "LinguisticObject", "classified_as": [{ "id": "http://vocab.getty.edu/aat/300027200", "type": "Type", "_label": "Note" }], "content": "</xsl:text><xsl:value-of select="normalize-space(translate(., $dq, ''))"/><xsl:text>"}]</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:text>},</xsl:text>
    </xsl:template>
    <xsl:template name="recordProvenance"> "record_provenance": { "id": "<xsl:value-of select="$host"/>
        <xsl:for-each select="physicalLocation/heldBy/location">
            <xsl:value-of select="linkedRecordType"/>/<xsl:value-of select="linkedRecordId"/>
        </xsl:for-each>", "type": "RecordProvenance", "license": "http://creativecommons.org/publicdomain/zero/1.0/", "sourceRecord": { "type": "SourceRecord", "id": "<xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/>", "dateCreated": "<xsl:value-of select="substring(recordInfo/tsCreated,1,19)"/>Z", "dateModified": "<xsl:value-of select="substring(recordInfo/updated[last()]/tsUpdated,1,19)"/>Z", "url": "<xsl:value-of select="$host"/><xsl:value-of select="recordInfo/type/linkedRecordId"/>/<xsl:value-of select="recordInfo/id"/>" } } </xsl:template>
    <xsl:template name="classified_as">
        <xsl:text>"classified_as": [ </xsl:text>
        <xsl:for-each select="productionMethod">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>ProductionItem", "type": "Type", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>", "equivalent": [</xsl:text>
            <xsl:choose>
                <xsl:when test=". = 'manuscript'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300252927", "type": "Type", "_label": "Handwriting" }</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'print'">
                    <xsl:text>{ "id": "http://vocab.getty.edu/aat/300053319", "type": "Type", "_label": "Printing (process)" }</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:text>] }, </xsl:text>
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
            <xsl:text>", "equivalent:": [</xsl:text>
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
            <xsl:text>]}</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="formOfWork">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>FormOfWorkItem", "type": "Type", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>", "equivalent:": [</xsl:text>
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
            <xsl:text>],</xsl:text>
            <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/aat/300455840", "type": "Type", "_label": "Genre" } ]</xsl:text>
            <xsl:text> }</xsl:text>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
    </xsl:template>
    <xsl:template name="title">
        <xsl:for-each select="title">
            <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404670", "type": "Type", "_label": "Primary Name" } ], "content": "</xsl:text>
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
            <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404670", "type": "Type", "_label": "Primary Name" } ], "content": "</xsl:text>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:call-template name="labelPlace"/>
            <xsl:text>",</xsl:text>
            <xsl:text>"language": [ { "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="@lang"/>
            <xsl:text>MarcLanguageItem", "type": "Language", "notation": "</xsl:text>
            <xsl:value-of select="@lang"/>
            <xsl:text>" } ] },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="authority[position() > 1]">
            <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300458860", "type": "Type", "_label": "Alternate Name" } ], "content": "</xsl:text>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:call-template name="labelPlace"/>
            <xsl:text>",</xsl:text>
            <xsl:text>"language": [ { "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="@lang"/>
            <xsl:text>MarcLanguageItem", "type": "Language", "notation": "</xsl:text>
            <xsl:value-of select="@lang"/>
            <xsl:text>" } ] },</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="variant">
            <xsl:choose>
                <xsl:when test="@variantType = 'pseudonym' or @variantType = 'pseudonymAndSignature'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404657", "type": "Type", "_label": "Pseudonym" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'signature'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300028705", "type": "Type", "_label": "Signature" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'nickname'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404656", "type": "Type", "_label": "Nickname" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'maidenName'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404682", "type": "Type", "_label": "Maiden name" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'earlier'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435719", "type": "Type", "_label": "Former name" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'abbreviation'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300194407", "type": "Type", "_label": "Abbreviation" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'acronym'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404659", "type": "Type", "_label": "Acronym" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:when test="@variantType = 'expansion'">
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300404688", "type": "Type", "_label": "Full name" } ], "content": "</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>{ "type": "Name", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300458860", "type": "Type", "_label": "Alternate Name" } ], "content": "</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="labelPerson"/>
            <xsl:call-template name="labelOrganisation"/>
            <xsl:call-template name="labelPlace"/>
            <xsl:text>",</xsl:text>
            <xsl:text>"language": [ { "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="@lang"/>
            <xsl:text>MarcLanguageItem", "type": "Language", "notation": "</xsl:text>
            <xsl:value-of select="@lang"/>
            <xsl:text>" } ] },</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="language">
        <xsl:if test="string-length(language) &gt; 0">
            <xsl:choose>
                <xsl:when test="collection = 'yes'"> "members_exemplified_by": [ { "type": "LinguisticObject", "_label": "The text carried by the object", "language": [ <xsl:call-template name="languageLink"/> ] } ], </xsl:when>
                <xsl:otherwise> "carries": [ { "type": "LinguisticObject", "_label": "The text carried by the object", "language": [ <xsl:call-template name="languageLink"/> ] } ], </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="languageLink">
        <xsl:for-each select="language">
            <xsl:text>{ "id": "</xsl:text>
            <xsl:value-of select="$host"/>
            <xsl:text>vocabulary/</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>MarcLanguageItem", "type": "Language", "_label": "</xsl:text>
            <xsl:call-template name="labels"/>
            <xsl:text>", "notation": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" }</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
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
            <xsl:text>", "classified_as": [{ "id": "http://vocab.getty.edu/aat/300025976", "type": "Type", "_label": "Collection (object groupings)" }]}</xsl:text>
            <xsl:text>],</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Production">
        <xsl:if test="appliedMaterial or editionStatement or originDate or agent or originPlace">
            <xsl:text>"produced_by": { "type": "Production",</xsl:text>
            <xsl:if test="appliedMaterial">
                <xsl:text>"technique": [ </xsl:text>
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
                <xsl:if test="editionStatement or originDate or agent or originPlace">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="editionStatement">
                <xsl:text>"referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435435", "type": "Type", "_label": "Edition description" }  ], "content": "</xsl:text>
                <xsl:value-of select="editionStatement"/>
                <xsl:text>"}]</xsl:text>
                <xsl:if test="originDate or agent or originPlace">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="originDate">
                <xsl:for-each select="originDate">
                    <xsl:for-each select="displayDate">
                        <xsl:text>"referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435447", "type": "Type", "_label": "Creation date description" } ], "content": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>" } ]</xsl:text>
                        <xsl:if test="../startDate or ../endDate">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="startDate or endDate">
                        <xsl:text>"timespan": { "type": "TimeSpan", "_label": "</xsl:text>
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
                <xsl:if test="agent or originPlace">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="agent">
                <xsl:text>"part": [ </xsl:text>
                <xsl:for-each select="agent">
                    <xsl:text>{ "type": "Production", "classified_as": [ </xsl:text>
                    <xsl:for-each select="role">
                        <xsl:text>{ "id": "</xsl:text>
                        <xsl:value-of select="$host"/>
                        <xsl:text>vocabulary/</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                        <xsl:text>MarcRelatorItem</xsl:text>
                        <xsl:text>", "type": "Type", "_label": "</xsl:text>
                        <xsl:value-of select="@_value_en"/>
                        <xsl:text>","notation": "</xsl:text>
                        <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
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
                <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:if test="originPlace">
                <xsl:text>"took_place_at": [ </xsl:text>
                <xsl:for-each select="originPlace">
                    <xsl:text>{ </xsl:text>
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
                        <xsl:if test="../country or ../historicalCountry">
                            <xsl:text>, "part_of": [ </xsl:text>
                            <xsl:for-each select="../country">
                                <xsl:text>{ "id": "</xsl:text>
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
                                <xsl:text>","notation": "</xsl:text>
                                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                                <xsl:text>",</xsl:text>
                                <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/aat/300387506", "type": "Type", "_label": "Country" } ] } </xsl:text>
                                <xsl:if test="../historicalCountry">
                                    <xsl:text>,</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="../historicalCountry">
                                <xsl:text>{ "id": "</xsl:text>
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
                                <xsl:text>",</xsl:text>
                                <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/aat/300387356", "type": "Type", "_label": "Former primary political entity" } ] } </xsl:text>
                            </xsl:for-each>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:if test="not(place)">
                        <xsl:for-each select="country">
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
                            <xsl:text>","notation": "</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                            <xsl:text>",</xsl:text>
                            <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/aat/300387506", "type": "Type", "_label": "Country" } ]</xsl:text>
                            <xsl:if test="../historicalCountry">
                                <xsl:text>}, {</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="historicalCountry">
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
                            <xsl:text>",</xsl:text>
                            <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/aat/300387356", "type": "Type", "_label": "Former primary political entity" } ]</xsl:text>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:text> } </xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>},</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="publication">
        <xsl:for-each select="publication">
            <xsl:text>"used_for": [ { "type": "Activity", "_label": "Publishing", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300054686", "type": "Type", "_label": "Publishing" } ], "carried_out_by": [ { "type": "Organization", "_label": "Publisher", "identified_by": [ { "type": "Name", "content": "</xsl:text>
            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
            <xsl:text>" } ] } ] } ], </xsl:text>
        </xsl:for-each>
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
        <xsl:for-each select="dateOther">
            <xsl:text>{ "type": "Statement", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435416", "type": "Type", "_label": "Date/time statement (</xsl:text>
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
                    <xsl:text>, { "id": "http://vocab.getty.edu/aat/300265266", "type": "Controlled vocabulary", "_label": "</xsl:text>
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
                    <xsl:text>, { "id": "http://vocab.getty.edu/aat/300265266", "type": "Controlled vocabulary", "_label": "</xsl:text>
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
                <xsl:text>, "language": [ { "id": "</xsl:text>
                <xsl:value-of select="$host"/>
                <xsl:text>vocabulary/</xsl:text>
                <xsl:value-of select="@lang"/>
                <xsl:text>MarcLanguageItem", "type": "Language", "notation": "</xsl:text>
                <xsl:value-of select="@lang"/>
                <xsl:text>" } ]</xsl:text>
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
                <xsl:text>{ "type": "DigitalObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300264578", "type": "Type", "_label": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(displayLabel, $dq, ''))"/>
                <xsl:for-each select="person/linkedRecord/person/authority[1]">
                    <xsl:call-template name="labelPerson"/>
                </xsl:for-each>
                <xsl:for-each select="organisation/linkedRecord/organisation/authority[1]">
                    <xsl:call-template name="labelOrganisation"/>
                </xsl:for-each>
                <xsl:for-each select="record | person | organisation">
                    <xsl:variable name="url">
                        <xsl:text>" } ], "access_point": [ { "id": "</xsl:text>
                        <xsl:value-of select="$host"/>
                        <xsl:value-of select="linkedRecordType"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="linkedRecordId"/>
                    </xsl:variable>
                    <xsl:for-each select="linkedRecord">
                        <xsl:for-each select="record">
                            <xsl:value-of select="normalize-space(translate(title/mainTitle, $dq, ''))"/>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:value-of select="$url"/>
                </xsl:for-each>
                <xsl:if test="url">
                    <xsl:text>" } ], "access_point": [ { "id": "</xsl:text>
                    <xsl:value-of select="url"/>
                </xsl:if>
                <xsl:text>", "type": "DigitalObject" } ] } </xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>],</xsl:text>
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
                            <xsl:text>","notation": "</xsl:text>
                            <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
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
                <xsl:text>","notation": "</xsl:text>
                <xsl:value-of select="normalize-space(translate(., $dq, ''))"/>
                <xsl:text>",</xsl:text>
                <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/aat/300387506", "type": "Type", "_label": "Country" } ] } ], </xsl:text>
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
            <xsl:text>", "type": "VisualItem", "_label": "Digital surrogate",</xsl:text>
            <xsl:for-each select="fileSection">
                <xsl:for-each select="rights"><xsl:text>"referred_to_by": [ { "type": "LinguisticObject", "classified_as": [ { "id": "http://vocab.getty.edu/aat/300435434", "type": "Type", "_label": "Copyright/licensing statement" } ], "content": "</xsl:text>
                    <xsl:text>License for the digital surrogate: </xsl:text>
                    <xsl:value-of select="@_value_en"/>
                    <xsl:text>" } ],</xsl:text>
                </xsl:for-each>
                <xsl:for-each select="digitalOrigin">
                    <xsl:text>"classified_as": [ { "id": "http://vocab.getty.edu/page/aat/300404764", "type": "Type", "_label": "Source: </xsl:text>
                    <xsl:value-of select="@_value_en"/>
                    <xsl:text>" } ] </xsl:text> 
                </xsl:for-each>
            </xsl:for-each>
            <xsl:text> } ],</xsl:text>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
