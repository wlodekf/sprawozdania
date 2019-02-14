# Wizualizacja sprawozdań finansowych w formacie XML

Wizualizacja robiona jest przy pomocy dostępnego w repozytorium arkusza XSL/XSLT (sf.xsl).

Wizualizację można zrobić na dwa sposoby

## Lokalny serwer HTTP/WWW

Dodajemy linię referencji do pliku sf.xsl w nagłówku pliku XML sprawozdania (po pierwszej linii)

```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="sf.xsl"?>
<tns:JednostkaInna
...
```

Wrzucamy ten plik na serwer łącznie z załączonymi plikami *.xsd i sf.xsl, 
otwieramy plik sprawozdania XML w przeglądarce i powinna pokazać się wizualizacja sprawozdania.

Jeżeli na przykład mamy zainstalowanego pythona wrzucamy wszystkie pliki z repozytorium do jakiegoś katalogu, 
modyfikujemy plik sprawozdania jak powyżej i wrzucamy do tego samego katalogu, 
odpalamy serwer HTTP
```
python -m SimpleHTTPServer 8080
```
i otwieramy plik XML sprawozdania w przeglądarce (localhost:8080/plik.xml).

Serwer jest konieczny ponieważ plik XML po powyższej modyfikacji nie daje się poprawnie otworzyć 
przy pomocy "Otwórz plik". Ma to związek z kwestiami bezpieczeństwa. 
Konieczne jest użycie dowolnego choćby minimalnego serwera WWW, który wyśle wszystkie pliki (sprawozdanie, arkusz, słowniki nazw).

## Udostępniona strona WWW

Pod adresem http://sprawozdania.co.pl dostępna jest prosta strona WWW, która umożliwia wybranie pliku XML sprawozdania 
z lokalnego komputera i wykonuje całe przetwarzanie (XSLT) w jednym z dwóch wariantów

1. Lokalnie (przy pomocy JS) w przeglądarce

Plik sprawozdania XML nie jest nigdzie wysyłany.

2. Wysłając plik XML na serwer

Na serwerze do pliku XML dodawane jest powyższa linia i zmodyfikowany plik XML jest odsyłany.
 
Wprawdzie sprawozdania składane do KRS i tak są jawne ale jeżeli chcemy mieć pewność, 
że sprawozdanie nie wydostaje się z naszego komputera (bo np. jest to wersja wstępna) 
to można też sklonować czy skopiować zawartość repozytorium i otworzyć z dowolnego 
innego miejsca (serwer WWW).

## Ograniczenia

Wizualizowane mogą być tylko pliki przed podpisaniem elektronicznym (lub pobrane z KRS jako "Pokaż treść dokumentu").

W raportach/sprawozdaniach widoczne są tylko te linie, które znajdują się w pliku XML. 
Jeżeli niektóre linie zostały pominięte ponieważ zawierały same 0 (takie linie są opcjonalne więc można je pominąć) 
to w wizualizacji nie będą widoczne. 
Jeżeli chcemy mieć pełną postać sprawozdań (również z pozycjami/liniami zerowymi/pustymi - tak jak to się najczęściej widuje) 
to muszą się one znajdować w pliku XML (z zerowymi wartościami).

Powinno działać pod Chrome, Firefox, Safari. Edge do sprawdzenia, w IE można nie próbować.
