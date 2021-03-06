<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl" version="2.0"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/"
        xmlns:void="http://rdfs.org/ns/void#" xmlns:nmo="http://nomisma.org/ontology#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        >
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:param name="url">
        <xsl:value-of select="'https://finds.org.uk/database/artefacts/record/id/'"/>
    </xsl:param>

    <xsl:param name="thumbnail">
        <xsl:value-of select="'https://finds.org.uk/images/thumbnails/'"/>
    </xsl:param>

    <xsl:param name="images">
        <xsl:value-of select="'https://finds.org.uk/'"/>
    </xsl:param>

    <xsl:template match="/">
        <rdf:RDF>
            <xsl:apply-templates select="response/result/doc"/>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="doc">
        <nmo:NumismaticObject>

            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$url"/><xsl:value-of select="int[@name='id']"/>
            </xsl:attribute>

            <dcterms:title>
                <xsl:choose>
                    <xsl:when test="str[@name='rulerName']">
                        <xsl:value-of select="str[@name='old_findID']"/>: A Roman coin issued by <xsl:value-of select="str[@name='rulerName']"/> RIC ID:<xsl:value-of select="str[@name='ricID']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="str[@name='old_findID']"/>: A Roman coin with an unrecorded/uncertain
                        moneyer.
                    </xsl:otherwise>
                </xsl:choose>
            </dcterms:title>

            <dcterms:identifier>
                <xsl:value-of select="str[@name='old_findID']"/>
            </dcterms:identifier>

            <xsl:if test="str[@name='ricID']">
                <nmo:hasTypeSeriesItem>
                    <xsl:attribute name="rdf:resource">http://numismatics.org/ocre/id/<xsl:value-of
                            select="str[@name='ricID']"/>
                    </xsl:attribute>
                </nmo:hasTypeSeriesItem>
            </xsl:if>

            <xsl:if test="int[@name='axis']">
                <nmo:hasAxis rdf:datatype="xsd:integer">
                    <xsl:value-of select="int[@name='axis']"/>
                </nmo:hasAxis>
            </xsl:if>

            <xsl:if test="double[@name='diameter']">
                <nmo:hasDiameter rdf:datatype="xsd:decimal">
                    <xsl:value-of select="double[@name='diameter']"/>
                </nmo:hasDiameter>
            </xsl:if>

            <xsl:if test="double[@name='weight']">
                <nmo:hasWeight rdf:datatype="xsd:decimal">
                    <xsl:value-of select="double[@name='weight']"/>
                </nmo:hasWeight>
            </xsl:if>

            <void:inDataset>
                <xsl:attribute name="rdf:resource">https://finds.org.uk/</xsl:attribute>
            </void:inDataset>

            <xsl:if test="int[@name='thumbnail']">
                <xsl:if test="str[@name='filename']">
                    <foaf:depiction>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$images"/><xsl:value-of select="str[@name='imagedir']"/><xsl:value-of
                                select="str[@name='filename']"/></xsl:attribute>
                    </foaf:depiction>
                </xsl:if>
                <xsl:if test="int[@name='thumbnail']">
                    <foaf:thumbnail>
                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$thumbnail"/><xsl:value-of select="int[@name='thumbnail']"/>.jpg</xsl:attribute>
                    </foaf:thumbnail>
                </xsl:if>
            </xsl:if>

            <xsl:if test="str[@name='knownas']">
                <xsl:if test="str[@name='gridref']">
                    <nmo:hasFindspot>
                        <rdf:Description xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
                            <xsl:attribute name="rdf:about">http://data.ordnancesurvey.co.uk/doc/7000000000<xsl:value-of select="format-number(int[@name='parishID'],'000000')"/>
                            </xsl:attribute>
                            <geo:lat>
                                <xsl:value-of select="double[@name='fourFigureLat']"/>
                            </geo:lat>
                            <geo:long>
                                <xsl:value-of select="double[@name='fourFigureLon']"/>
                            </geo:long>
                            <foaf:name><xsl:value-of select="str[@name='parish']"/></foaf:name>
                        </rdf:Description>
                    </nmo:hasFindspot>
                </xsl:if>
            </xsl:if>

        </nmo:NumismaticObject>
    </xsl:template>
</xsl:stylesheet>
