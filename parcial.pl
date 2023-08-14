%vende(Empresa, EstiloDeViaje, Destino).
vende(mcs, crucero(10), rioDeJaneiro).
vende(mcs, crucero(20), mykonos).
vende(vacaviones, allInclusive(burjAlArab), dubai).
vende(vacaviones, allInclusive(wyndhamPlayaDelCarmen), playaDelCarmen).
vende(moxileres, mochila([carpa, bolsaDeDormir, linterna]), elBolson).
vende(moxileres, mochila([camara, cantimplora, protectorSolar, malla]), puntaDelDiablo).
vende(tuViaje, clasico(primavera, avion), madrid).
vende(tuViaje, clasico(verano, micro), villaGesell).
vende(moxileres, crucero(400), rioDeJaneiro).
vende(moxileres, mochila([]), osaka).

%crucero(CantidadDeDias).
%allInclusive(Hotel).
%mochila(Objetos).
%clasico(Temporada, MedioDeTransporte).

%continente(Destino, Continente).
continente(rioDeJaneiro, sudAmerica).
continente(mykonos, europa).
continente(dubai, asia).
continente(playaDelCarmen, centroAmerica).
continente(puntaDelDiablo, sudAmerica).
continente(madagascar, africa).
continente(madrid, europa).
continente(unaIsla, asia).
continente(osaka, asia).
continente(sidney, oceania).
continente(oranjestad, aruba).

%moneda(Destino, Moneda).
moneda(rioDeJaneiro, real).
moneda(osaka, yen).
moneda(shenzhen, renminbi).
moneda(unaIsla, ariaryMalgache).
moneda(madrid, ariaryMalgache).
moneda(mykonos, yen).
moneda(sidney, dolarAustraliano).

%cambioAPesos(Moneda, Conversion).
cambioAPesos(dolarAustraliano, 187).
cambioAPesos(real, 58).
cambioAPesos(yen, 2).
cambioAPesos(pesoMexicano, 17).
cambioAPesos(ariaryMalgache, 0.063).

%Punto 1
viajaA(UnaEmpresa,UnContinente):-
    vendeDestinoEnCiertoContinente(UnaEmpresa,UnContinente).

vendeDestinoEnCiertoContinente(UnaEmpresa,UnContinente):-
    vende(UnaEmpresa,_,UnDestino),
    continente(UnDestino,UnContinente).

%Punto 2
esMasCaro(UnDestino,OtroDestino):-
    conversionAPesosArgentinos(UnDestino,UnaConversionAPesos),
    conversionAPesosArgentinos(OtroDestino,OtraConversionAPesos),
    UnaConversionAPesos > OtraConversionAPesos.

conversionAPesosArgentinos(UnDestino,UnaConversionAPesos):-
    moneda(UnDestino,UnaMoneda),
    cambioAPesos(UnaMoneda,UnaConversionAPesos).

%Punto 3
conviene(UnDestino):-
    monedaValeMenosQuePesoArgentino(UnDestino),
    noQuedaEnEuropa(UnDestino).

monedaValeMenosQuePesoArgentino(UnDestino):-
    conversionAPesosArgentinos(UnDestino,UnaConversionAPesos),
    UnaConversionAPesos < 1.

noQuedaEnEuropa(UnDestino):-
    esUnDestinoPosible(UnDestino),
    not(continente(UnDestino,europa)).

esUnDestinoPosible(UnDestino):-
    continente(UnDestino,_).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Punto 5
ventaExtravagante(UnDestino):-
    esUnDestinoPosible(UnDestino),
    not(conviene(UnDestino)),
    cumpleRequisitosExtravagantes(UnDestino).

cumpleRequisitosExtravagantes(UnDestino):-
    vende(_,crucero(Duracion),UnDestino),
    Duracion > 365.

cumpleRequisitosExtravagantes(UnDestino):-
    vende(_,mochila([]),UnDestino).

cumpleRequisitosExtravagantes(UnDestino):-
    vende(_,clasico(invierno,tuktuk),UnDestino).

cumpleRequisitosExtravagantes(UnDestino):-
    vende(_,clasico(invierno,bicicleta),UnDestino).

%Punto 6
%como en ventaExtravagante solo me importa el destino,
%en vez de modificarla, hice que me muestre las ventas que hizo la empresa
%y de esas ventas, que cuente los destinos que cumplen con los requisitos de ventaExtravagante
%de esta forma, contar las ventas extravagantes, es lo mismo que contar las cantidad de destinos extravagantes
%que se vendieron.
indiceDeExtravagancia(UnaEmpresa,UnIndice):-
    cantidadDeVentasExtravagantes(UnaEmpresa,Cantidad),
    UnIndice is (Cantidad / 2).

cantidadDeVentasExtravagantes(UnaEmpresa,Cantidad):-
    esUnaEmpresa(UnaEmpresa),
    forall(destinoQueVendeUnaEmpresa(UnaEmpresa,UnDestino),esVentaExtravagante(UnDestino,Cantidad)).

esVentaExtravagante(Destino,Cantidad):-
    findall(Destino,ventaExtravagante(Destino),ListaVentas),
    length(ListaVentas, Cantidad).
    
destinoQueVendeUnaEmpresa(UnaEmpresa,Destino):-
    vende(UnaEmpresa,_,Destino).

esUnaEmpresa(UnaEmpresa):-
    vende(UnaEmpresa,_,_).

%Punto 7
%Por principio de universo cerrado, lo que no esta en la base de datos es falso. Todo lo que esta
%en la base de datos es verdadero, entonces las cosas inciertas o falsas no las pongo.
%Ademas, como todos los predicados son inversibles, podemos poner mas empresas sin problema.
%

vende(pdepViajes, mochila([adaptadorEléctrico, protectorSolar, malla]), oranjestad).
vende(destinoInicial, clasico(otoño, avion), sidney).
vende(destinoInicial, clasico(primavera, avion), osaka).

continente(osaka, asia).
continente(sidney, oceania).
continente(oranjestad, aruba).

moneda(sidney, dolarAustraliano).
cambioAPesos(dolarAustraliano, 187).
