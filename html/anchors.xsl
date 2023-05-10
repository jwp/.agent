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
	extension-element-prefixes="exsl dyn func">

	<xsl:output method="text" encoding="utf-8" indent="no"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="FS" select="'&#09;'"/>
	<xsl:param name="RS" select="'&#10;'"/>
	<xsl:param name="CONTEXT" select="'.'"/>
	<xsl:param name="TYPES" select="'//a|//*[@xlink:href]'"/>
	<xsl:param name="PREDICATE" select="'[node()]'"/>
	<xsl:param name="time-context" select="''"/>

	<xsl:variable name="SV" select="concat($FS, $RS)"/>

	<func:function name="l:uri-guard">
		<xsl:param name="string"/>
		<xsl:variable name="fields" select="str:replace($string, $FS, '%09')"/>
		<xsl:variable name="records" select="str:replace($fields, $RS, '%0A')"/>

		<func:result>
			<xsl:value-of select="$records"/>
		</func:result>
	</func:function>

	<xsl:template match="a|*[@xlink:href]">
		<xsl:variable name="r" select="(@HREF|@href|@xlink:href)[position()=1]"/>
		<xsl:variable name="t" select="(@ADDED_DATE|@added_date|@ADD_DATE|@add_date)[position()=1]"/>
		<xsl:variable name="i" select="(@ICON|@icon|@IMAGE|@image)[position()=1]"/>
		<xsl:variable name="n" select="./text()"/>

		<!-- Blank the separators for the non-URI fields. -->
		<xsl:value-of select="l:uri-guard($r)"/>
		<xsl:value-of select="$FS"/>
		<xsl:value-of select="translate($t, $SV, '  ')"/>
		<xsl:value-of select="$FS"/>
		<xsl:value-of select="l:uri-guard($i)"/>
		<xsl:value-of select="$FS"/>
		<xsl:value-of select="translate($n, $SV, '  ')"/>
		<xsl:value-of select="$RS"/>
	</xsl:template>

	<xsl:template match="/*">
		<xsl:apply-templates select="dyn:evaluate(concat($CONTEXT, $TYPES, $PREDICATE))"/>
	</xsl:template>
</xsl:transform>
