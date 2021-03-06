<?xml version="1.0" encoding="utf-8"?>
<!--
    MINDMAPEXPORTFILTER html;htm Reveal.js presentation
    (c) by Janne Cederberg, 2014
    This file is licensed under the GPL.
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink">
  
  <xsl:output method="html" indent="yes" cdata-section-elements="body" />
  <xsl:strip-space elements="*" />

  <!-- xsl:template match="text(normalize-space()='')" / -->

  <!-- PREVENT DEFAULT OUTPUT (prevents whitespace between tags from leaking to output) -->
  <!-- xsl:template match="text()" mode="richtext">
    <xsl:value-of select="normalize-space()" />
  </xsl:template -->


<!-- MAIN -->

  <xsl:template match="map">
    <html>
    <head>
      <meta charset="utf-8" />
      <meta name="author" content="Janne Cederberg" />
      <title><xsl:value-of select="node/@TEXT" /></title>
      <meta name="apple-mobile-web-app-capable" content="yes" />
      <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
      <link rel="stylesheet" href="http://jannec.fi/lib/reveal.js/css/reveal.min.css" />
      <style type="text/css">code{white-space: pre;}</style>
      <link rel="stylesheet" href="http://jannec.fi/lib/reveal.js/css/theme/simple.css" id="theme" />
      <link rel="stylesheet" media="print" href="http://jannec.fi/lib/reveal.js/css/print/pdf.css" />
    </head>
    <body>
      <div class="reveal">
        <div class="slides">
          <xsl:apply-templates select="node" />
        </div>
      </div>

      <script src="http://jannec.fi/lib/reveal.js/lib/js/head.min.js"></script>
      <script src="http://jannec.fi/lib/reveal.js/js/reveal.min.js"></script>
      <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

      <script>
        // listat vaiheittaiseksi jQueryllä
        $('li').each(function(index) {
          $(this).attr('data-fragment-index', index);
          $(this).addClass('fragment');
        });
      </script>

      <script>
        // Full list of configuration options available here:
        // https://github.com/hakimel/reveal.js#configuration
        Reveal.initialize({
          controls: true,
          progress: true,
          history: true,
          center: true,
          theme: 'default', // available themes are in /css/theme
          transition: Reveal.getQueryHash().transition || 'default', // default/cube/page/concave/zoom/linear/fade/none

          // Optional libraries used to extend on reveal.js
          dependencies: [
            { src: 'http://jannec.fi/lib/reveal.js/lib/js/classList.js', condition: function() { return !document.body.classList; } },
            { src: 'http://jannec.fi/lib/reveal.js/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
            { src: 'http://jannec.fi/lib/reveal.js/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } },
            //{ src: 'http://jannec.fi/lib/reveal.js/plugin/search/search.js', async: true, condition: function() { return !!document.body.classList; }, }
            //{ src: 'http://jannec.fi/lib/reveal.js/plugin/remotes/remotes.js', async: true, condition: function() { return !!document.body.classList; } }
          ]});
      </script>
    </body>
    </html>
  </xsl:template>


<!-- BEGIN PARSERS -->


  <xsl:template match="node">
    <xsl:variable name="depth">
      <xsl:apply-templates select=".." mode="depthMeasurement"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$depth = 0">
        <section>
          <h1><xsl:value-of select="@TEXT"/></h1>
          <xsl:choose>
            <xsl:when test="richcontent">
              <xsl:call-template name="myrichcontent" />
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </section>
        <xsl:apply-templates select="node" />
      </xsl:when>
      <xsl:when test="$depth = 1 or $depth = 2">
        <xsl:text>&#xA;</xsl:text>
        <section>
          <xsl:call-template name="headingTag">
            <xsl:with-param name="level" select="$depth"/>
            <xsl:with-param name="heading" select="@TEXT"/>
          </xsl:call-template>
          <xsl:choose>
            <xsl:when test="richcontent">
              <xsl:call-template name="myrichcontent" />
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="$depth = 1">
              <xsl:apply-templates select="node" />
            </xsl:when>
            <xsl:otherwise>
              <ul><xsl:apply-templates select="node" /></ul>
            </xsl:otherwise>
          </xsl:choose>
        </section>
      </xsl:when>
      <xsl:when test="$depth > 2">
        <li>
          <xsl:choose>
            <xsl:when test="@LINK">
              <a href="{@LINK}"><xsl:value-of select="@TEXT" /></a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@TEXT" />
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="node">
              <ul><xsl:apply-templates select="node" /></ul>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="node" />
            </xsl:otherwise>
          </xsl:choose>
        </li>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>


  <xsl:template name="myrichcontent">
    <xsl:copy-of select="richcontent/html/body/child::*" />
  </xsl:template>

  <xsl:template match="richcontent/html/body" mode="richcontent">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template name="headingTag">
    <xsl:param name="level" select="'1'"/>
    <xsl:param name="heading" select="'Default Title'"/>
    <xsl:text disable-output-escaping="yes">&lt;h</xsl:text>
    <xsl:value-of select="$level" />
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    <xsl:value-of select="$heading"/>
    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
    <xsl:value-of select="$level" />
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  </xsl:template>

  <!-- NODE TAG DEPTH MEASUREMENT -->
  <xsl:template match="node" mode="depthMeasurement">
    <xsl:param name="depth" select=" '0' "/>
    <xsl:apply-templates select=".." mode="depthMeasurement">
      <xsl:with-param name="depth" select="$depth + 1"/>
    </xsl:apply-templates>
  </xsl:template>
        
  <!-- MAP TAG DEPTH MEASUREMENT -->
  <xsl:template match="map" mode="depthMeasurement">
    <xsl:param name="depth" select=" '0' "/>
    <xsl:value-of select="$depth"/>
  </xsl:template>
</xsl:stylesheet>
