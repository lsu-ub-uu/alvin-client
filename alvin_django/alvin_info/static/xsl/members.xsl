<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="lang"/>
    <xsl:template match="/">
        <div class="main">
            <xsl:apply-templates select="dataList/data"/>
        </div>
    </xsl:template>
    <xsl:template match="data">
        <h2 id="consortium" class="text-3xl md:text-4xl font-bold pt-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>The Alvin consortium</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Alvin-konsortiet</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Alvinkonsortiet</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <h3 class="text-2xl font-bold pt-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>The founding members and steering group of Alvin</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Alvins opprinnelige medlemmer og styringsgruppe</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Alvins ursprungliga medlemmar och styrgrupp</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <ul class="py-2 list-disc list-inside">
            <xsl:for-each select="record/data/location">
                <xsl:sort select="authority/name/namePart" lang="sv" order="descending"/>
                <xsl:if test="organisationInfo/descriptor = 'consortium'">
                    <xsl:call-template name="list"></xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </ul>
        <h2 id="members" class="text-3xl md:text-4xl font-bold pt-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>Other members of Alvin</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Andre medlemmer av Alvin</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Övriga medlemmar i Alvin</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <h3 class="text-2xl font-bold pt-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>Institutions using Alvin on a regular basis</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Institusjoner som bruker Alvin regelmessig</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Institutioner som använder Alvin regelbundet</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <ul class="py-2 list-disc list-inside">
            <xsl:for-each select="record/data/location">
                <xsl:sort select="authority/name/namePart" lang="sv"/>
                <xsl:if test="organisationInfo/descriptor = 'member'">
                    <xsl:call-template name="list"></xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </ul>
        <h2 id="other" class="text-3xl md:text-4xl font-bold pt-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>Other institutions</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Andre institusjoner</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Andra institutioner</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <h3 class="text-2xl font-bold pt-4">
            <xsl:choose>
                <xsl:when test="$lang = 'en'">
                    <xsl:text>Subordinate units to members or institutions with material related to projects</xsl:text>
                </xsl:when>
                <xsl:when test="$lang = 'no'">
                    <xsl:text>Underordnede enheter for medlemmer eller institusjoner med materialer relatert til prosjekter</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Underordnade enheter till medlemmar eller institutioner med material relaterat till projekt</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <ul class="py-2 list-disc list-inside">
            <xsl:for-each select="record/data/location">
                <xsl:sort select="authority/name/namePart" lang="sv"/>
                <xsl:if test="organisationInfo/descriptor = 'other'">
                    <xsl:call-template name="list"></xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </ul>
    </xsl:template>
    <xsl:template name="flag">
        <xsl:choose>
            <xsl:when test="../address/country = 'sw'">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 480"
                    class="pr-2 min-w-10 max-w-10" height="24px">
                    <title>flag-sv</title>
                    <path fill="#005293" d="M0 0h640v480H0z"/>
                    <path fill="#fecb00" d="M176 0v192H0v96h176v192h96V288h368v-96H272V0z"/>
                </svg>
            </xsl:when>
            <xsl:when test="../address/country = 'no'">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 480"
                    class="pr-2 min-w-10 max-w-10" height="24px">
                    <title>flag-no</title>
                    <path fill="#ed2939" d="M0 0h640v480H0z"/>
                    <path fill="#fff" d="M180 0h120v480H180z"/>
                    <path fill="#fff" d="M0 180h640v120H0z"/>
                    <path fill="#002664" d="M210 0h60v480h-60z"/>
                    <path fill="#002664" d="M0 210h640v60H0z"/>
                </svg>
            </xsl:when>
            <xsl:when test="../address/country = 'it'">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 480"
                    class="pr-2 min-w-10 max-w-10" height="24px">
                    <title>flag-it</title>
                    <g fill-rule="evenodd" stroke-width="1pt">
                        <path fill="#fff" d="M0 0h640v480H0z"/>
                        <path fill="#009246" d="M0 0h213.3v480H0z"/>
                        <path fill="#ce2b37" d="M426.7 0H640v480H426.7z"/>
                    </g>
                </svg>
            </xsl:when>
            <xsl:otherwise>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 480"
                    class="pr-2 min-w-10 max-w-10" height="24px">
                    <title>flag-xx</title>
                    <path fill="#fff" fill-rule="evenodd" stroke="#adb5bd" stroke-width="1.1"
                        d="M.5.5h638.9v478.9H.5z"/>
                    <path fill="none" stroke="#adb5bd" stroke-width="1.1"
                        d="m.5.5 639 479m0-479-639 479"/>
                </svg>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="list">
        <xsl:variable name="eng">
            <xsl:if test="authority[@lang = 'eng']">yes</xsl:if>
        </xsl:variable>
        <xsl:variable name="nor">
            <xsl:if test="authority[@lang = 'nor']">yes</xsl:if>
        </xsl:variable>
        <xsl:if test="$lang = 'sv'">
            <xsl:for-each select="authority[1]">
                <li class="flex py-1">
                    <xsl:call-template name="flag"/>
                    <a class="text-blue-800 dark:text-blue-200 underline">
                        <xsl:attribute name="href">
                            <xsl:text>/alvin-location/</xsl:text>
                            <xsl:value-of select="../recordInfo/id"/>
                        </xsl:attribute>
                        <xsl:value-of select="name/namePart[1]"/>
                    </a>
                </li>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$lang = 'en'">
            <xsl:choose>
                <xsl:when test="$eng = 'yes'">
                    <xsl:for-each select="authority[@lang = 'eng']">
                        <li class="flex py-1">
                            <xsl:call-template name="flag"/>
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:text>/alvin-location/</xsl:text>
                                    <xsl:value-of select="../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="name/namePart[1]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="authority[1]">
                        <li class="flex py-1">
                            <xsl:call-template name="flag"/>
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:text>/alvin-location/</xsl:text>
                                    <xsl:value-of select="../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="name/namePart[1]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$lang = 'no'">
            <xsl:choose>
                <xsl:when test="$nor = 'yes'">
                    <xsl:for-each select="authority[@lang = 'nor']">
                        <li class="flex py-1">
                            <xsl:call-template name="flag"/>
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:text>/alvin-location/</xsl:text>
                                    <xsl:value-of select="../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="name/namePart[1]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="authority[1]">
                        <li class="flex py-1">
                            <xsl:call-template name="flag"/>
                            <a class="text-blue-800 dark:text-blue-200 underline">
                                <xsl:attribute name="href">
                                    <xsl:text>/alvin-location/</xsl:text>
                                    <xsl:value-of select="../recordInfo/id"/>
                                </xsl:attribute>
                                <xsl:value-of select="name/namePart[1]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>          
    </xsl:template>
</xsl:stylesheet>
