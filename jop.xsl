<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:jop="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaOpStruktury"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaOrganizacjiPozarzadowejWZlotych" 
>

<xsl:variable name="jop-nazwy" select="document('JednostkaOpStrukturyDanychSprFin_v1-0.xsd')"/>

<xsl:variable name="op">
	<xsl:choose>
		<xsl:when test="count(//jop:Aktywa//dtsf:KwotaA) &lt; 10">
			<xsl:value-of select="'bardzo'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'mikro'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaOp">
	<section>
		<div class="tyt">Wprowadzenie do sprawozdania</div>
		<xsl:apply-templates select="tns:P_1"/>
		<xsl:apply-templates select="tns:P_3"/>
		<xsl:apply-templates select="tns:P_4"/>
		<xsl:apply-templates select="tns:P_5"/>
		
		<div class="wpr">
			<h1>6. Informacja uszczegóławiająca, wynikająca z potrzeb lub specyfiki jednostki</h1>
		
			<xsl:apply-templates select="tns:P_6"/>
		</div>
	</section>	
</xsl:template>

<xsl:template match="jop:Aktywa">
	<xsl:call-template name="aktywa">
		<xsl:with-param name="wiersze" select="jop:*"/>
		<xsl:with-param name="nazwy" select="$jop-nazwy"/>
		<xsl:with-param name="klasa" select="$op"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jop:Pasywa">
	<xsl:call-template name="pasywa">
		<xsl:with-param name="wiersze" select="jop:*"/>
		<xsl:with-param name="nazwy" select="$jop-nazwy"/>
		<xsl:with-param name="klasa" select="$op"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jop:*">
	<xsl:param name="raport"/>
	<xsl:param name="level"/>
	
	<xsl:call-template name="pozycje">
		<xsl:with-param name="raport" select="$raport"/>
		<xsl:with-param name="nazwy" select="$jop-nazwy"/>
		<xsl:with-param name="podpoz" select="jop:*"/>
		<xsl:with-param name="level" select="$level"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tns:RZiSJednostkaOp">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'zgodnie z Załącznikiem Nr 6 do ustawy o rachunkowości'"/>
		<xsl:with-param name="raport" select="'RZiSJednostkaOp'"/>
		<xsl:with-param name="wiersze" select="jop:*"/>
	</xsl:call-template>
</xsl:template>
	
<xsl:template match="tns:InformacjaDodatkowaJednostkaOp">
	<section class="pbb">
		<div class="tyt">Informacja dodatkowa
			<br/><span class="pod">zgodnie z Załącznikiem Nr 6 do ustawy o rachunkowości</span>
		</div>
		
		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<xsl:call-template name="dodatkoweInformacjeIObjasnienia">
			<xsl:with-param name="pozycje" select="tns:InformacjaDodatkowa"/>
		</xsl:call-template>			
	</section>	
</xsl:template>

<xsl:template match="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego">
	<xsl:call-template name="informacjaDodatkowaDotyczacaPodatkuDochodowego"/>
</xsl:template>
		
<xsl:template match="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego/*">
	<xsl:param name="kapitalowe"/>
	<xsl:param name="podstawa"/>
	<xsl:param name="poprzedni"/>
	<xsl:param name="wyroznienie"/>
	
	<xsl:call-template name="informacjaDodatkowaDotyczacaPodatkuDochodowego-Pozycje">
		<xsl:with-param name="kapitalowe" select="$kapitalowe"/>
		<xsl:with-param name="podstawa" select="$podstawa"/>
		<xsl:with-param name="poprzedni" select="$poprzedni"/>
		<xsl:with-param name="wyroznienie" select="$wyroznienie"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>