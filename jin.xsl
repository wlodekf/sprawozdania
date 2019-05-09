<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:jin="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaStruktury"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaWZlotych" 
>

<xsl:variable name="jin-nazwy" select="document('JednostkaInnaStrukturyDanychSprFin_v1-0.xsd')"/>

<xsl:variable name="krotki">
	<xsl:choose>
		<xsl:when test="count(//jin:Aktywa//dtsf:KwotaA) &lt; 50">
			<xsl:value-of select="'krotki'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="''"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	
<xsl:template match="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaInna">
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

<xsl:template match="tns:WprowadzenieDoSprawozdaniaFinansowego">
	<section>
		<div class="tyt">Wprowadzenie do sprawozdania</div>
		<xsl:apply-templates select="tns:P_1"/>
		<xsl:apply-templates select="tns:P_3"/>
		<xsl:apply-templates select="tns:P_4"/>
		<xsl:apply-templates select="tns:P_5"/>
		<xsl:apply-templates select="tns:P_7"/>
		
		<div class="wpr">
			<h1>8. Informacja uszczegóławiająca, wynikająca z potrzeb lub specyfiki jednostki</h1>
		
			<xsl:apply-templates select="tns:P_8"/>
		</div>
	</section>	
</xsl:template>

<xsl:template match="jin:Aktywa">
	<xsl:call-template name="aktywa">
		<xsl:with-param name="wiersze" select="jin:*"/>
		<xsl:with-param name="nazwy" select="$jin-nazwy"/>
		<xsl:with-param name="klasa" select="$krotki"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jin:Pasywa">
	<xsl:call-template name="pasywa">
		<xsl:with-param name="wiersze" select="jin:*"/>
		<xsl:with-param name="nazwy" select="$jin-nazwy"/>
		<xsl:with-param name="klasa" select="$krotki"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jin:*">
	<xsl:param name="raport"/>
	<xsl:param name="level"/>
	
	<xsl:call-template name="pozycje">
		<xsl:with-param name="raport" select="$raport"/>
		<xsl:with-param name="nazwy" select="$jin-nazwy"/>
		<xsl:with-param name="podpoz" select="jin:*"/>
		<xsl:with-param name="level" select="$level"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tns:RZiSJednostkaInna">
	<xsl:apply-templates select="jin:RZiSKalk"/>
	<xsl:apply-templates select="jin:RZiSPor"/>
</xsl:template>

<xsl:template match="jin:RZiSPor">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'Wersja porównawcza'"/>
		<xsl:with-param name="raport" select="'RZiSPor'"/>
		<xsl:with-param name="wiersze" select="jin:*"/>
	</xsl:call-template>
</xsl:template>
	
<xsl:template match="jin:RZiSKalk">
	<xsl:call-template name="rzis">
		<xsl:with-param name="wersja" select="'Wersja kalkulacyjna'"/>
		<xsl:with-param name="raport" select="'RZiSKalk'"/>
		<xsl:with-param name="wiersze" select="jin:*"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="tns:ZestZmianWKapitaleJednostkaInna">
	<xsl:call-template name="kapital"/>
</xsl:template>

<xsl:template match="tns:ZestZmianWKapitale">
	<xsl:call-template name="kapital"/>
</xsl:template>

<xsl:template name="kapital">
	<section class="pbb">
		<div class="tyt">
			Zestawienie zmian w kapitale (funduszu) własnym
		</div>
		
	<table cellspacing="0" cellpadding="0" class="kapital raport">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>Treść / wyszczególnienie</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="jin:*">
				<xsl:with-param name="raport" select="'ZestZmianWKapitaleJednostkaInna'"/>
				<xsl:with-param name="level" select="1"/>
			</xsl:apply-templates>	
		</tbody>
	</table>
	</section>
</xsl:template>

<xsl:template match="jin:PrzeplywyPosr">
	<xsl:call-template name="przeplywy">
		<xsl:with-param name="metoda" select="'Metoda pośrednia'"/>
		<xsl:with-param name="raport" select="'PrzeplywyPosr'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="jin:PrzeplywyBezp">
	<xsl:call-template name="przeplywy">
		<xsl:with-param name="metoda" select="'Metoda bezpośrednia'"/>
		<xsl:with-param name="raport" select="'PrzeplywyBezp'"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="przeplywy">
	<xsl:param name="metoda"/>
	<xsl:param name="raport"/>
	
	<section class="pbb">
	<div class="tyt">
		Rachunek przepływów pieniężnych<br/>
		<span class="pod"><xsl:value-of select="$metoda"/></span>
	</div>
	<table cellspacing="0" cellpadding="0" class="przeplywy raport">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>Treść / wyszczególnienie</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="jin:*">
				<xsl:with-param name="raport" select="$raport"/>
				<xsl:with-param name="level" select="1"/>
			</xsl:apply-templates>	
		</tbody>
	</table>	
	</section>
</xsl:template>

<xsl:template match="tns:DodatkoweInformacjeIObjasnieniaJednostkaInna">
	<section class="pbb">
		<div class="tyt">Dodatkowe informacje i objaśnienia</div>
		
		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<xsl:call-template name="dodatkoweInformacjeIObjasnienia">
			<xsl:with-param name="pozycje" select="tns:DodatkoweInformacjeIObjasnienia"/>
		</xsl:call-template>
	</section>	
</xsl:template>

<xsl:template match="tns:DodatkoweInformacjeIObjasnieniaJednstkaInna"> <!-- literówka w jin -->
	<section class="pbb">
		<div class="tyt">Dodatkowe informacje i objaśnienia</div>
		
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