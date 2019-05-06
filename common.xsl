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
	<xsd:simpleType name="ZestZmianWKapitaleJednostkaInna">
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