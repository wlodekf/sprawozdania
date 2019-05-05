<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

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