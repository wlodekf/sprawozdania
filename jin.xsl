<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:jin="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaStruktury"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaInnaWZlotych" 
>

<xsl:variable name="jin-nazwy" select="document('JednostkaInnaStrukturyDanychSprFin_v1-0.xsd')"/>

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
						<xsl:with-param name="schemat" select="$jin-nazwy"/>
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
						<xsl:with-param name="schemat" select="$jin-nazwy"/>
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
			<xsl:with-param name="schemat" select="$jin-nazwy"/>
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

<xsl:template match="tns:RZiSJednostkaInna">
	<xsl:apply-templates select="jin:RZiSKalk"/>
	<xsl:apply-templates select="jin:RZiSPor"/>
</xsl:template>

<xsl:template match="jin:RZiSPor">
	<section class="pbb">
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
					<xsl:with-param name="schemat" select="$jin-nazwy"/>			
				</xsl:apply-templates>
			</tbody>
		</table>	
	</section>
</xsl:template>

<xsl:template match="jin:RZiSKalk">
	<section class="pbb">
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
					<xsl:with-param name="schemat" select="$jin-nazwy"/>	
				</xsl:apply-templates>	
			</tbody>
		</table>	
	</section>
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
				<xsl:with-param name="schemat" select="$jin-nazwy"/>		
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
				<xsl:with-param name="schemat" select="$jin-nazwy"/>			
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
				<xsl:with-param name="schemat" select="$jin-nazwy"/>
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

</xsl:stylesheet>