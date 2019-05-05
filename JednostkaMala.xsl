<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	
	xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl"
                
	xmlns:etd="http://crd.gov.pl/xml/schematy/dziedzinowe/mf/2016/01/25/eD/DefinicjeTypy/" 
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	
	xmlns:jma="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMalaStruktury"	
	xmlns:jin="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaStruktury"
	  
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMalaWZlotych"
>
	
<xsl:output version='1.0' encoding='UTF-8'/>

<!-- Nazwy pozycji raportów -->
<xsl:param name="jma-nazwy" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>
<xsl:param name="jin-nazwy" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>

<!-- Nazwy pozycli rozliczenia podatku -->
<xsl:param name="schema-podatek" select="'StrukturyDanychSprFin_v1-1.xsd'"/>
<!-- Nazwy kodów PKD -->
<xsl:param name="schema-pkd" select="'KodyPKD_v2-0E.xsd'"/>
<!-- Serwer czy klient -->
<xsl:param name="procesor" select="'serwer'"/>
<!-- Część sprawozdania do wyświetlenia -->
<xsl:param name="root" select="''"/>

<xsl:decimal-format name="pln" decimal-separator="," grouping-separator="."/>

<!-- Do zmiany wielkości liter -->
<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyząćęłńóśźż'" />
<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZĄĆĘŁŃÓŚŹŻ'" />
	
<!-- Formatowanie wielkości kwotowej, separacja tysięcy, chowanie zer. -->
<xsl:template name="tkwotowy">
	<xsl:param name="kwota"/>
	<xsl:if test="$kwota">
		<xsl:variable name="kwotaf" select="format-number($kwota, '#.##0,00', 'pln')"/>
		<xsl:choose>
			<xsl:when test="$kwotaf = '0,00'"> </xsl:when>
			<xsl:otherwise><xsl:value-of select="$kwotaf"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:if>
</xsl:template>

<!-- Ustalenie znaku liczby/kwoty -->
<xsl:template name="znak_kwoty">
	<xsl:param name="kwota"/>
	<xsl:choose>
		<xsl:when test="$kwota &lt; 0">
			<xsl:value-of select="'ujemna'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'dodatnia'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Ustalenie nazwy elementu - obsługa szczególnego przypadku gdy elementem jest pozycja użytkownika
     wtedy nazwa elementu brana jest z komenatrza -->
<xsl:template name="element">
    <xsl:choose>
		<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
			<xsl:value-of select="comment()"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring-after(name(.), ':')"/>
		</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Ustalenie nazwy pozycji raportu -->
<xsl:template name="nazwa-pozycji">
	<xsl:param name="raport"/>
	<xsl:param name="schemat"/>
	<xsl:variable name="wyliczenie" select="substring-after(name(.), ':')"/>
	
	<xsl:choose>
		<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
			<xsl:value-of select="./dtsf:NazwaPozycji"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			 	<xsl:when test="$procesor = 'serwer'">
					<!-- Obsługa przetwarzania XSLT po stronie serwera -->
					  
					<xsl:variable name="schema" select="document($schemat)"/>
					
					<xsl:choose>
						<xsl:when test="$raport = 'ZestZmianWKapitaleJednostkaMala'">
							<!-- Drzewo dla zmian w kapitale ma nieco inną strukturę niż pozostałe raporty -->
							<xsl:value-of select="$schema//xsd:complexType[@name=$raport]//xsd:element[@name=$wyliczenie]//xs:documentation"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="naz" select="$schema//xsd:element[@name=$raport]//xsd:element[@name=$wyliczenie]//xs:documentation"/>
							<xsl:choose>
								<xsl:when test="$naz">
									<xsl:value-of select="$naz"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$schema//xsd:element[@name=$wyliczenie]//xs:documentation"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:when>
				
				<xsl:otherwise>
					<!-- Obsługa przetwarzania XSLT lokalnie w przeglądarce, w przypadku gdy xslt procesor nie obsługuje 
					poprawnie funkcji document() czyli w chrome. 
					Zakłada się, że nazwy zostały wgrane/przeniesione z odpowiedniego schematu 
					do arkusza XSL pod zmienną "nazwy" -->
					<xsl:choose>
						<xsl:when test="$raport = 'ZestZmianWKapitaleJednostkaMala'">
							<!-- Drzewo dla zmian w kapitale ma nieco inną strukturę niż pozostałe raporty -->
							<xsl:value-of select="exsl:node-set($nazwy)//xsd:complexType[@name=$raport]//xsd:element[@name=$wyliczenie]//xs:documentation"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="naz" select="exsl:node-set($nazwy)//xsd:element[@name=$raport]//xsd:element[@name=$wyliczenie]//xs:documentation"/>
							<xsl:choose>
								<xsl:when test="$naz">
									<xsl:value-of select="$naz"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="exsl:node-set($nazwy)//xsd:element[@name=$wyliczenie]//xs:documentation"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
												
		</xsl:otherwise>
	</xsl:choose> 
</xsl:template>

<!-- Ustalenie nazwy pozycji w tabeli podatku -->
<xsl:template name="nazwa-podatek">
	<xsl:param name="raport"/>
	<xsl:variable name="wyliczenie" select="substring-after(name(.), ':')"/>
	
	<xsl:choose>
		<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
			<xsl:value-of select="./dtsf:NazwaPozycji"/>
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:choose>
			 	<xsl:when test="$procesor = 'serwer'">
					<xsl:variable name="schema" select="document($schema-podatek)"/>
					<xsl:value-of select="$schema//xsd:complexType[@name='TInformacjaDodatkowaDotyczacaPodatkuDochodowego']//xsd:element[@name=$wyliczenie]//xs:documentation"/>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="exsl:node-set($podatek)//xsd:element[@name=$wyliczenie]//xs:documentation"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose> 
</xsl:template>

<!-- Nazwa kodu PKD -->
<xsl:template name="nazwa-pkd">
	<xsl:variable name="kod" select="."/>
	<xsl:choose>
		<xsl:when test="$procesor = 'serwer'">
			<xsl:variable name="schema" select="document($schema-pkd)"/>
			<xsl:value-of select="translate($schema//xs:enumeration[@value=$kod]//xs:documentation, $upper, $lower)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="translate(exsl:node-set($pkd)//xs:enumeration[@value=$kod]//xs:documentation, $upper, $lower)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="klu-pozycji">
	<xsl:param name="raport"/>
	<xsl:variable name="wyliczenie">
		<xsl:call-template name="element"/>
	</xsl:variable>
	
	<xsl:variable name="klu1">
		<xsl:call-template name="ile-wystapien">
			<xsl:with-param name="tekst" select="$wyliczenie"/>
			<xsl:with-param name="ciag" select="'_'"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:value-of select="$klu1 * 10"/>
</xsl:template>

<!-- Ustalenie liczby wystąpień podanego ciągu w podanym tekście -->
<xsl:template name="ile-wystapien">
	
	<xsl:param name="tekst"/>
	<xsl:param name="ciag"/>
	
	<xsl:variable name="po" select="substring-after($tekst, $ciag)"/>
	
	<xsl:choose>
		<xsl:when test="string-length($po) > 0">
			<xsl:variable name="ile">
				<xsl:call-template name="ile-wystapien">
					<xsl:with-param name="tekst" select="$po"/>
					<xsl:with-param name="ciag" select="$ciag"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$ile + 1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="0"/>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

<xsl:template name="wyr-pozycji">
	<!-- Ustalenie klasy CSS wyróżnienia wiersza raportu -->
	
	<xsl:param name="raport"/>
	<xsl:variable name="wyliczenie">
		<xsl:call-template name="element"/>
	</xsl:variable>

	<xsl:variable name="poziom">
		<xsl:call-template name="ile-wystapien">
			<xsl:with-param name="tekst" select="$wyliczenie"/>
			<xsl:with-param name="ciag" select="'_'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="wyr" select="exsl:node-set($wyroznienia)/xsd:simpleType[@name=$raport]/xsd:enumeration[@value=$poziom]"/>
	
	<xsl:value-of select="concat('wyr', $wyr)"/>
		
</xsl:template>
	
<xsl:template name="replace-str">
    <xsl:param name="str"/>
    <xsl:param name="find"/>
    <xsl:param name="replace"/>
    <xsl:choose>
        <xsl:when test="contains($str, $find)">
            <xsl:value-of select="substring-before($str, $find)"/>
            <xsl:value-of select="$replace"/>
            <xsl:call-template name="replace-str">
                <xsl:with-param name="str" select="substring-after($str, $find)"/>
                <xsl:with-param name="find" select="$find"/>
                <xsl:with-param name="replace" select="$replace"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$str"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="after-last">
    <xsl:param name="str"/>
    <xsl:param name="find"/>
    <xsl:param name="poziom"/>
    <xsl:param name="nazwa"/>
    
    <xsl:choose>
        <xsl:when test="contains($str, $find)">
            <xsl:call-template name="after-last">
                <xsl:with-param name="str" select="substring-after($str, $find)"/>
                <xsl:with-param name="find" select="$find"/>
                <xsl:with-param name="poziom" select="$poziom+1"/>
                <xsl:with-param name="nazwa" select="$nazwa"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
        	<xsl:variable name="x" select="translate($str, $upper, $lower)"/>
        	<xsl:variable name="f" select="substring($nazwa, 1, 1)"/>
        	<xsl:choose>
				<xsl:when test="$f = '–' or $f = '-'">
        		</xsl:when>
        		<xsl:when test="$poziom &gt;= 3 and $x != $str">
        			<xsl:value-of select="$x"/>)
        		</xsl:when>
        		<xsl:otherwise>
            		<xsl:value-of select="$str"/>
        		</xsl:otherwise>
        	</xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template name="print-paras">
	<xsl:param name="text" select="text()"/>
	
	<xsl:choose>
	    <xsl:when test="contains($text, '&#10;&#10;')">
	    	<xsl:call-template name="output-para">
	    		<xsl:with-param name="text" select="substring-before($text, '&#10;&#10;')"/>
	    	</xsl:call-template>
	    	
	    	<xsl:call-template name="print-paras">
	        	<xsl:with-param name="text" select="substring-after($text, '&#10;&#10;')"/>
	    	</xsl:call-template>
	    </xsl:when>
	    
	    <xsl:otherwise>
	    	<xsl:call-template name="output-para">
	        	<xsl:with-param name="text" select="$text"/>
	        </xsl:call-template>
	    </xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="output-para">
	<xsl:param name="text" select="text()"/>
	
	<xsl:choose>
	    <xsl:when test="contains($text, '&#10;')">
	    	<span class="txt">
	    		<xsl:call-template name="para-lines">
	    			<xsl:with-param name="text" select="$text"/>
	    		</xsl:call-template>
	    	</span>
	    </xsl:when>
	    
	    <xsl:otherwise>
	    	<p class="txt">
	    		<xsl:call-template name="para-lines">
	    			<xsl:with-param name="text" select="$text"/>
	    		</xsl:call-template>
	    	</p>
	    </xsl:otherwise>
	</xsl:choose>
	
</xsl:template>


<xsl:template name="para-lines">
	<xsl:param name="text" select="text()"/>
	
	<xsl:choose>
	    <xsl:when test="contains($text, '&#10;')">
	    	<xsl:if test="string-length(normalize-space(substring-before($text, '&#10;'))) > 0">
		    	<xsl:call-template name="output-linie">
			    	<xsl:with-param name="text" select="substring-before($text, '&#10;')"/>
		    	</xsl:call-template>
		    	
		    	<xsl:variable name="c1" select="substring($text,1,1)"/>
		    	<xsl:if test="$c1 != '*' and $c1 != '#'">
			    	<br/>
			    </xsl:if>
	    	</xsl:if>
	    	
	    	<xsl:call-template name="para-lines">
	        	<xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
	    	</xsl:call-template>
	    </xsl:when>
	    
	    <xsl:otherwise>
	    	<xsl:call-template name="output-linie">
		    	<xsl:with-param name="text" select="$text"/>
	    	</xsl:call-template>
	    </xsl:otherwise>
	</xsl:choose>
	
</xsl:template>


<xsl:template name="output-linie">
    <xsl:param name="text"></xsl:param>

    <xsl:if test="string-length(normalize-space($text)) > 0">
    
    	<xsl:variable name="c1" select="substring($text,1,1)"/>
    	<xsl:variable name="reszta" select="substring($text,3)"/>
    	
   		<xsl:choose>
   			<xsl:when test="$c1 = '*'">
   				<li class="txt">
        			<xsl:value-of select="$reszta"/>
   				</li>
   			</xsl:when>
   			
   			<xsl:when test="$c1 = '#'">
   				<h1 class="txt">
        			<xsl:value-of select="$reszta"/>
   				</h1>
   			</xsl:when>
   			
   			<xsl:otherwise>
        		<xsl:value-of select="$text"/>
   			</xsl:otherwise>
   		</xsl:choose>
   		
    </xsl:if>
</xsl:template>


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
			<xsl:apply-templates select="tns:JednostkaMala"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:message>Root: <xsl:value-of select="$root"/></xsl:message>
			<div class="phe"><xsl:value-of select="//dtsf:NazwaFirmy"/> - Sprawozdanie Finansowe za <xsl:value-of select="substring(//dtsf:DataOd, 1, 4)"/></div>
			<xsl:apply-templates select="tns:JednostkaMala/*[local-name() = $root]"/>			
		</xsl:otherwise>
	</xsl:choose>
	
</body>

</html>

</xsl:template>

<xsl:template match="tns:JednostkaMala">
	<xsl:apply-templates select="tns:WprowadzenieDoSprawozdaniaFinansowegoJednostkaMala"/>
	<xsl:apply-templates select="tns:BilansJednostkaMala"/>
	<xsl:apply-templates select="tns:BilansJednostkaInna"/>
	<xsl:apply-templates select="tns:RZiSJednostkaMala"/>
	<xsl:apply-templates select="tns:RZiSJednostkaInna"/>
	<xsl:apply-templates select="tns:ZestZmianWKapitaleJednostkaInna"/>
	<xsl:apply-templates select="tns:RachPrzeplywowJednostkaInna"/>
	<xsl:apply-templates select="tns:DodatkoweInformacjeIObjasnieniaJednostkaMala"/>
	<xsl:apply-templates select="tns:DodatkoweInformacjeIObjasnieniaJednostkaInna"/>
</xsl:template>

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

<xsl:template match="dtsf:Siedziba">	
	<tr><td class="ts" colspan="2"><b>Siedziba</b></td></tr>
	
	<tr><td class="tl">Województwo</td><td><xsl:value-of select="dtsf:Wojewodztwo"/></td></tr>
	<tr><td class="tl">Powiat</td><td><xsl:value-of select="dtsf:Powiat"/></td></tr>
	<tr><td class="tl">Gmina</td><td><xsl:value-of select="dtsf:Gmina"/></td></tr>
	<tr><td class="tl">Miejscowość</td><td><xsl:value-of select="dtsf:Miejscowosc"/></td></tr>
</xsl:template>
		
<xsl:template match="tns:P_1B">
	<tr><td class="ts" colspan="2"><b>Adres</b></td></tr>
	<xsl:apply-templates select="dtsf:Adres"/>
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

<xsl:template match="tns:P_1C">
	<tr><td class="ts" colspan="2"><b>Numer we własciwym rejestrze sądowym albo ewidencji</b></td></tr>
	<xsl:apply-templates select="dtsf:NIP"/>
	<xsl:apply-templates select="dtsf:KRS"/>
</xsl:template>
	
<xsl:template match="dtsf:NIP">
	<tr><td>NIP</td><td><xsl:apply-templates/></td></tr>
</xsl:template>

<xsl:template match="dtsf:KRS">
	<tr><td>Nr KRS</td><td><xsl:apply-templates/></td></tr>
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
		<h1>4. Wskazanie zastosowanych uproszczeń przewidzianych dla jednostek małych</h1>
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
			<h2>C. ustalenia wyniku finansowego oraz sposobu sporządzenia sprawozdania finansowego:</h2>
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



<xsl:template match="tns:BilansJednostkaMala">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
			<xsl:apply-templates select="jma:Aktywa"/>
			<xsl:apply-templates select="jma:Pasywa"/>
	</section>	
</xsl:template>

<xsl:template match="tns:BilansJednostkaInna">
	<section class="pbb bil">
		<div class="tyt">Bilans</div>
			<xsl:apply-templates select="jin:Aktywa"/>
			<xsl:apply-templates select="jin:Pasywa"/>
	</section>	
</xsl:template>

<xsl:template match="jma:Aktywa">
	<table cellspacing="0" cellpadding="0" class="raport bilans mala aktywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>A K T Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>

			<xsl:apply-templates select="jma:*">
				<xsl:with-param name="raport" select="'Aktywa'"/>
				<xsl:with-param name="schemat" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>
			</xsl:apply-templates>

			<tr class="sumbil">
				<td>
				</td>
				<td class="test">
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Aktywa'"/>
						<xsl:with-param name="schemat" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>
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

<xsl:template match="jma:Pasywa">
	<table cellspacing="0" cellpadding="0" class="raport bilans mala pasywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>P A S Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="jma:*">
				<xsl:with-param name="raport" select="'Pasywa'"/>
			</xsl:apply-templates>
			<tr class="sumbil">
				<td>
				</td>
				<td>
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Pasywa'"/>
						<xsl:with-param name="schemat" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>
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


<xsl:template match="jin:Aktywa">
	<table cellspacing="0" cellpadding="0" class="raport bilans aktywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>A K T Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>

			<xsl:apply-templates select="jin:*">
				<xsl:with-param name="raport" select="'Aktywa'"/>
			</xsl:apply-templates>

			<tr class="sumbil">
				<td>
				</td>
				<td class="test">
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Aktywa'"/>
						<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>
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

<xsl:template match="jin:Pasywa">
	<table cellspacing="0" cellpadding="0" class="raport bilans pasywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>P A S Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="jin:*">
				<xsl:with-param name="raport" select="'Pasywa'"/>
			</xsl:apply-templates>
			<tr class="sumbil">
				<td>
				</td>
				<td>
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Pasywa'"/>
						<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>
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

<xsl:template match="jma:*">
	<xsl:param name="raport"/>
	
    <xsl:variable name="klu">
		<xsl:call-template name="klu-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
		</xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="wyr">
		<xsl:call-template name="wyr-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
		</xsl:call-template>
    </xsl:variable>
        
    <xsl:variable name="nazwa">
		<xsl:call-template name="nazwa-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
			<xsl:with-param name="schemat" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>
		</xsl:call-template>    
    </xsl:variable>
    
    <xsl:variable name="kwotaa">
		<xsl:choose>
			<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
				<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaA"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./dtsf:KwotaA"/>
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:variable>
    
    <xsl:variable name="kwotab">
		<xsl:choose>
			<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
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
		<td class="tekst klu{$klu}">
			<xsl:value-of select="$nazwa"/>
		</td>
		<td class="kwoty ar {$ujemnaa}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota">
					<xsl:choose>
						<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
							<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaA"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./dtsf:KwotaA"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</td>
		<td class="kwoty ar {$ujemnab}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota">
					<xsl:choose>
						<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
							<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaB"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./dtsf:KwotaB"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</td>
	</tr>
	<xsl:apply-templates select="jma:*">
		<xsl:with-param name="raport" select="$raport"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="jin:*">
	<xsl:param name="raport"/>
	
    <xsl:variable name="klu">
		<xsl:call-template name="klu-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
		</xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="wyr">
		<xsl:call-template name="wyr-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
		</xsl:call-template>
    </xsl:variable>
        
    <xsl:variable name="nazwa">
		<xsl:call-template name="nazwa-pozycji">
			<xsl:with-param name="raport" select="$raport"/>
			<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>
		</xsl:call-template>    
    </xsl:variable>
    
    <xsl:variable name="kwotaa">
		<xsl:choose>
			<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
				<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaA"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./dtsf:KwotaA"/>
			</xsl:otherwise>
		</xsl:choose>    
    </xsl:variable>
    
    <xsl:variable name="kwotab">
		<xsl:choose>
			<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
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
		<td class="tekst klu{$klu}">
			<xsl:value-of select="$nazwa"/>
		</td>
		<td class="kwoty ar {$ujemnaa}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota">
					<xsl:choose>
						<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
							<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaA"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./dtsf:KwotaA"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</td>
		<td class="kwoty ar {$ujemnab}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota">
					<xsl:choose>
						<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca'">
							<xsl:value-of select="./dtsf:KwotyPozycji/dtsf:KwotaB"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./dtsf:KwotaB"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</td>
	</tr>
	<xsl:apply-templates select="jin:*">
		<xsl:with-param name="raport" select="$raport"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="tns:RZiSJednostkaMala">
	<section class="pbb">
		<xsl:apply-templates select="jma:RZiSKalk"/>
		<xsl:apply-templates select="jma:RZiSPor"/>
	</section>
</xsl:template>

<xsl:template match="tns:RZiSJednostkaInna">
	<section class="pbb">
		<xsl:apply-templates select="jin:RZiSKalk"/>
		<xsl:apply-templates select="jin:RZiSPor"/>
	</section>
</xsl:template>

<xsl:template match="jma:RZiSPor">
	<div class="tyt">
		Rachunek zysków i strat<br/>
		<span class="pod">Wersja porównawcza</span>
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
			<xsl:apply-templates select="jma:*">
				<xsl:with-param name="raport" select="'RZiSPor'"/>
				<xsl:with-param name="schemat" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>			
			</xsl:apply-templates>
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="jma:RZiSKalk">
	<div class="tyt">
		Rachunek zysków i strat<br/>
		<span class="pod">Wersja kalkulacyjna</span>
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
			<xsl:apply-templates select="jma:*">
				<xsl:with-param name="raport" select="'RZiSKalk'"/>
				<xsl:with-param name="schemat" select="'JednostkaMalaStrukturyDanychSprFin_v1-0.xsd'"/>		
			</xsl:apply-templates>	
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="jin:RZiSPor">
	<div class="tyt">
		Rachunek zysków i strat<br/>
		<span class="pod">Wersja porównawcza</span>
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
			<xsl:apply-templates select="jin:*">
				<xsl:with-param name="raport" select="'RZiSPor'"/>
				<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>			
			</xsl:apply-templates>
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="jin:RZiSKalk">
	<div class="tyt">
		Rachunek zysków i strat<br/>
		<span class="pod">Wersja kalkulacyjna</span>
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
			<xsl:apply-templates select="jin:*">
				<xsl:with-param name="raport" select="'RZiSKalk'"/>
				<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>	
			</xsl:apply-templates>	
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="tns:ZestZmianWKapitaleJednostkaInna">
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
				<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>		
			</xsl:apply-templates>	
		</tbody>
	</table>
	</section>
</xsl:template>


<xsl:template match="tns:RachPrzeplywowJednostkaInna">
	<section class="pbb">
		<xsl:apply-templates select="jin:PrzeplywyPosr"/>
		<xsl:apply-templates select="jin:PrzeplywyBezp"/>
	</section>	
</xsl:template>

<xsl:template match="jin:PrzeplywyPosr">
	<div class="tyt">
		Rachunek przepływów pieniężnych<br/>
		<span class="pod">Metoda pośrednia</span>
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
				<xsl:with-param name="raport" select="'PrzeplywyPosr'"/>
				<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>			
			</xsl:apply-templates>	
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="jin:PrzeplywyBezp">
	<div class="tyt">
		Rachunek przepływów pieniężnych<br/>
		<span class="pod">Metoda bezpośrednia</span>
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
				<xsl:with-param name="raport" select="'PrzeplywyBezp'"/>
				<xsl:with-param name="schemat" select="'JednostkaInnaStrukturyDanychSprFin_v1-0.xsd'"/>
			</xsl:apply-templates>	
		</tbody>
	</table>	
</xsl:template>



<xsl:template match="tns:DodatkoweInformacjeIObjasnieniaJednostkaInna">
	<section class="pbb">
		<div class="tyt">Dodatkowe informacje i objaśnienia</div>
		
		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<div class="sek">
			<div class="tyt2">Załączniki do sprawozdania</div>
			<table cellspacing="0" cellpadding="0">
			<thead>
				<tr class="rh"><th>Opis</th><th>Nazwa pliku</th></tr>
			</thead>
			<tbody>
			<xsl:for-each select="tns:DodatkoweInformacjeIObjasnienia">
				<xsl:variable name="plik_id" select="dtsf:Plik/comment()"/>
				<xsl:variable name="zawartosc" select="dtsf:Plik/dtsf:Zawartosc"/>
				<xsl:variable name="nazwa" select="dtsf:Plik/dtsf:Nazwa"/>
				<tr>
					<td>
						<xsl:call-template name="print-paras">
							<xsl:with-param name="text" select="dtsf:Opis"/>
						</xsl:call-template>
					</td>
					<td><a class="lnk" href="{'data:application/octet-stream;base64,'}{$zawartosc}" download="{$nazwa}">
							<xsl:call-template name="replace-str">
								<xsl:with-param name="str" select="dtsf:Plik/dtsf:Nazwa" />
								<xsl:with-param name="find" select="'_'" />
								<xsl:with-param name="replace" select="' '" />
							</xsl:call-template>
							<!-- xsl:value-of select="dtsf:Plik/dtsf:Nazwa"/-->
						</a>
					</td>
				</tr>
			</xsl:for-each>
			</tbody>
			</table>
		</div>			
	</section>	
</xsl:template>

<xsl:template match="tns:DodatkoweInformacjeIObjasnieniaJednostkaMala">
	<section class="pbb">
		<div class="tyt">Dodatkowe informacje i objaśnienia</div>
		
		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<div class="sek">
			<div class="tyt2">Załączniki do sprawozdania</div>
			<table cellspacing="0" cellpadding="0">
			<thead>
				<tr class="rh"><th>Opis</th><th>Nazwa pliku</th></tr>
			</thead>
			<tbody>
			<xsl:for-each select="tns:DodatkoweInformacjeIObjasnienia">
				<xsl:variable name="plik_id" select="dtsf:Plik/comment()"/>
				<xsl:variable name="zawartosc" select="dtsf:Plik/dtsf:Zawartosc"/>
				<xsl:variable name="nazwa" select="dtsf:Plik/dtsf:Nazwa"/>
				<tr>
					<td>
						<xsl:call-template name="print-paras">
							<xsl:with-param name="text" select="dtsf:Opis"/>
						</xsl:call-template>
					</td>
					<td><a class="lnk" href="{'data:application/octet-stream;base64,'}{$zawartosc}" download="{$nazwa}">
							<xsl:call-template name="replace-str">
								<xsl:with-param name="str" select="dtsf:Plik/dtsf:Nazwa" />
								<xsl:with-param name="find" select="'_'" />
								<xsl:with-param name="replace" select="' '" />
							</xsl:call-template>
							<!-- xsl:value-of select="dtsf:Plik/dtsf:Nazwa"/-->
						</a>
					</td>
				</tr>
			</xsl:for-each>
			</tbody>
			</table>
		</div>			
	</section>	
</xsl:template>


<xsl:template match="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego">
	<xsl:variable name="kapitalowe" select=".//dtsf:KwotaB"/>
	<xsl:variable name="podstawa" select=".//dtsf:PodstawaPrawna"/>
	<xsl:variable name="poprzedni" select=".//dtsf:RP"/>
	<xsl:variable name="wyr">
		<xsl:if test="//dtsf:PozycjaUzytkownika">wyrUBS</xsl:if>
	</xsl:variable>
	
	<div class="sek">
		<div class="tyt2">Rozliczenie różnicy pomiędzy podstawą opodatkowania podatkiem dochodowym a wynikiem finansowym (zyskiem, stratą) brutto</div>
	
		<table cellspacing="0" cellpadding="0" class="raport podatek">
		<thead>
			<tr class="rh">
				<th>Pozycja / wyszczególnienie</th>
				<th class="ar">Rok bieżący<br/>Łącznie</th>
				<xsl:if test="$kapitalowe">
					<th class="ar">Rok bieżący<br/>z zysków kapitałowych</th>
					<th class="ar">Rok bieżący<br/>z innych źródeł</th>
				</xsl:if>
				<xsl:if test="$podstawa">
					<th>Podstawa prawna</th>
				</xsl:if>
				<xsl:if test="$poprzedni">
					<th class="ar">Rok poprzedni<br/>Łącznie</th>
				</xsl:if>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates>
				<xsl:with-param name="kapitalowe" select="$kapitalowe"/>
				<xsl:with-param name="podstawa" select="$podstawa"/>
				<xsl:with-param name="poprzedni" select="$poprzedni"/>
				<xsl:with-param name="wyroznienie" select="$wyr"/>
			</xsl:apply-templates>
		</tbody>
		</table>
	</div>
			
</xsl:template>
		
<xsl:template match="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego/*">
	<xsl:param name="kapitalowe"/>
	<xsl:param name="podstawa"/>
	<xsl:param name="poprzedni"/>
	<xsl:param name="wyroznienie"/>

	<tr class="{$wyroznienie}">
		<td class="tekst">
			<xsl:call-template name="nazwa-podatek">
				<xsl:with-param name="raport" select="'Podatek'"/>
			</xsl:call-template>
		</td>
		
		<xsl:choose>
			<xsl:when test="dtsf:Kwota/dtsf:RB/dtsf:KwotaA">
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="dtsf:Kwota/dtsf:RB/dtsf:KwotaA"/>
					</xsl:call-template>
				</td>
				<xsl:if test="$kapitalowe">
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="dtsf:Kwota/dtsf:RB/dtsf:KwotaB"/>
					</xsl:call-template>
				</td>
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="dtsf:Kwota/dtsf:RB/dtsf:KwotaC"/>
					</xsl:call-template>
				</td>
				</xsl:if>
				
				<xsl:if test="$podstawa">
					<td></td>
				</xsl:if>
								
				<xsl:if test="$poprzedni">
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="dtsf:Kwota/dtsf:RP/dtsf:KwotaA"/>
					</xsl:call-template>
				</td>
				</xsl:if>
			</xsl:when>
			
			<xsl:otherwise>
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:RB"/>
					</xsl:call-template>
				</td>
	
				<xsl:if test="$kapitalowe">
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:RB/dtsf:KwotaB"/>
					</xsl:call-template>
				</td>
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="./dtsf:RB/dtsf:KwotaC"/>
					</xsl:call-template>
				</td>
				</xsl:if>
				
				<xsl:if test="$podstawa">
					<td> </td>
				</xsl:if>
				<xsl:if test="$poprzedni">
				<td class="kwotyp ar">
					<xsl:call-template name="tkwotowy">
						<xsl:with-param name="kwota" select="dtsf:RP"/>
					</xsl:call-template>
				</td>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:apply-templates select="dtsf:PozycjaUzytkownika">
			<xsl:with-param name="kapitalowe" select="$kapitalowe"/>
			<xsl:with-param name="podstawa" select="$podstawa"/>
			<xsl:with-param name="poprzedni" select="$poprzedni"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="dtsf:Pozostale">
			<xsl:with-param name="kapitalowe" select="$kapitalowe"/>
			<xsl:with-param name="podstawa" select="$podstawa"/>
			<xsl:with-param name="poprzedni" select="$poprzedni"/>
		</xsl:apply-templates>
	</tr>
</xsl:template>

<xsl:template match="dtsf:PozycjaUzytkownika">
	<xsl:param name="kapitalowe"/>
	<xsl:param name="podstawa"/>
	<xsl:param name="poprzedni"/>
	<xsl:variable name="kwotaa" select="dtsf:Kwoty/dtsf:RB/dtsf:Kwota/dtsf:KwotaA"/>
    <xsl:variable name="ujemnaa">
    	<xsl:call-template name="znak_kwoty">
    		<xsl:with-param name="kwota" select="$kwotaa"/>
    	</xsl:call-template>
    </xsl:variable>

	<tr>
		<td class="tekst klu20">
			<xsl:value-of select="dtsf:NazwaPozycji"/>
		</td>
		<td class="kwotyp ar {$ujemnaa}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="$kwotaa"/>
			</xsl:call-template>
		</td>
		
		<xsl:if test="$kapitalowe">
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:Kwoty/dtsf:RB/dtsf:Kwota/dtsf:KwotaB"/>
			</xsl:call-template>
		</td>
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:Kwoty/dtsf:RB/dtsf:Kwota/dtsf:KwotaC"/>
			</xsl:call-template>
		</td>
		</xsl:if>
		
		<xsl:if test="$podstawa">
			<td class="pp">
				<xsl:apply-templates select=".//dtsf:PodstawaPrawna/*"/>
			</td>
		</xsl:if>
						
		<xsl:if test="$poprzedni">
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:Kwoty/dtsf:RP/dtsf:KwotaA"/>
			</xsl:call-template>
		</td>
		</xsl:if>
	</tr>
</xsl:template>

<xsl:template match="dtsf:Pozostale">
	<xsl:param name="kapitalowe"/>
	<xsl:param name="podstawa"/>
	<xsl:param name="poprzedni"/>

	<tr>
		<td class="tekst klu20">
			pozostałe
		</td>

		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:RB/dtsf:KwotaA"/>
			</xsl:call-template>
		</td>

		<xsl:if test="$kapitalowe">
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:RB/dtsf:KwotaB"/>
			</xsl:call-template>
		</td>
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:RB/dtsf:KwotaC"/>
			</xsl:call-template>
		</td>
		</xsl:if>

		<xsl:if test="$podstawa">
			<td class="pp">
			</td>
		</xsl:if>

		<xsl:if test="$poprzedni">
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:RP/dtsf:KwotaA"/>
			</xsl:call-template>
		</td>
		</xsl:if>
	</tr>
</xsl:template>

<xsl:template match="dtsf:PodstawaPrawna/dtsf:*">
	<xsl:if test=".">
		<xsl:if test="position() > 1">
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="translate(substring-after(name(.), ':'), $upper, $lower)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="text()"/>
	</xsl:if>
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
		<xsd:enumeration value="0">UBS</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="RZiSPor">
		<xsd:enumeration value="0">UBS</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="ZestZmianWKapitaleJednostkaMala">
		<xsd:enumeration value="0">UBS</xsd:enumeration>
		<xsd:enumeration value="1">B</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="PrzeplywyBezp">
		<xsd:enumeration value="0">UBS</xsd:enumeration>
		<xsd:enumeration value="1">B</xsd:enumeration>
	</xsd:simpleType>
	<xsd:simpleType name="PrzeplywyPosr">
		<xsd:enumeration value="0">UBS</xsd:enumeration>
		<xsd:enumeration value="1">U</xsd:enumeration>
	</xsd:simpleType>
</xsl:variable>

</xsl:stylesheet>
