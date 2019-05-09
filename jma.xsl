<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:jma="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMalaStruktury"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMalaWZlotych" 
>

<xsl:variable name="jma-nazwy" select="document('JednostkaMalaStrukturyDanychSprFin_v1-0.xsd')"/>

<xsl:template match="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaMala">
	<section>
		<div class="tyt">Wprowadzenie do sprawozdania</div>
		<xsl:apply-templates select="tns:P_1"/>
		<xsl:apply-templates select="tns:P_3"/>
		<xsl:apply-templates select="tns:P_4"/>
		<xsl:apply-templates select="tns:P_5"/>
		<xsl:apply-templates select="tns:P_6"/>
		
		<div class="wpr">
			<h1>7. Informacja uszczegóławiająca, wynikająca z potrzeb lub specyfiki jednostki</h1>
		
			<xsl:apply-templates select="tns:P_7"/>
		</div>
	</section>	
</xsl:template>

<xsl:template match="jma:Aktywa">
	<xsl:call-template name="aktywa">
		<xsl:with-param name="wiersze" select="jma:*"/>
		<xsl:with-param name="nazwy" select="$jma-nazwy"/>
		<xsl:with-param name="klasa" select="'mala'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jma:Pasywa">
	<xsl:call-template name="pasywa">
		<xsl:with-param name="wiersze" select="jma:*"/>
		<xsl:with-param name="nazwy" select="$jma-nazwy"/>
		<xsl:with-param name="klasa" select="'mala'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jma:*">
	<xsl:param name="raport"/>
	<xsl:param name="level"/>
	
	<xsl:call-template name="pozycje">
		<xsl:with-param name="raport" select="$raport"/>
		<xsl:with-param name="nazwy" select="$jma-nazwy"/>
		<xsl:with-param name="podpoz" select="jma:*"/>
		<xsl:with-param name="level" select="$level"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jma:RZiSPor">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'Wersja porównawcza'"/>
		<xsl:with-param name="raport" select="'RZiSPor'"/>
		<xsl:with-param name="wiersze" select="jma:*"/>
	</xsl:call-template>
</xsl:template>
	
<xsl:template match="jma:RZiSKalk">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'Wersja kalkulacyjna'"/>
		<xsl:with-param name="raport" select="'RZiSKalk'"/>
		<xsl:with-param name="wiersze" select="jma:*"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tns:DodatkoweInformacjeIObjasnieniaJednostkaMala">
	<section class="pbb">
		<div class="tyt">Dodatkowe informacje i objaśnienia
			<br/><span class="pod">zgodnie z Załącznikiem Nr 5 do ustawy o rachunkowości</span>
		</div>
		
		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<xsl:call-template name="dodatkoweInformacjeIObjasnienia">
			<xsl:with-param name="pozycje" select="tns:DodatkoweInformacjeIObjasnienia"/>
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