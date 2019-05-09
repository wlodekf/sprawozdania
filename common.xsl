<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/" 
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaWZlotych" 
>

<xsl:output version='1.0' encoding='UTF-8'/>

<!-- Serwer czy klient -->
<xsl:param name="procesor" select="'serwer'"/>
<!-- Część sprawozdania do wyświetlenia -->
<xsl:param name="root" select="''"/>
<!-- Format kwot -->
<xsl:decimal-format name="pln" decimal-separator="," grouping-separator="."/>

<xsl:template match="dtsf:Siedziba">	
	<tr><td class="ts" colspan="2"><b>Siedziba</b></td></tr>
	
	<tr><td class="tl">Województwo</td><td><xsl:value-of select="dtsf:Wojewodztwo"/></td></tr>
	<tr><td class="tl">Powiat</td><td><xsl:value-of select="dtsf:Powiat"/></td></tr>
	<tr><td class="tl">Gmina</td><td><xsl:value-of select="dtsf:Gmina"/></td></tr>
	<tr><td class="tl">Miejscowość</td><td><xsl:value-of select="dtsf:Miejscowosc"/></td></tr>
</xsl:template>
		

<xsl:template match="dtsf:Adres">
	<tr><td>Kod kraju</td><td><xsl:value-of select="etd:KodKraju"/></td></tr>
	<tr><td>Województwo</td><td><xsl:value-of select="etd:Wojewodztwo"/></td></tr>
	<tr><td>Powiat</td><td><xsl:value-of select="etd:Powiat"/></td></tr>
	<tr><td>Gmina</td><td><xsl:value-of select="etd:Gmina"/></td></tr>
	<tr><td>Ulica</td><td><xsl:value-of select="etd:Ulica"/></td></tr>
	<tr><td>Nr domu</td><td><xsl:value-of select="etd:NrDomu"/></td></tr>
	<tr><td>Miejscowość</td><td><xsl:value-of select="etd:Miejscowosc"/></td></tr>
	<tr><td>Kod pocztowy</td><td><xsl:value-of select="etd:KodPocztowy"/></td></tr>
	<tr><td>Poczta</td><td><xsl:value-of select="etd:Poczta"/></td></tr>
</xsl:template>

<xsl:template match="dtsf:NIP">
	<tr><td>NIP</td><td><xsl:apply-templates/></td></tr>
</xsl:template>

<xsl:template match="dtsf:KRS">
	<tr><td>Nr KRS</td><td><xsl:apply-templates/></td></tr>
</xsl:template>

<xsl:template name="aktywa">
	<xsl:param name="wiersze"/>
	<xsl:param name="nazwy"/>
	<xsl:param name="klasa"/>
		
	<table cellspacing="0" cellpadding="0" class="raport bilans {$klasa} aktywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>A K T Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>

			<xsl:apply-templates select="$wiersze">
				<xsl:with-param name="raport" select="'Aktywa'"/>
				<xsl:with-param name="level" select="1"/>
			</xsl:apply-templates>

			<tr class="sumbil">
				<td>
				</td>
				<td class="test">
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Aktywa'"/>
						<xsl:with-param name="schemat" select="$nazwy"/>
					</xsl:call-template>
				</td>
				<td class="ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:KwotaA"/>
					</xsl:call-template>				
				</td>
				<td class="ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:KwotaB"/>
					</xsl:call-template>				
				</td>
			</tr>
		</tbody>
	</table>
</xsl:template>

<xsl:template name="pasywa">
	<xsl:param name="wiersze"/>
	<xsl:param name="nazwy"/>
	<xsl:param name="klasa"/>

	<table cellspacing="0" cellpadding="0" class="raport bilans {$klasa} pasywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>P A S Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="$wiersze">
				<xsl:with-param name="raport" select="'Pasywa'"/>
				<xsl:with-param name="level" select="1"/>
			</xsl:apply-templates>
			<tr class="sumbil">
				<td>
				</td>
				<td>
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Pasywa'"/>
						<xsl:with-param name="schemat" select="$nazwy"/>
					</xsl:call-template>
				</td>
				<td class="ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:KwotaA"/>
					</xsl:call-template>				
				</td>
				<td class="ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:KwotaB"/>
					</xsl:call-template>				
				</td>	
			</tr>
		</tbody>
	</table>
</xsl:template>

<xsl:template name="pozycje">
	<xsl:param name="raport"/>
	<xsl:param name="nazwy"/>
	<xsl:param name="podpoz"/>
	<xsl:param name="level"/>
	
    <xsl:variable name="wyr">
		<xsl:call-template name="wyr-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
			<xsl:with-param name="level" select="$level"/>
		</xsl:call-template>
    </xsl:variable>
        
    <xsl:variable name="nazwa">
		<xsl:call-template name="nazwa-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
			<xsl:with-param name="schemat" select="$nazwy"/>
		</xsl:call-template>    
    </xsl:variable>
    
    <xsl:variable name="kwotaa">
		<xsl:choose>
			<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca' or substring-after(name(.), ':') = 'Podpozycja' or substring-after(name(.), ':') = 'PozycjaUszczegolawiajaca'">
				<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaA"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./dtsf:KwotaA"/>
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:variable>
    
    <xsl:variable name="kwotab">
		<xsl:choose>
			<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca' or substring-after(name(.), ':') = 'Podpozycja' or substring-after(name(.), ':') = 'PozycjaUszczegolawiajaca'">
				<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaB"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./dtsf:KwotaB"/>
			</xsl:otherwise>
		</xsl:choose>   
    </xsl:variable>

    <xsl:variable name="ujemnaa">
		<xsl:choose>
			<xsl:when test="$kwotaa &lt; 0">
				<xsl:value-of select="'ujemna'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'dodatnia'"/>
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:variable>
       
    <xsl:variable name="ujemnab">
		<xsl:choose>
			<xsl:when test="$kwotab &lt; 0">
				<xsl:value-of select="'ujemna'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'dodatnia'"/>
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:variable>
     
    <xsl:variable name="empty">
    	<xsl:choose>
    		<xsl:when test="format-number($kwotaa, '#.##0,00', 'pln') = '0,00' and format-number($kwotab, '#.##0,00', 'pln') = '0,00'">
    			<xsl:value-of select="'empty'"/>
    		</xsl:when>
    		<xsl:otherwise>
    			<xsl:value-of select="''"/>
    		</xsl:otherwise>
    	</xsl:choose>
    </xsl:variable>
    
	<tr class="{$wyr} {$empty}">
		<td class="wsnw">
			<xsl:call-template name="after-last">
                <xsl:with-param name="str">
					<xsl:call-template name="element"/>
               	</xsl:with-param>
                <xsl:with-param name="find" select="'_'"/>
                <xsl:with-param name="poziom" select="0"/>
                <xsl:with-param name="nazwa" select="$nazwa"/>
			</xsl:call-template>
		</td>
		<td class="tekst klu{$level*10}">
			<xsl:value-of select="$nazwa"/>
		</td>
		<td class="kwoty ar {$ujemnaa}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="$kwotaa"/>
			</xsl:call-template>
		</td>
		<td class="kwoty ar {$ujemnab}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="$kwotab"/>
			</xsl:call-template>
		</td>
	</tr>
	
	<xsl:choose>
		<xsl:when test="$podpoz">
			<xsl:apply-templates select="$podpoz">
				<xsl:with-param name="raport" select="$raport"/>
				<xsl:with-param name="level" select="$level+1"/>				
			</xsl:apply-templates>
		</xsl:when>
	
		<xsl:when test="dtsf:PozycjaUszczegolawiajaca">
			<xsl:apply-templates select="dtsf:PozycjaUszczegolawiajaca">
				<xsl:with-param name="raport" select="$raport"/>
				<xsl:with-param name="nazwy" select="$nazwy"/>
				<xsl:with-param name="level" select="$level+1"/>	
			</xsl:apply-templates>
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:apply-templates select="dtsf:Podpozycja">
				<xsl:with-param name="raport" select="$raport"/>
				<xsl:with-param name="nazwy" select="$nazwy"/>
				<xsl:with-param name="level" select="$level+1"/>	
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
		
</xsl:template>

<xsl:template match="dtsf:Podpozycja">
	<xsl:param name="raport"/>
	<xsl:param name="nazwy"/>
	<xsl:param name="level"/>
	
	<xsl:call-template name="pozycje">
		<xsl:with-param name="raport" select="$raport"/>
		<xsl:with-param name="nazwy" select="$nazwy"/>
		<xsl:with-param name="podpoz" select="./dtsf:Podpozycja"/>
		<xsl:with-param name="level" select="$level"/>	
	</xsl:call-template>
</xsl:template>

<xsl:template match="dtsf:PozycjaUszczegolawiajaca">
	<xsl:param name="raport"/>
	<xsl:param name="nazwy"/>
	<xsl:param name="level"/>
	
	<xsl:call-template name="pozycje">
		<xsl:with-param name="raport" select="$raport"/>
		<xsl:with-param name="nazwy" select="$nazwy"/>
		<xsl:with-param name="podpoz" select="./dtsf:Podpozycja"/>
		<xsl:with-param name="level" select="$level"/>	
	</xsl:call-template>
</xsl:template>

<xsl:template name="rzis">
	<xsl:param name="wersja"/>
	<xsl:param name="raport"/>
	<xsl:param name="wiersze"/>
	
	<section class="pbb">
	<div class="tyt">
		Rachunek zysków i strat<br/>
		<span class="pod"><xsl:value-of select="$wersja"/></span>
	</div>
	<table cellspacing="0" cellpadding="0" class="rzis raport">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>Treść / wyszczególnienie</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="$wiersze">
				<xsl:with-param name="raport" select="$raport"/>
				<xsl:with-param name="level" select="1"/>
			</xsl:apply-templates>
		</tbody>
	</table>	
	</section>
</xsl:template>

<xsl:template name="dodatkoweInformacjeIObjasnienia">
	<xsl:param name="pozycje"/>
	
	<xsl:variable name="pliki" select="count(//dtsf:Plik)"/>

	<div class="sek">
		<div class="tyt2">Dodatkowe informacje i objaśnienia</div>
		<table cellspacing="0" cellpadding="0">
		<thead>
			<tr class="rh">
				<th>Opis</th>
				<xsl:if test="$pliki">
				<th>Nazwa pliku</th>
				</xsl:if>
			</tr>
		</thead>
		<tbody>
		<xsl:for-each select="$pozycje">
			<xsl:variable name="plik_id" select="dtsf:Plik/comment()"/>
			<xsl:variable name="zawartosc" select="dtsf:Plik/dtsf:Zawartosc"/>
			<xsl:variable name="nazwa" select="dtsf:Plik/dtsf:Nazwa"/>
			<tr>
				<td>
					<xsl:call-template name="print-paras">
						<xsl:with-param name="text" select="dtsf:Opis"/>
					</xsl:call-template>
				</td>
				<xsl:if test="$pliki">
				<td><a class="lnk" href="{'data:application/octet-stream;base64,'}{$zawartosc}" download="{$nazwa}">
						<xsl:call-template name="replace-str">
							<xsl:with-param name="str" select="$nazwa" />
							<xsl:with-param name="find" select="'_'" />
							<xsl:with-param name="replace" select="' '" />
						</xsl:call-template>
					</a>
				</td>
				</xsl:if>
			</tr>
		</xsl:for-each>
		</tbody>
		</table>
	</div>	
</xsl:template>

<!-- W razie problemów z funkcją "document" (przetwarzanie lokalne w chrome) zostaną
     tutaj wgrane pozycje ze schematów nazw pozycji raportów i nazwami kodów PKD -->
<xsl:variable name="nazwy" xml:id="nazwy"></xsl:variable>
<xsl:variable name="podatek" xml:id="podatek"></xsl:variable>
<xsl:variable name="pkd" xml:id="pkd"></xsl:variable>

<xsl:variable name="wyroznienia">
	<!-- Klasy CSS wyróżnienia dla wierszy na poszczególnych poziomach zagnieżdżenia -->
	
	<xsd:simpleType name="Aktywa">
		<xsd:enumeration value="0">UB</xsd:enumeration>
		<xsd:enumeration value="1">UBS</xsd:enumeration>
		<xsd:enumeration value="2">B</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="Pasywa">
		<xsd:enumeration value="0">UB</xsd:enumeration>
		<xsd:enumeration value="1">UBS</xsd:enumeration>
		<xsd:enumeration value="2">B</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="RZiSKalk">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="RZiSPor">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="RZiSJednostkaOp">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="RZiSJednostkaMikro">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="ZestZmianWKapitaleJednostkaInna">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
		<xsd:enumeration value="2">B</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="PrzeplywyBezp">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
		<xsd:enumeration value="2">B</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="PrzeplywyPosr">
		<xsd:enumeration value="1">UBS</xsd:enumeration>
		<xsd:enumeration value="2">U</xsd:enumeration>
	</xsd:simpleType>
</xsl:variable>

</xsl:stylesheet>