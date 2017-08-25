#!/usr/bin/python3
#Script che parsa il file content.xml contenuto all'interno di un file ods
#conteggia tuttle celle che hanno un dato attributo di un certo valore
#Usato per il conteggio dei fumetti
from xml.dom import minidom
xmldoc = minidom.parse('content.xml')
itemlist = xmldoc.getElementsByTagName('table:table-cell')
print('Topolino spuntati: ')
counter = 14 #prima della serie 600
#ventine completate 840-860-880-900-1680-1740-1760-1780-1980-2080-2140
counter += 11*20 #10 è il numero di ventine
moderni = 3110 - 2220 #prima numero moderno posseduto, da oggi in poi li ho tutti
counter += moderni
for s in itemlist:
    search = s.toxml()
    if search.find('ce5') != -1:
        counter += 1
print(counter)