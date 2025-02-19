<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <div class="main">
            <xsl:apply-templates select="record/data"/>
        </div>
    </xsl:template>
    <xsl:template match="data">
        <xsl:apply-templates select="location"/>
    </xsl:template>
    <xsl:template match="location">
        <h1>
            <xsl:value-of select="authority[1]/name/namePart[@type = 'corporateName']"/>
        </h1>
        <p><i class="fa fa-university"><xsl:text> </xsl:text></i> Archival institution</p>
        <xsl:for-each select="summary[@lang = 'swe']">
            <p>
                <xsl:value-of select="."  disable-output-escaping="yes"/>
            </p>
        </xsl:for-each>
        <div class="tab">
            <button class="tablinks" onclick="openCity(event, 'Overview')" id="defaultOpen"
                >Overview</button>
            <button class="tablinks" onclick="openCity(event, 'All')">All metadata</button>
            <button class="tablinks" onclick="openCity(event, 'Related')">Related</button>
        </div>
        <div id="Overview" class="tabcontent">
            <xsl:for-each select="electronicLocator">
                <div class="row">
                    <div class="col-25">URL</div>
                    <div class="col-75">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="url"/>
                            </xsl:attribute>
                            <xsl:value-of select="displayLabel"/>
                        </a>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="email">
                <div class="row">
                    <div class="col-25">Email</div>
                    <div class="col-75">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>mailto:</xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </a>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="address">
                <xsl:for-each select="postOfficeBox">
                    <div class="row">
                        <div class="col-25">P.O. box</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="street">
                    <div class="row">
                        <div class="col-25">Street</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="postcode">
                    <div class="row">
                        <div class="col-25">Postal code</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="place">
                    <div class="row">
                        <div class="col-25">Place</div>
                        <div class="col-75">
                            <xsl:for-each select="actionLinks/read">
                                <xsl:value-of select="url"/>
                            </xsl:for-each>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="country">
                    <div class="row">
                        <div class="col-25">Country</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="point">
                <div class="row">
                    <div class="col-25">Directions</div>
                    <div class="col-75">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>https://maps.google.com/?q=</xsl:text>
                                <xsl:value-of select="latitude"/>
                                <xsl:text>,</xsl:text>
                                <xsl:value-of select="longitude"/>
                            </xsl:attribute>Google Maps</a>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="recordInfo">
                <div class="row">
                    <div class="col-25">Alvin ID</div>
                    <div class="col-75">
                        <xsl:value-of select="type/linkedRecordId"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="id"/>
                    </div>
                </div>
            </xsl:for-each>
        </div>
        <div id="All" class="tabcontent">
            <xsl:for-each select="authority[1]/name">
                <div class="row">
                    <div class="col-25">Name</div>
                    <div class="col-75">
                        <xsl:for-each select="namePart[@type = 'corporateName']">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="namePart[@type = 'subordinate']">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="namePart[@type = 'termsOfAddress']">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="authority[@lang = 'eng']/name">
                <div class="row">
                    <div class="col-25">Name in English</div>
                    <div class="col-75">
                        <xsl:for-each select="namePart[@type = 'corporateName']">
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="namePart[@type = 'subordinate']">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                        <xsl:for-each select="namePart[@type = 'termsOfAddress']">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:for-each>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="organisationInfo/descriptor">
                <div class="row">
                    <div class="col-25">Type of institution</div>
                    <div class="col-75">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="electronicLocator">
                <div class="row">
                    <div class="col-25">URL</div>
                    <div class="col-75">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="url"/>
                            </xsl:attribute>
                            <xsl:value-of select="displayLabel"/>
                        </a>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="identifier[@type = 'domain']">
                <div class="row">
                    <div class="col-25">Domain</div>
                    <div class="col-75">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="email">
                <div class="row">
                    <div class="col-25">Email</div>
                    <div class="col-75">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>mailto:</xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </a>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="address">
                <xsl:for-each select="postOfficeBox">
                    <div class="row">
                        <div class="col-25">P.O. box</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="street">
                    <div class="row">
                        <div class="col-25">Street</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="postcode">
                    <div class="row">
                        <div class="col-25">Postal code</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="place">
                    <div class="row">
                        <div class="col-25">Place</div>
                        <div class="col-75">
                            <xsl:for-each select="actionLinks/read">
                                <xsl:value-of select="url"/>
                            </xsl:for-each>
                        </div>
                    </div>
                </xsl:for-each>
                <xsl:for-each select="country">
                    <div class="row">
                        <div class="col-25">Country</div>
                        <div class="col-75">
                            <xsl:value-of select="."/>
                        </div>
                    </div>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="point">
                <div class="row">
                    <div class="col-25">Latitude</div>
                    <div class="col-75">
                        <xsl:value-of select="latitude"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-25">Longitude</div>
                    <div class="col-75">
                        <xsl:value-of select="longitude"/>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="summary[@lang = 'swe']">
                <div class="row">
                    <div class="col-25">Summary in Swedish</div>
                    <div class="col-75">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="summary[@lang = 'eng']">
                <div class="row">
                    <div class="col-25">Summary in English</div>
                    <div class="col-75">
                        <xsl:value-of select="."/>
                    </div>
                </div>
            </xsl:for-each>
            <xsl:for-each select="recordInfo">
                <div class="row">
                    <div class="col-25">Alvin ID</div>
                    <div class="col-75">
                        <xsl:value-of select="type/linkedRecordId"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="id"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-25">Record created</div>
                    <div class="col-75">
                        <xsl:value-of select="tsCreated"/>
                    </div>
                </div>
                <div class="row">
                    <xsl:for-each select="updated[last()]">
                        <div class="col-25">Record last updated</div>
                        <div class="col-75">
                            <xsl:value-of select="tsUpdated"/>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:for-each>
            <div class="row">
                <xsl:for-each select="../../actionLinks/read">
                    <div class="col-25">Source data</div>
                    <div class="col-75">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="url"/>
                            </xsl:attribute>
                            <xsl:value-of select="url"/>
                        </a>
                    </div>
                </xsl:for-each>
            </div>
        </div>
        <div id="Related" class="tabcontent">
            <xsl:choose>
                <xsl:when test="count(//place) = 0">
                    <div class="row">
                        <div class="col-25">Place</div>
                        <div class="col-75">No related place</div>
                    </div>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//place">
                        <div class="row">
                            <div class="col-25">Place</div>
                            <div class="col-75">
                                <xsl:for-each select="actionLinks/read">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="url"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="url"/>
                                    </a>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
</xsl:stylesheet>
