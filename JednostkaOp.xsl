<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/" 
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaOrganizacjiPozarzadowejWZlotych"

	xmlns:jop="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaOpStruktury"
	xmlns:jin="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaStruktury"
>
	
<xsl:include href="common.xsl"/>
<xsl:include href="func.xsl"/>
<xsl:include href="jin.xsl"/>
<xsl:include href="jop.xsl"/>
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
			<xsl:apply-templates select="tns:JednostkaOp"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>Root: <xsl:value-of select="$root"/></xsl:message>
			<div class="phe"><xsl:value-of select="//dtsf:NazwaFirmy"/> - Sprawozdanie Finansowe za <xsl:value-of select="substring(//dtsf:DataOd, 1, 4)"/></div>
			<xsl:apply-templates select="tns:JednostkaOp/*[local-name() = $root]"/>			
		</xsl:otherwise>
	</xsl:choose>
	
</body>

</html>

</xsl:template>

<xsl:template match="tns:JednostkaOp">

	<xsl:apply-templates select="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaOp"/>
	<xsl:apply-templates select="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaInna"/>
		
	<xsl:apply-templates select="tns:BilansJednostkaOp"/>
	<xsl:apply-templates select="tns:BilansJednostkaInna"/>
	
	<xsl:apply-templates select="tns:RZiSJednostkaOp"/>
	<xsl:apply-templates select="tns:RZiSJednostkaInna"/>
	
	<xsl:apply-templates select="tns:ZestZmianWKapitaleJednostkaInna"/>
	<xsl:apply-templates select="tns:RachPrzeplywow"/>
	
	<xsl:apply-templates select="tns:InformacjaDodatkowaJednostkaOp"/>
	<xsl:apply-templates select="tns:DodatkoweInformacjeIObjasnieniaJednostkaInna"/>
</xsl:template>

<xsl:template match="tns:P_1">
	<div class="wpr">
		<h1>1. Dane identyfikujące jednostkę</h1>
		<table cellspacing="0" cellpadding="0" class="ident">
			<xsl:apply-templates select="tns:P_1A"/>
			<xsl:apply-templates select="tns:P_1B"/>
			<xsl:apply-templates select="tns:P_1C"/>
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
	<tr><td class="ts" colspan="2"><b>Numer we własciwym rejestrze sądowym albo ewidencji</b></td></tr>
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
		<h1>4. Założenie kontynuacji działalności</h1>
		<xsl:apply-templates select="tns:P_4A"/>
		<xsl:apply-templates select="tns:P_4B"/>
	</div>
</xsl:template>

<xsl:template match="tns:P_4A">
	<xsl:choose>
		<xsl:when test="text() = 'true'">
			<p>Sprawozdanie finansowe zostało sporządzone przy założeniu kontynuowania działalności gospodarczej przez jednostkę w dającej się przewidzieć przyszłości.</p>
		</xsl:when>
		<xsl:when test="text() = 'false'">
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tns:P_4B">
	<xsl:choose>
		<xsl:when test="text() = 'true'">
			<p>Nie istnieją okoliczności wskazujące na zagrożenie kontynuowania przez nią działalności.</p>
		</xsl:when>
		<xsl:when test="text() = 'false'">
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="tns:P_5">
	<div class="wpr">
		<h1>5. Zasady (polityka) rachunkowości</h1>
	
		<div class="wpr2">
			<h2>A. Omówienie przyjętych zasad (polityki) rachunkowości, w zakresie w jakim ustawa pozostawia jednostce prawo wyboru, w tym:</h2>
			<xsl:for-each select="tns:P_5A">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>B. metod wyceny aktywów i pasywów (także amortyzacji):</h2>
			<xsl:for-each select="tns:P_5B">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>C. ustalenia wyniku finansowego oraz sposobu sporządzenia sprawozdania finansowego:</h2>
			<xsl:for-each select="tns:P_5C">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
	</div>
</xsl:template>

<xsl:template match="tns:P_6">
	<div>
		<h1><xsl:value-of select="dtsf:NazwaPozycji"/></h1>
	
		<xsl:for-each select="dtsf:Opis">
			<xsl:call-template name="print-paras"/>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match="tns:BilansJednostkaOp">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
			<xsl:apply-templates select="jop:Aktywa"/>
			<xsl:apply-templates select="jop:Pasywa"/>
	</section>	
</xsl:template>

<xsl:template match="tns:BilansJednostkaInna">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
			<xsl:apply-templates select="jin:Aktywa"/>
			<xsl:apply-templates select="jin:Pasywa"/>
	</section>	
</xsl:template>

</xsl:stylesheet>
