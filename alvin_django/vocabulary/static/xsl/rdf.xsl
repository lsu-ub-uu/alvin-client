<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <xsl:template match="/">
        <xsl:apply-templates select="record/data/metadata"/>
    </xsl:template>
    <xsl:template match="metadata">
        <!--
        <rdf:RDF xml:base="http://id.loc.gov/ontologies/bibframe/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:bf="http://id.loc.gov/ontologies/bibframe/" xmlns:bflc="http://id.loc.gov/ontologies/bflc/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:cc="http://creativecommons.org/ns#">
            <owl:Class rdf:about="http://id.loc.gov/ontologies/bibframe/Title">
                <rdfs:label>Title entity</rdfs:label>
                <skos:definition>Title information relating to a resource: work title, preferred title, instance title, transcribed title, translated title, variant form of title, etc.</skos:definition>
                <dcterms:modified>2016-04-21 (New)</dcterms:modified>
                <dcterms:modified>2017-02-03 (Definition changed)</dcterms:modified>
            </owl:Class>
            <owl:ObjectProperty rdf:about="http://id.loc.gov/ontologies/bibframe/titleOf">
                <rdfs:domain rdf:resource="http://id.loc.gov/ontologies/bibframe/Title"/>
                <skos:definition>Relates a title resource to that which it is the title of.</skos:definition>
                <rdfs:label>Title of</rdfs:label>
                <rdfs:comment>Suggested value - Work, Instance, Item or Event</rdfs:comment>
                <dcterms:modified>2021-06-09 (New [GH22])</dcterms:modified>
            </owl:ObjectProperty>
            <owl:DatatypeProperty rdf:about="http://id.loc.gov/ontologies/bibframe/mainTitle">
                <rdfs:domain rdf:resource="http://id.loc.gov/ontologies/bibframe/Title"/>
                <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                <skos:definition>Title being addressed. Possible title component.</skos:definition>
                <rdfs:label>Main title</rdfs:label>
                <dcterms:modified>2016-04-21 (New)</dcterms:modified>
            </owl:DatatypeProperty>
            <owl:DatatypeProperty rdf:about="http://id.loc.gov/ontologies/bibframe/subtitle">
                <rdfs:domain rdf:resource="http://id.loc.gov/ontologies/bibframe/Title"/>
                <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                <skos:definition>Word, character, or group of words and/or characters that contains the remainder of the title after the main title. Possible title component.</skos:definition>
                <rdfs:label>Subtitle</rdfs:label>
                <dcterms:modified>2016-04-21 (New)</dcterms:modified>
            </owl:DatatypeProperty>
            <owl:DatatypeProperty rdf:about="http://id.loc.gov/ontologies/bibframe/partNumber">
                <rdfs:domain rdf:resource="http://id.loc.gov/ontologies/bibframe/Title"/>
                <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                <skos:definition>Part or section enumeration of a title. Possible title component.</skos:definition>
                <rdfs:label>Part number</rdfs:label>
                <dcterms:modified>2016-04-21 (New)</dcterms:modified>
            </owl:DatatypeProperty>
            <owl:DatatypeProperty rdf:about="http://id.loc.gov/ontologies/bibframe/partName">
                <rdfs:domain rdf:resource="http://id.loc.gov/ontologies/bibframe/Title"/>
                <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal"/>
                <skos:definition>Part or section name of a title. Possible title component.</skos:definition>
                <rdfs:label>Part title</rdfs:label>
                <dcterms:modified>2016-04-21 (New)</dcterms:modified>
            </owl:DatatypeProperty>
        </rdf:RDF>   
        -->
    </xsl:template>    
</xsl:stylesheet>