<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMikroWZlotych" 
>

<xsl:template name="informacjaDodatkowaDotyczacaPodatkuDochodowego">
	
	<xsl:variable name="kapitalowe" select="count(.//dtsf:RB/dtsf:KwotaB[text() != '0.00']) + count(.//dtsf:RB/dtsf:KwotaC[text() != '0.00'])"/>
	<xsl:variable name="podstawa" select=".//dtsf:PodstawaPrawna"/>
	<xsl:variable name="poprzedni" select="count(.//dtsf:RP/dtsf:KwotaA[text() != '0.00']) + count(.//dtsf:RP/dtsf:KwotaB[text() != '0.00']) + count(.//dtsf:RP/dtsf:KwotaC[text() != '0.00'])"/>
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
				<xsl:if test="$kapitalowe &gt; 0">
					<th class="ar">Rok bieżący<br/>z zysków kapitałowych</th>
					<th class="ar">Rok bieżący<br/>z innych źródeł</th>
				</xsl:if>
				<xsl:if test="$podstawa">
					<th>Podstawa prawna</th>
				</xsl:if>
				<xsl:if test="$poprzedni &gt; 0">
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

<xsl:template name="informacjaDodatkowaDotyczacaPodatkuDochodowego-Pozycje">
	
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
				<xsl:if test="$kapitalowe &gt; 0">
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
								
				<xsl:if test="$poprzedni &gt; 0">
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
	
				<xsl:if test="$kapitalowe &gt; 0">
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
				<xsl:if test="$poprzedni &gt; 0">
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
	<xsl:variable name="nie0" select="count(.//dtsf:KwotaA[text() != '0.00']) + count(.//dtsf:KwotaB[text() != '0.00']) + count(.//dtsf:KwotaC[text() != '0.00'])"/>
    <xsl:variable name="ujemnaa">
    	<xsl:call-template name="znak_kwoty">
    		<xsl:with-param name="kwota" select="$kwotaa"/>
    	</xsl:call-template>
    </xsl:variable>

	<xsl:if test="$nie0 &gt; 0">
	<tr>
		<td class="tekst klu20">
			<xsl:value-of select="dtsf:NazwaPozycji"/>
		</td>
		<td class="kwotyp ar {$ujemnaa}">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="$kwotaa"/>
			</xsl:call-template>
		</td>
		
		<xsl:if test="$kapitalowe &gt; 0">
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
						
		<xsl:if test="$poprzedni &gt; 0">
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:Kwoty/dtsf:RP/dtsf:KwotaA"/>
			</xsl:call-template>
		</td>
		</xsl:if>
	</tr>
	</xsl:if>
</xsl:template>

<xsl:template match="dtsf:Pozostale">
	<xsl:param name="kapitalowe"/>
	<xsl:param name="podstawa"/>
	<xsl:param name="poprzedni"/>

	<xsl:variable name="nie0" select="count(.//dtsf:KwotaA[text() != '0.00']) + count(.//dtsf:KwotaB[text() != '0.00']) + count(.//dtsf:KwotaC[text() != '0.00'])"/>
	
	<xsl:if test="$nie0 &gt; 0">
	<tr>
		<td class="tekst klu20">
			pozostałe
		</td>

		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:RB/dtsf:KwotaA"/>
			</xsl:call-template>
		</td>

		<xsl:if test="$kapitalowe &gt; 0">
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

		<xsl:if test="$poprzedni &gt; 0">
		<td class="kwotyp ar">
			<xsl:call-template name="tkwotowy">
				<xsl:with-param name="kwota" select="dtsf:RP/dtsf:KwotaA"/>
			</xsl:call-template>
		</td>
		</xsl:if>
	</tr>
	</xsl:if>
	
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

</xsl:stylesheet>