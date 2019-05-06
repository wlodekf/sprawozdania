<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/" 
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaWZlotych"

	xmlns:jin="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaStruktury"
>
	
<xsl:include href="common.xsl"/>
<xsl:include href="func.xsl"/>
<xsl:include href="jin.xsl"/>
<xsl:include href="iddpd.xsl"/>

<xsl:template match="/">

<html lang="pl">
<head>
	<title><xsl:value-of select="//dtsf:NazwaFirmy"/> - Sprawozdanie Finansowe za <xsl:value-of select="substring(//dtsf:DataOd, 1, 4)"/></title>
	<meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>

<body>
	<xsl:choose>
		<xsl:when test="$root = ''">
			<section class="hdr">
				<div class="tyt tyt1">SPRAWOZDANIE FINANSOWE</div>
				<div class="cen">za okres<br/><xsl:value-of select="//dtsf:OkresOd"/> - <xsl:value-of select="//dtsf:OkresDo"/></div>
				<div class="cen"><br/><small>data sporządzenia<br/><xsl:value-of select="//dtsf:DataSporzadzenia"/></small></div>
			</section>
			<xsl:apply-templates select="tns:JednostkaInna"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>Root: <xsl:value-of select="$root"/></xsl:message>
			<div class="phe"><xsl:value-of select="//dtsf:NazwaFirmy"/> - Sprawozdanie Finansowe za <xsl:value-of select="substring(//dtsf:DataOd, 1, 4)"/></div>
			<xsl:apply-templates select="tns:JednostkaInna/*[local-name() = $root]"/>			
		</xsl:otherwise>
	</xsl:choose>
</body>

</html>

</xsl:template>

<xsl:template match="tns:JednostkaInna">
	<xsl:apply-templates select="tns:WprowadzenieDoSprawozdaniaFinansowego"/>
	<xsl:apply-templates select="tns:Bilans"/>
	<xsl:apply-templates select="tns:RZiS"/>
	<xsl:apply-templates select="tns:ZestZmianWKapitale"/>
	<xsl:apply-templates select="tns:RachPrzeplywow"/>
	<xsl:apply-templates select="tns:DodatkoweInformacjeIObjasnieniaJednstkaInna"/>
</xsl:template>

<xsl:template match="tns:P_1">
	<div class="wpr">
		<h1>1. Dane identyfikujące jednostkę</h1>
		<table cellspacing="0" cellpadding="0" class="ident">
			<xsl:apply-templates select="tns:P_1A"/>
			<xsl:apply-templates select="tns:P_1B"/>
			<xsl:apply-templates select="tns:P_1C"/>
			<xsl:apply-templates select="tns:P_1D"/>
		</table>
	</div>
</xsl:template>

<xsl:template match="tns:P_1A">
	<tr><td class="tl"><b>Nazwa firmy</b></td><td class="big"><xsl:value-of select="dtsf:NazwaFirmy"/></td></tr>
	<xsl:apply-templates select="dtsf:Siedziba"/>
</xsl:template>

<xsl:template match="tns:P_1B">
	<tr><td class="ts" colspan="2"><b>Adres</b></td></tr>
	<xsl:apply-templates select="dtsf:Adres"/>
</xsl:template>

<xsl:template match="tns:P_1C">
	<tr><td class="ts" colspan="2"><b>Podstawowy przedmiot działalności jednostki</b></td></tr>
	<tr>
		<td>KodPKD</td>
		<td>
			<xsl:for-each select="dtsf:KodPKD">
				<xsl:if test="position() > 1"><br/></xsl:if>
				<xsl:apply-templates/> - <xsl:call-template name="nazwa-pkd"/>
			</xsl:for-each>
		</td>
	</tr>
</xsl:template>
	
<xsl:template match="tns:P_1D">
	<tr><td class="ts" colspan="2"><b>Identyfikator podmiotu składającego sprawozdanie finansowe</b></td></tr>
	<xsl:apply-templates select="dtsf:NIP"/>
	<xsl:apply-templates select="dtsf:KRS"/>
</xsl:template>
	
<xsl:template match="tns:P_3">
	<div class="wpr">
		<h1>3. Wskazanie okresu objętego sprawozdaniem finansowym</h1>
		<xsl:value-of select="dtsf:DataOd"/> - 
		<xsl:value-of select="dtsf:DataDo"/>
	</div>
</xsl:template>

<xsl:template match="tns:P_4">
	<div class="wpr">
		<h1>4. Dane łączne</h1>
		<div>Wskazanie, że sprawozdanie finansowe zawiera dane łączne, jeżeli w skład jednostki wchodzą wewnętrzne jednostki organizacyjne sporządzające samodzielne sprawozdania finansowe:</div>
		<br/>
		<b>
		<xsl:choose>
			<xsl:when test="text() = 'true'">
				Sprawozdanie finansowe zawiera dane łączne.
			</xsl:when>
			<xsl:when test="text() = 'false'">
				Sprawozdanie nie zawiera danych łącznych.
			</xsl:when>
		</xsl:choose>
		</b>
	</div>
</xsl:template>

<xsl:template match="tns:P_5">
	<div class="wpr">
		<h1>5. Założenie kontynuacji działalności</h1>
		<xsl:apply-templates select="tns:P_5A"/>
		<xsl:apply-templates select="tns:P_5B"/>
	</div>
</xsl:template>

<xsl:template match="tns:P_5A">
	<xsl:choose>
		<xsl:when test="text() = 'true'">
			<p>Sprawozdanie finansowe zostało sporządzone przy założeniu kontynuowania działalności gospodarczej przez jednostkę w dającej się przewidzieć przyszłości.</p>
		</xsl:when>
		<xsl:when test="text() = 'false'">
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tns:P_5B">
	<xsl:choose>
		<xsl:when test="text() = 'true'">
			<p>Nie istnieją okoliczności wskazujące na zagrożenie kontynuowania przez nią działalności.</p>
		</xsl:when>
		<xsl:when test="text() = 'false'">
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tns:P_7">
	<div class="wpr">
		<h1>7. Zasady (polityka) rachunkowości</h1>
	
		<div class="wpr2">
			<h2>A. Omówienie przyjętych zasad (polityki) rachunkowości, w zakresie w jakim ustawa pozostawia jednostce prawo wyboru, w tym:</h2>
			<xsl:for-each select="tns:P_7A">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>B. Omówienie metod wyceny aktywów i pasywów (także amortyzacji):</h2>
			<xsl:for-each select="tns:P_7B">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>C. Omówienie zasad ustalenia wyniku finansowego:</h2>
			<xsl:for-each select="tns:P_7C">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>D. Sposób sporządzenia sprawozdania finansowego:</h2>
			<xsl:for-each select="tns:P_7D">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
	</div>
</xsl:template>

<xsl:template match="tns:P_8">
	<div>
		<h1><xsl:value-of select="dtsf:NazwaPozycji"/></h1>
	
		<xsl:for-each select="dtsf:Opis">
			<xsl:call-template name="print-paras"/>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match="tns:Bilans">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
		<xsl:apply-templates select="jin:Aktywa"/>
		<xsl:apply-templates select="jin:Pasywa"/>
	</section>	
</xsl:template>

<xsl:template match="tns:RZiS">
	<xsl:apply-templates select="jin:RZiSKalk"/>
	<xsl:apply-templates select="jin:RZiSPor"/>
</xsl:template>

</xsl:stylesheet>
