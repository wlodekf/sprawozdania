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
	<table cellspacing="0" cellpadding="0" class="raport bilans {$mikro} aktywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>A K T Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>

			<xsl:apply-templates select="jmi:*">
				<xsl:with-param name="raport" select="'Aktywa'"/>
				<xsl:with-param name="schemat" select="$jmi-nazwy"/>
			</xsl:apply-templates>

			<tr class="sumbil">
				<td>
				</td>
				<td class="test">
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Aktywa'"/>
						<xsl:with-param name="schemat" select="$jmi-nazwy"/>
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

<xsl:template match="jmi:Pasywa">
	<table cellspacing="0" cellpadding="0" class="raport bilans {$mikro} pasywa">
		<thead>
			<tr class="rh">
				<th class="al">Lp</th>
				<th>P A S Y W A</th>
				<th class="ar">Bieżący okres</th>
				<th class="ar end">Poprzedni okres</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates select="jmi:*">
				<xsl:with-param name="raport" select="'Pasywa'"/>
			</xsl:apply-templates>
			<tr class="sumbil">
				<td>
				</td>
				<td>
					<xsl:call-template name="nazwa-pozycji">
						<xsl:with-param name="raport" select="'Pasywa'"/>
						<xsl:with-param name="schemat" select="$jmi-nazwy"/>
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

<xsl:template match="tns:RZiSJednostkaMikro">
	<section class="pbb">
	<div class="tyt">
		Rachunek zysków i strat<br/>
		<span class="pod">jednostki mikro</span>
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
			<xsl:apply-templates select="jmi:*">
				<xsl:with-param name="raport" select="'RZiSJednostkaMikro'"/>
				<xsl:with-param name="schemat" select="$jmi-nazwy"/>		
			</xsl:apply-templates>	
		</tbody>
	</table>
	</section>
</xsl:template>

<xsl:template match="jmi:RZiSPor">
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
			<xsl:apply-templates select="jmi:*">
				<xsl:with-param name="raport" select="'RZiSPor'"/>
				<xsl:with-param name="schemat" select="$jmi-nazwy"/>			
			</xsl:apply-templates>
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="jmi:RZiSKalk">
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
			<xsl:apply-templates select="jmi:*">
				<xsl:with-param name="raport" select="'RZiSKalk'"/>
				<xsl:with-param name="schemat" select="$jmi-nazwy"/>		
			</xsl:apply-templates>	
		</tbody>
	</table>	
</xsl:template>

<xsl:template match="jmi:*">
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
			<xsl:with-param name="schemat" select="$jmi-nazwy"/>
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
    
	<tr class="{$wyr} {$empty} mikro">
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
	<xsl:apply-templates select="jmi:*">
		<xsl:with-param name="raport" select="$raport"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="tns:InformacjeUzupelniajaceDoBilansuJednostkaMikro">
	<section class="pbb">
		<div class="tyt">Informacje uzupełniające do bilansu zgodnie z Załącznikiem Nr 4 do ustawy o rachunkowości</div>

		<xsl:apply-templates select="tns:InformacjaDodatkowaDotyczacaPodatkuDochodowego"/>
		
		<div class="sek">
			<div class="tyt2">Informacje uzupełniające do bilansu</div>
			<table cellspacing="0" cellpadding="0">
			<thead>
				<tr class="rh"><th>Opis</th><th>Plik</th></tr>
			</thead>
			<tbody>
			<xsl:for-each select="tns:InformacjeUzupelniajaceDoBilansu">
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

</xsl:stylesheet>
