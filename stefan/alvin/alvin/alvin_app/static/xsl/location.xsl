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
        <xsl:variable name="tileLayer">L.tileLayer(&apos;https://tile.openstreetmap.org/{{z}}/{{x}}/{{y}}.png&apos;, {{attribution: '&amp;copy; &lt;a href=&quot;http://www.openstreetmap.org/copyright&quot;&gt;OpenStreetMap&lt;/a&gt;'}}).addTo(map);</xsl:variable>
        <h1>
            <xsl:value-of select="authority[1]/name/namePart[@type = 'corporateName']"/>
        </h1>
        <p><i class="fa fa-university"><xsl:text> </xsl:text></i> Archival institution</p>
        <xsl:for-each select="summary[@lang = 'swe']">
            <p>
                <xsl:value-of select="." disable-output-escaping="yes"/>
            </p>
        </xsl:for-each>
        <div class="tab">
            <button class="tablinks" onclick="openCity(event, 'Overview')" id="defaultOpen"
                >Overview</button>
            <button class="tablinks" onclick="openCity(event, 'All')">All metadata</button>
            <button class="tablinks" onclick="openCity(event, 'Related')">Related</button>
        </div>
        <div id="Overview" class="tabcontent">
            <xsl:apply-templates select="electronicLocator"></xsl:apply-templates>
            <xsl:apply-templates select="email"></xsl:apply-templates>
            <xsl:apply-templates select="address"></xsl:apply-templates>
            <xsl:apply-templates select="point" mode="directions"></xsl:apply-templates>
            <xsl:apply-templates select="recordInfo" mode="ID"></xsl:apply-templates>
        </div>
        <div id="All" class="tabcontent">
            <xsl:apply-templates select="authority"></xsl:apply-templates>
            <xsl:apply-templates select="organisationInfo"></xsl:apply-templates>
            <xsl:apply-templates select="electronicLocator"></xsl:apply-templates>
            <xsl:apply-templates select="identifier"></xsl:apply-templates>
            <xsl:apply-templates select="email"></xsl:apply-templates>
            <xsl:apply-templates select="address"></xsl:apply-templates>
            <xsl:apply-templates select="point" mode="coodinates"></xsl:apply-templates>
            <xsl:apply-templates select="summary"></xsl:apply-templates>
            <xsl:apply-templates select="recordInfo" mode="dates"></xsl:apply-templates>
            <xsl:apply-templates select="../../actionLinks"></xsl:apply-templates>                       
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
                                            <xsl:text>/alvin-place/</xsl:text>
                                            <xsl:value-of select="substring-after(url, 'place/')"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="substring-after(url, 'record/')"/>
                                    </a>
                                </xsl:for-each>
                            </div>
                        </div>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <xsl:for-each select="point">
            <div id="map">
                <xsl:text> </xsl:text>
            </div>
<script>
var map = L.map('map').setView([<xsl:value-of select="latitude"/>, <xsl:value-of select="longitude"/>], 3);
<xsl:value-of select="$tileLayer" disable-output-escaping="yes"/>
L.marker([<xsl:value-of select="latitude"/>, <xsl:value-of select="longitude"/>]).addTo(map);
</script>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="authority">
        <xsl:for-each select="name">
            <div class="row">
                <div class="col-25">
                    <xsl:text>Name [</xsl:text><xsl:value-of select="../@lang"/><xsl:text>]</xsl:text>
                </div>              
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
    </xsl:template>
    <xsl:template match="organisationInfo">
        <xsl:for-each select="descriptor">
            <div class="row">
                <div class="col-25">Type of institution</div>
                <div class="col-75">
                    <xsl:value-of select="."/>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="electronicLocator">
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
    </xsl:template>
    <xsl:template match="identifier">
        <div class="row">
            <div class="col-25">
                <xsl:text>Identifier [</xsl:text>
                <xsl:value-of select="@type"/>
                <xsl:text>]</xsl:text>
            </div>
            <div class="col-75">
                <xsl:value-of select="."/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="email">
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
    </xsl:template>
    <xsl:template match="address">
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
        <xsl:apply-templates select="place" mode="link"></xsl:apply-templates>
        <xsl:apply-templates select="country"></xsl:apply-templates>       
    </xsl:template>
    <xsl:template match="point" mode="directions">
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
    </xsl:template>
    <xsl:template match="point" mode="coodinates">
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
    </xsl:template>
    <xsl:template match="summary">
        <div class="row">
            <div class="col-25">
                <xsl:text>Summary [</xsl:text>
                <xsl:value-of select="@lang"/>
                <xsl:text>]</xsl:text>
            </div>          
            <div class="col-75" style="white-space: pre-line;">
                <xsl:value-of select="." disable-output-escaping="yes"/>              
            </div>
        </div>
    </xsl:template>
    <xsl:template match="recordInfo" mode="ID">
        <div class="row">
            <div class="col-25">Alvin ID</div>
            <div class="col-75">
                <xsl:value-of select="type/linkedRecordId"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="id"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="recordInfo" mode="dates">
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
    </xsl:template>
    <xsl:template match="actionLinks">
        <xsl:for-each select="read">
            <div class="row">
                <div class="col-25">Source data</div>
                <div class="col-75">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="url"/>
                        </xsl:attribute>
                        <xsl:value-of select="url"/>
                    </a>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="place" mode="link">
        <div class="row">
            <div class="col-25">Place</div>
            <div class="col-75">
                <xsl:for-each select="actionLinks/read">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:text>/alvin-place/</xsl:text>
                            <xsl:value-of select="substring-after(url, 'place/')"/>
                        </xsl:attribute>
                        <xsl:value-of select="substring-after(url, 'record/')"/>
                    </a>
                </xsl:for-each>
            </div>
        </div>        
    </xsl:template>
    <xsl:template match="country">
        <div class="row">
            <div class="col-25">Country</div>
            <div class="col-75">
                <xsl:value-of select="."/>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
