<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaWZlotych"
	xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" 
>

<!-- Nazwy pozycli rozliczenia podatku -->
<xsl:param name="schema-podatek" select="'StrukturyDanychSprFin_v1-1.xsd'"/>
<!-- Nazwy kodów PKD -->
<xsl:param name="schema-pkd" select="'KodyPKD_v2-0E.xsd'"/>

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
		<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca' or substring-after(name(.), ':') = 'Podpozycja' or substring-after(name(.), ':') = 'PozycjaUszczegolawiajaca'">
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
		<xsl:when test="substring-before(substring-after(name(.), ':'), '_') = 'PozycjaUszczegolawiajaca' or substring-after(name(.), ':') = 'Podpozycja' or substring-after(name(.), ':') = 'PozycjaUszczegolawiajaca'">
			<xsl:value-of select="./dtsf:NazwaPozycji"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
			 	<xsl:when test="$procesor = 'serwer'">
					<!-- Obsługa przetwarzania XSLT po stronie serwera -->
					  
					<xsl:variable name="schema" select="$schemat"/>
					
					<xsl:choose>
						<xsl:when test="$raport = 'ZestZmianWKapitaleJednostkaInna'">
							<!-- Drzewo dla zmian w kapitale ma nieco inną strukturę niż pozostałe raporty -->
							<xsl:value-of select="$schema//xsd:complexType[@name=$raport]//xsd:element[@name=$wyliczenie]//xs:documentation"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="naz" select="$schemat//xsd:element[@name=$raport]//xsd:element[@name=$wyliczenie]//xs:documentation"/>
							<xsl:choose>
								<xsl:when test="$naz">
									<xsl:value-of select="$naz"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$schemat//xsd:element[@name=$wyliczenie]//xs:documentation"/>
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
						<xsl:when test="$raport = 'ZestZmianWKapitaleJednostkaInna'">
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

<xsl:template name="wyr-pozycji">
	<!-- Ustalenie klasy CSS wyróżnienia wiersza raportu -->
	<xsl:param name="raport"/>
	<xsl:param name="level"/>
	
	<xsl:variable name="wyr" select="exsl:node-set($wyroznienia)/xsd:simpleType[@name=$raport]/xsd:enumeration[@value=$level]"/>
	
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

</xsl:stylesheet>