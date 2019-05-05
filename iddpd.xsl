<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dtsf="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/DefinicjeTypySprawozdaniaFinansowe/"
	xmlns:tns="http://www.mf.gov.pl/schematy/SF/DefinicjeTypySprawozdaniaFinansowe/2018/07/09/JednostkaMikroWZlotych" 
>

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

</xsl:stylesheet>