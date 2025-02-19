<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <div class="main">
            <xsl:apply-templates select="dataList/data"/>
        </div>
    </xsl:template>
    <xsl:template match="data">
        <h1>Members</h1>
        <p>Alvin is a collaboration between several different cultural heritage organisations within the GLAM (galleries, libraries, archives, and museums) sector in the Nordic countries.</p>
        <p>There are <b><xsl:value-of select="../totalNo"/></b> archival institutions in Alvin.</p>
        <p>These are the entities holding the original item or from which it is available.</p>
        <h2 id="the-alvin-consortium">The Alvin consortium - steering group</h2>
        <ul>
            <xsl:for-each select="record/data/location">
                <xsl:sort select="authority/name/namePart" lang="sv" order="descending"/>
                <xsl:if test="organisationInfo/descriptor = 'consortium'">
                    <xsl:for-each select="authority[1]/name">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>alvin-location/</xsl:text>
                                    <xsl:value-of select="../../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="namePart"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </ul>
        <h2 id="other-members">Other members of Alvin</h2>
        <ul>
            <xsl:for-each select="record/data/location">
                <xsl:sort select="authority/name/namePart" lang="sv"/>
                <xsl:if test="organisationInfo/descriptor = 'member'">
                    <xsl:for-each select="authority[1]/name">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>alvin-location/</xsl:text>
                                    <xsl:value-of select="../../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="namePart"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </ul>
        <h2 id="other-institutions">Other institutions with material in Alvin</h2>
        <ul>
            <xsl:for-each select="record/data/location">
                <xsl:sort select="authority/name/namePart" lang="sv"/>
                <xsl:if test="organisationInfo/descriptor = 'other'">
                    <xsl:for-each select="authority[1]/name">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>alvin-location/</xsl:text>
                                    <xsl:value-of select="../../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="namePart"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>
