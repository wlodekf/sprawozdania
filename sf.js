const xsltProcessor = new XSLTProcessor();

const kopiaElementow = (xsl, zmienna, xml, tag, elementy) => {
	// Ustalenie elementu ze zmienną, do której zostanie przeniesiony odpowiedni słownik
	let varNode;
	for (let el of xsl.getElementsByTagName("xsl:variable")) {
		if (el.getAttribute('name') == zmienna)
			varNode= el;
	}

	// Przeniesienie wskazanych elementów z pliku schematu do arkusza transformacji	
  	let elements= xml.children[0].children;
  	for(let el of elements) {
  		if (!elementy || elementy.includes(el.getAttribute('name'))) {
  			const rootNode= xsl.importNode(el, true);
  			varNode.appendChild(rootNode);
  		}
  	}
}

function saveXml(xml) {
	var formData= new FormData();
	formData.append('file2', xml);
	var xhr = new XMLHttpRequest();
	xhr.open('POST', '/xml', true);
	xhr.onload = () => {
       console.log(xhr.statusText, xhr.responseXML);
    };
    xhr.onerror = () => {
       console.error(xhr.statusText);
    };
	xhr.send(formData);
}

const loadXML = async (url) => {
    return new Promise(function (resolve, reject) {
        let xhr = new XMLHttpRequest();
        xhr.open("GET", url, true);
        xhr.onload = function () {
            if (this.status >= 200 && this.status < 300) {
                resolve(xhr.responseXML);
            } else {
                reject({
                    status: this.status,
                    statusText: xhr.statusText
                });
            }
        };
        xhr.onerror = function () {
            reject({
                status: this.status,
                statusText: xhr.statusText
            });
        };
        xhr.send();
    });
}

(async () => {
	const xsl= await loadXML("JednostkaInna.xsl");
	
	// Obejście braku obsługi funkcji document() w chrome
	
	const nazwy= await loadXML('JednostkaInnaStrukturyDanychSprFin_v1-0.xsd');
	kopiaElementow(xsl, "nazwy", nazwy, "xsd:complexType", ['BilansJednostkaInna', 'RZiSJednostkaInna', 'ZestZmianWKapitaleJednostkaInna', 'RachPrzeplywowJednostkaInna']);

	const podatek= await loadXML('StrukturyDanychSprFin_v1-1.xsd');
	kopiaElementow(xsl, "podatek", podatek, "xsd:complexType", ['TInformacjaDodatkowaDotyczacaPodatkuDochodowego']);

	const pkd= await loadXML('KodyPKD_v2-0E.xsd');
	kopiaElementow(xsl, "pkd", pkd, "xs:simpleType", null);

	xsltProcessor.importStylesheet(xsl);
	xsltProcessor.setParameter('', 'procesor', 'klient');
	xsltProcessor.setParameter('', 'root', '');
})();

const handleFileSelect3= (evt) => {

	var reader= new FileReader(),
       	parser = new DOMParser(),
		file1= evt.target.files;
    
    reader.onload= (e) => {
		let xml= e.target.result;
		saveXml(xml);		
		// Wydzielenie sprawozdania z podpisanego pliku
		m= new RegExp('<(\\w+:)?JednostkaInna.*</(\\1)?JednostkaInna[^>]*>', 'sm').exec(xml)
		if (m)
			xml= '<?xml version="1.0" encoding="UTF-8"?>\n'+m[0];

		xml= parser.parseFromString(xml, "text/xml");
		resultDocument = xsltProcessor.transformToFragment(xml, document);

		document.getElementById("loader").style.display= "none";
		document.body.appendChild(resultDocument);
    };

    reader.readAsText(file1[0]);
}

const handleFileSelect1= (evt) => {
	document.getElementById("form").submit();
}

const handleFileSelect2= (evt) => {
	document.getElementById("form").submit();
}
