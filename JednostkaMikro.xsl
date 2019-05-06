<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/" 
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMikroWZlotych"

	xmlns:jmi="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMikroStruktury"
	xmlns:jin="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaStruktury"
	xmlns:jma="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMalaStruktury"
>

<xsl:include href="common.xsl"/>
<xsl:include href="func.xsl"/>
<xsl:include href="jin.xsl"/>
<xsl:include href="jma.xsl"/>
<xsl:include href="jmi.xsl"/>
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
		<xsl:when test="$root = ''"><!-- całe sprawozdanie -->
			<section class="hdr">
				<div class="tyt tyt1">SPRAWOZDANIE FINANSOWE</div>
				<div class="cen">za okres<br/><xsl:value-of select="//dtsf:OkresOd"/> - <xsl:value-of select="//dtsf:OkresDo"/></div>
				<div class="cen"><br/><small>data sporządzenia<br/><xsl:value-of select="//dtsf:DataSporzadzenia"/></small></div>
			</section>
			<xsl:apply-templates select="tns:JednostkaMikro"/>
		</xsl:when>
		<xsl:otherwise><!-- część sprawozdania -->
			<xsl:message>Root: <xsl:value-of select="$root"/></xsl:message>
			<div class="phe"><xsl:value-of select="//dtsf:NazwaFirmy"/> - Sprawozdanie Finansowe za <xsl:value-of select="substring(//dtsf:DataOd, 1, 4)"/></div>
			<xsl:apply-templates select="tns:JednostkaMikro/*[local-name() = $root]"/>			
		</xsl:otherwise>
	</xsl:choose>
	
</body>

</html>

</xsl:template>

<xsl:template match="tns:JednostkaMikro">
	<xsl:apply-templates select="tns:InformacjeOgolneJednostkaMikro"/>
	<xsl:apply-templates select="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaMala"/>
	<xsl:apply-templates select="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaInna"/>

	<xsl:apply-templates select="tns:BilansJednostkaMikro"/>	
	<xsl:apply-templates select="tns:BilansJednostkaInna"/>
	<xsl:apply-templates select="tns:BilansJednostkaMala"/>

	<xsl:apply-templates select="tns:RZiSJednostkaMikro"/>	
	<xsl:apply-templates select="tns:RZiSJednostkaInna"/>
	<xsl:apply-templates select="tns:RZiSJednostkaMala"/>

	<xsl:apply-templates select="tns:ZestZmianWKapitaleJednostkaInna"/>
	<xsl:apply-templates select="tns:RachPrzeplywowJednostkaInna"/>
	
	<xsl:apply-templates select="tns:InformacjeUzupelniajaceDoBilansuJednostkaMikro"/>	
	<xsl:apply-templates select="tns:DodatkoweInformacjeIObjasnieniaJednostkaInna"/>
	<xsl:apply-templates select="tns:DodatkoweInformacjeIObjasnieniaJednostkaMala"/>
</xsl:template>

<xsl:template match="tns:InformacjeOgolneJednostkaMikro">
	<section>
		<div class="tyt">Informacje ogólne zgodnie z Załącznikiem Nr 4<br/>do ustawy o rachunkowości</div>
		<xsl:apply-templates select="tns:P_1"/>
		<xsl:apply-templates select="tns:P_3"/>
		<xsl:apply-templates select="tns:P_4"/>
		<xsl:apply-templates select="tns:P_5"/>
		<xsl:apply-templates select="tns:P_6"/>
	</section>	
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
		<h1>4. Wskazanie zastosowanych zasad rachunkowości przewidzianych dla jednostek mikro z wyszczególnieniem wybranych uproszczeń</h1>
		<xsl:apply-templates/>
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

<xsl:template match="tns:P_6">
	<div class="wpr">
		<h1>6. Zasady (polityka) rachunkowości</h1>
	
		<div class="wpr2">
			<h2>A. Omówienie przyjętych zasad (polityki) rachunkowości, w zakresie w jakim ustawa pozostawia jednostce prawo wyboru, w tym:</h2>
			<xsl:for-each select="tns:P_6A">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>B. metod wyceny aktywów i pasywów (także amortyzacji):</h2>
			<xsl:for-each select="tns:P_6B">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
		
		<div class="wpr2">
			<h2>C. pomiaru wyniku finansowego oraz sposobu sporządzenia sprawozdania finansowego:</h2>
			<xsl:for-each select="tns:P_6C">
				<xsl:call-template name="print-paras"/>
			</xsl:for-each>
		</div>
	</div>
</xsl:template>

<xsl:template match="tns:P_7">
	<div>
		<h1><xsl:value-of select="dtsf:NazwaPozycji"/></h1>
	
		<xsl:for-each select="dtsf:Opis">
			<xsl:call-template name="print-paras"/>
		</xsl:for-each>
	</div>
</xsl:template>

<xsl:template match="tns:BilansJednostkaMikro">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
		<xsl:apply-templates select="jmi:Aktywa"/>
		<xsl:apply-templates select="jmi:Pasywa"/>
	</section>	
</xsl:template>

<xsl:template match="tns:BilansJednostkaInna">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
		<xsl:apply-templates select="jin:Aktywa"/>
		<xsl:apply-templates select="jin:Pasywa"/>
	</section>	
</xsl:template>

<xsl:template match="tns:BilansJednostkaMala">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
			<xsl:apply-templates select="jma:Aktywa"/>
			<xsl:apply-templates select="jma:Pasywa"/>
	</section>	
</xsl:template>

</xsl:stylesheet>
