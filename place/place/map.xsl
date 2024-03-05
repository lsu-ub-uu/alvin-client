<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" encoding="UTF-8" omit-xml-declaration="yes"
    media-type="text/html"/>
  <xsl:template match="/">
    <xsl:apply-templates select="place"/>
  </xsl:template>
  <xsl:template match="place">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html lang="en">
      <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
        <link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css"/>
        <meta name="robots" content="index, follow"/>
        <meta name="DC.Publisher" content="Uppsala universitet"/>
        <meta name="keywords" content="Alvin, kulturarv, digitala samlingar, databaser, bibliotek"/>
        <meta name="description"
          content="Alvin - nordisk plattform för bevarande och tillgängliggörande av digitaliserat kulturarv"/>
        <meta name="DC.Creator.PersonalName" content="UUB Alvin support"/>
        <meta name="internal-robots" content="noindex"/>
        <meta name="siteName" content="Alvin"/>
        <meta name="creator" content="UUB Alvin support"/>
        <link href="../css/v2-aggregated-css-base.css" rel="stylesheet" type="text/css"/>
        <link href="../css/v2-aggregated-css-modules.css" rel="stylesheet" type="text/css"/>
        <link href="../css/v2-aggregated-css-post.css" rel="stylesheet" type="text/css"/>
        <link href="../css/v2-aggregated-css-media-queries.css" rel="stylesheet" type="text/css"/>
        <link href="../css/css-custom-site.css" rel="stylesheet" type="text/css"/>
        <link href="../css/css-custom-site-theme-alvin.css" rel="stylesheet" type="text/css"/>
        <link href="../css/alvin.css" rel="stylesheet" type="text/css"/>
        <link rel="shortcut icon" href="../img/favicon.ico" type="image/x-icon"/>
        <link rel="icon" href="../img/favicon.ico" type="image/x-icon"/>
        <link rel="icon" type="image/png" href="../img/android-chrome-192x192.png"/>
        <link rel="apple-touch-icon" href="../img/apple-touch-icon.png"/>
        <title>
          <xsl:text>Alvin - </xsl:text>
          <xsl:value-of select="authority/name/geographic"/>
        </title>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <script src="../js/ol.js"/>
        <script>
          var map;
          var mapLat = <xsl:value-of select="point/latitude"/>;
          var mapLng = <xsl:value-of select="point/longitude"/>;
          var mapDefaultZoom = 10;
          
          function initialize_map() {
            map = new ol.Map({
              target: "map",
              layers: [
                  new ol.layer.Tile({
                      source: new ol.source.OSM({
                            url: "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png"
                      })
                  })
              ],
              view: new ol.View({
                  center: ol.proj.fromLonLat([mapLng, mapLat]),
                  zoom: mapDefaultZoom
              })
            });
          }
      
          function add_map_point(lat, lng) {
            var vectorLayer = new ol.layer.Vector({
              source:new ol.source.Vector({
                features: [new ol.Feature({
                      geometry: new ol.geom.Point(ol.proj.transform([parseFloat(lng), parseFloat(lat)], 'EPSG:4326', 'EPSG:3857')),
                  })]
              }),
              style: new ol.style.Style({
                image: new ol.style.Icon({
                  anchor: [0.5, 0.5],
                  anchorXUnits: "fraction",
                  anchorYUnits: "fraction",
                  src: "https://upload.wikimedia.org/wikipedia/commons/e/ec/RedDot.svg"
                })
              })
            });
      
            map.addLayer(vectorLayer); 
          }
      </script>
      </head>
      <body class="custom-site not-centralised" id="top">
        <xsl:attribute name="onload">initialize_map(); add_map_point(<xsl:value-of
            select="point/latitude"/>, <xsl:value-of select="point/longitude"/>);</xsl:attribute>
        <div class="main-wrapper">
          <div class="skip-to-content">
            <a class="is-visually-hidden is-show-on-focus btn-skip btn" href="#maincontent">Hoppa
              till huvudinnehållet</a>
          </div>
          <header class="header-element">
            <div class="container top-content clearfix">
              <div class="logo-wrap">
                <a href="start.html" title="Alvin - Digitalt kulturarv" class="logo-link">
                  <img src="../img/alvinlogo.png" alt="Alvin logo" class="logo"/>
                </a>
              </div>
              <div class="searchForm" aria-label="Sök i Alvin" role="search">
                <form class="search"
                  action="https://www.alvin-portal.org/alvin/resultList.jsf?faces-redirect=true&amp;includeViewParams=true&amp;searchType=EXTENDED">
                  <div class="search-group flex">
                    <label for="mainSearchField" class="is-visually-hidden">Sök</label>
                    <div id="js-main-search-complete-output" class="search-complete-output">
                      <div class="autocomplete__wrapper search-progressive-input">
                        <input id="mainSearchField"
                          class="autocomplete__input autocomplete__input--default" name="query"
                          type="text" placeholder="Sök i Alvin"/>
                      </div>
                    </div>
                    <input type="submit" class="btn btn-search submit-search" value="Sök"/>
                  </div>
                </form>
              </div>
              <div class="responsive-menu-container-bottom">
                <div class="sub">Digitalt kulturarv</div>
                <nav aria-label="Huvudmeny" class="top-nav-wrap container">
                  <ul class="top-nav first-level is-uppercase clearfix">
                    <li class="first">
                      <a href="start.html"> Start </a>
                    </li>
                    <li class="">
                      <a href="medlemmar.html"> Medlemmar </a>
                    </li>
                    <li class="">
                      <a href="kontakt.html"> Kontakt </a>
                    </li>
                    <li class="">
                      <a href="webbplatskarta.html"> Webbplatskarta </a>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
            <div class="mobile-search-container" aria-label="Sök i Alvin" role="search">
              <form class="mobile-search" id="mobile-search-form"
                action="https://www.alvin-portal.org/alvin/resultList.jsf?faces-redirect=true&amp;includeViewParams=true&amp;searchType=EXTENDED">
                <div class="search-group flex justify-content-end">
                  <label for="mainSearchFieldMobile" class="is-visually-hidden">Sök</label>
                  <div class="textfield search-complete-output-mobile"
                    style="display: block; width: initial;">
                    <div class="autocomplete__wrapper">
                      <input autocomplete="off"
                        class="autocomplete__input autocomplete__input--default"
                        id="mainSearchFieldMobile" name="query" placeholder="Sök i Alvin"
                        type="text"/>
                    </div>
                  </div>
                  <input type="submit" class="submit-icon submit-search" value="" aria-label="Sök"/>
                </div>
              </form>
            </div>
            <script>
              /* When the user clicks on the button,
              toggle between hiding and showing the dropdown content */
              function showMenu() {
              document.getElementById("mobileMenu").classList.toggle("show");
              }
              // Close the dropdown menu if the user clicks outside of it
              window.onclick = function(event) {
              if (!event.target.matches('.dropbtn')) {
              var dropdowns = document.getElementsByClassName("dropdown-content");
              var i;
              for (i = 0; i > dropdowns.length; i++) {
              var openDropdown = dropdowns[i];
              if (openDropdown.classList.contains('show')) {
              openDropdown.classList.remove('show');
              }
              }
              }
              } 
            </script>
            <div
              class="local-nav-mobile-header align-items-center flex-row local-nav-mobile-static dropdown">
              <button id="local-nav-mobile-button" class="local-nav-mobile-icon dropbtn"
                aria-controls="mobileMenu" aria-expanded="false" aria-label="Huvudmeny"
                onclick="showMenu()"> </button>
              <span class="current-page is-berling"> Alvin - digitalt kulturarv</span>
            </div>
            <nav id="mobileMenu" aria-label="Huvudmeny" class="local-nav-mobile">
              <ul class="menuLevel0">
                <li><a href="om-alvin.html">Om Alvin</a></li>
                <li><a href="soktips.html">Söktips</a></li>
                <li><a href="upphovsratt.html">Upphovsrätt</a></li>
                <li><a href="medlemmar.html">Medlemmar</a></li>
                <li><a href="kontakt.html">Kontakt</a></li>
                <li><a href="webbplatskarta.html">Webbplatskarta</a></li>
              </ul>
            </nav>
          </header>
          <div class="l-main-container clearfix main-wrapper">
            <div class="page-content container with-menu">
              <div class="l-top-container flex-row">
                <div class="breadcrumbs no-print">
                  <a href="start.html"> Start </a>
                  <span><xsl:text> </xsl:text><xsl:value-of select="authority/name/geographic"/></span>
                </div>
                <div class="page-tools-top clearfix">
                  <div class="page-tool language">
                    <a href="../en/place.html" class="language en" lang="en">
                      <span class="language-text"> English </span>
                    </a>
                    <a href="../no/place.html" class="language no" lang="no">
                      <span class="language-text"> Norsk </span>
                    </a>
                    <a href="place.html" class="language sv" lang="sv">
                      <span class="language-text"> Svenska </span>
                    </a>
                  </div>
                </div>
              </div>
              <div class="l-left-nav-wrap clearfix">
                <nav class="left-nav clearfix">
                  <h2 class="left-nav-heading">
                    <a class="left-nav-heading-unskew" style="text-transform:lowercase" href="">
                      <xsl:text>alvin-place:</xsl:text>
                      <xsl:value-of select="recordInfo/id"/>
                    </a>
                  </h2>
                </nav>
              </div>
              <div class="l-article-wrap">
                <div id="maincontent">
                  <div class="main-content">
                    <div id="xp1" class="rs_addtools rs_splitbutton rs_preserve rs_skip container"/>
                    <div id="readspeaker-content">
                      <!-- index_start -->
                      <article id="article_component_56_2" class="article simple">
                        <h1>
                          <xsl:value-of select="authority/name/geographic"/>
                        </h1>
                        <div class="articleText" id="articleText_component_56_2">
                          <p>
                            <div style="display: flex; align-items: center;"><img
                                src="../img/place.svg"
                                style="vertical-align:middle; width:25px;height:25px"/>
                              <span style="vertical-align:middle;margin-left:10px"
                              >(Plats)</span></div>
                          </p>
                          <xsl:for-each select="variant"> <xsl:if test="position() = 1">
                              <p>
                                <strong>Alternativa namnformer</strong><br/>
                                <xsl:for-each select="name">
                                  <xsl:value-of select="geographic"
                                    /><xsl:text> (</xsl:text><xsl:value-of select="../@lang"
                                  /><xsl:text>)</xsl:text>
                                </xsl:for-each>
                                <xsl:for-each select="../variant[position() &gt; 1]/name">
                                  <br/>
                                  <xsl:value-of select="geographic"
                                  /><xsl:text> (</xsl:text><xsl:value-of select="../@lang"
                                  /><xsl:text>)</xsl:text>
                                  <br/>
                                </xsl:for-each>
                              </p>
                            </xsl:if> </xsl:for-each>
                          <xsl:for-each select="countryCode">
                            <strong>Land</strong><br/>
                            <p>
                              <xsl:value-of select="."/>
                            </p>
                          </xsl:for-each>
                          <xsl:for-each select="point">
                            <xsl:for-each select="latitude">
                              <p>
                                <strong>Latitud</strong><br/>
                                <xsl:value-of select="."/>
                              </p>
                            </xsl:for-each>
                            <xsl:for-each select="longitude">
                              <p>
                                <strong>Longitud</strong><br/>
                                <xsl:value-of select="."/>
                              </p>
                            </xsl:for-each>
                          </xsl:for-each>
                          <xsl:for-each select="recordInfo/id">
                            <strong>ID</strong><br/>
                            <p>
                              <xsl:text>alvin-place:</xsl:text>
                              <xsl:value-of select="."/>
                            </p>
                          </xsl:for-each>
                          <strong>Karta</strong><br/>
                          <div id="map" style="width: 100%; height: 500px"/>
                        </div>
                      </article>
                      <!-- index_stop -->
                      <div class="container page-tools-bottom page-tools">
                        <div class="page-tool print">
                          <span class="print-icon">
                            <a accesskey="P" href="" class="js-print-page" onclick="window.print()"
                              >Skriv ut</a>
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <button onclick="topFunction()" id="scrollToTop" title="Gå till toppen"/>
        <script>
          // Get the button
          let topbutton = document.getElementById("scrollToTop");
          
          // When the user scrolls down 20px from the top of the document, show the button
          window.onscroll = function() {scrollFunction()};
          
          function scrollFunction() {
          if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
          topbutton.style.display = "block";
          } else {
          topbutton.style.display = "none";
          }
          }
          
          // When the user clicks on the button, scroll to the top of the document
          function topFunction() {
          document.body.scrollTop = 0;
          document.documentElement.scrollTop = 0;
          }
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
