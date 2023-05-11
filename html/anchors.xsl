<?xml version="1.0" encoding="utf-8"?>
<!--
	# Extract links from HTML and Netscape bookmark files.
	# Use in conjunction with &force-xml. Exposes some XPath via parameters and emits
	# TSV output.
!-->
<xsl:transform version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:dyn="http://exslt.org/dynamic"
	xmlns:str="http://exslt.org/strings"
	xmlns:func="http://exslt.org/functions"
	xmlns:xlink="https://www.w3.org/1999/xlink"
	xmlns:l="#local"
	xmlns="http://www.w3.org/1999/xhtml"
	extension-element-prefixes="exsl dyn func">

	<xsl:output method="text" encoding="utf-8" indent="no"/>
	<xsl:strip-space elements="*"/>

	<!-- RI Prefix -->
	<xsl:param name="SITE" select="'http://[]'"/>

	<!-- Format control. -->
	<xsl:param name="FS" select="'&#09;'"/>
	<xsl:param name="RS" select="'&#10;'"/>

	<xsl:variable name="EFS" select="str:encode-uri($FS, '')"/>
	<xsl:variable name="ERS" select="str:encode-uri($RS, '')"/>

	<!-- Tag constraints -->
	<xsl:param name="CONTEXT" select="'.'"/>
	<xsl:param name="TYPES" select="'//a|//*[@xlink:href]'"/>
	<xsl:param name="PREDICATE" select="'[node()]'"/>
	<xsl:param name="time-context" select="''"/>

	<xsl:variable name="SV" select="concat($FS, $RS)"/>

	<!-- Qualify relative links with SITE context. -->
	<func:function name="l:uri-qualify">
		<xsl:param name="string"/>
		<func:result>
			<xsl:choose>
				<xsl:when test="starts-with($string, '/')">
					<xsl:value-of select="concat($SITE, $string)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$string"/>
				</xsl:otherwise>
			</xsl:choose>
		</func:result>
	</func:function>

	<!-- Protect field separators. -->
	<func:function name="l:uri-guard">
		<!--
			# Limited to FS and RS as this intends to *only* guard the separators.
			# If further normalization is desired, it should be done so downstream.
		!-->
		<xsl:param name="string"/>
		<xsl:variable name="fields" select="str:replace($string, $FS, $EFS)"/>
		<xsl:variable name="records" select="str:replace($fields, $RS, $ERS)"/>

		<func:result>
			<xsl:value-of select="l:uri-qualify($records)"/>
		</func:result>
	</func:function>

	<func:function name="l:sequence">
		<xsl:param name="site"/>
		<xsl:param name="link"/>
		<xsl:param name="time-context"/>
		<xsl:param name="icon"/>
		<xsl:param name="title"/>

		<!-- Blank the separators for the non-URI fields. -->
		<func:result>
			<xsl:value-of select="l:uri-guard($link)"/>
			<xsl:value-of select="$FS"/>
			<xsl:value-of select="translate($time-context, $SV, '  ')"/>
			<xsl:value-of select="$FS"/>
			<xsl:value-of select="l:uri-guard($icon)"/>
			<xsl:value-of select="$FS"/>
			<xsl:value-of select="translate($title, $SV, '  ')"/>
			<xsl:value-of select="$RS"/>
		</func:result>
	</func:function>

	<xsl:template match="a|*[@xlink:href]">
		<xsl:variable name="r" select="(@HREF|@href|@xlink:href)[position()=1]"/>
		<xsl:variable name="t" select="(@ADDED_DATE|@added_date|@ADD_DATE|@add_date)[position()=1]"/>
		<xsl:variable name="i" select="(@ICON|@icon|@IMAGE|@image)[position()=1]"/>
		<xsl:variable name="n" select="./text()"/>

		<!-- Blank the separators for the non-URI fields. -->
		<xsl:value-of select="l:sequence($SITE, $r, $t, $i, $n)"/>
	</xsl:template>

	<xsl:template match="/*">
		<xsl:apply-templates select="dyn:evaluate(concat($CONTEXT, $TYPES, $PREDICATE))"/>
	</xsl:template>
</xsl:transform>
