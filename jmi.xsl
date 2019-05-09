<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:jmi="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMikroStruktury"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMikroWZlotych"
>

<xsl:variable name="jmi-nazwy" select="document('JednostkaMikroStrukturyDanychSprFin_v1-0.xsd')"/>

<xsl:variable name="mikro">
	<xsl:choose>
		<xsl:when test="count(//jmi:Aktywa//dtsf:KwotaA) &lt; 10">
			<xsl:value-of select="'bardzo'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'mikro'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template match="jmi:Aktywa">
	<xsl:call-template name="aktywa">
		<xsl:with-param name="wiersze" select="jmi:*"/>
		<xsl:with-param name="nazwy" select="$jmi-nazwy"/>
		<xsl:with-param name="klasa" select="$mikro"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jmi:Pasywa">
	<xsl:call-template name="pasywa">
		<xsl:with-param name="wiersze" select="jmi:*"/>
		<xsl:with-param name="nazwy" select="$jmi-nazwy"/>
		<xsl:with-param name="klasa" select="$mikro"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jmi:*">
	<xsl:param name="raport"/>
	<xsl:param name="level"/>
	
	<xsl:call-template name="pozycje">
		<xsl:with-param name="raport" select="$raport"/>
		<xsl:with-param name="nazwy" select="$jmi-nazwy"/>
		<xsl:with-param name="podpoz" select="jmi:*"/>
		<xsl:with-param name="level" select="$level"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tns:RZiSJednostkaMikro">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'jednostki mikro'"/>
		<xsl:with-param name="raport" select="'RZiSJednostkaMikro'"/>
		<xsl:with-param name="wiersze" select="jmi:*"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jmi:RZiSPor">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'Wersja porównawcza'"/>
		<xsl:with-param name="raport" select="'RZiSPor'"/>
		<xsl:with-param name="wiersze" select="jmi:*"/>
	</xsl:call-template>
</xsl:template>
	
<xsl:template match="jmi:RZiSKalk">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'Wersja kalkulacyjna'"/>
		<xsl:with-param name="raport" select="'RZiSKalk'"/>
		<xsl:with-param name="wiersze" select="jmi:*"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tns:InformacjeUzupelniajaceDoBilansuJednostkaMikro">
	<section class="pbb">
		<div class="tyt">Informacje uzupełniające do bilansu
		<br/><span class="pod">zgodnie z Załącznikiem Nr 4 do ustawy o rachunkowości</span></div>

		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<xsl:call-template name="dodatkoweInformacjeIObjasnienia">
			<xsl:with-param name="pozycje" select="tns:InformacjeUzupelniajaceDoBilansu"/>
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
