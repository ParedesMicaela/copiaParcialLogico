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

%moneda(Destino, Moneda).
moneda(rioDeJaneiro, real).
moneda(osaka, yen).
moneda(shenzhen, renminbi).
moneda(unaIsla, ariaryMalgache).
moneda(madrid, ariaryMalgache).
moneda(mykonos, yen).

%cambioAPesos(Moneda, Conversion).
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
indiceDeExtravagancia(UnaEmpresa,UnIndice):-
    cantidadDeVentasExtravagantes(UnaEmpresa,Cantidad),
    UnIndice is Cantidad / 100.

cantidadDeVentasExtravagantes(UnaEmpresa,Cantidad):-
    esUnaEmpresa(UnaEmpresa),
    forall(destinoQueVendeUnaEmpresa(UnaEmpresa,Destino),esVentaExtravagante(UnaEmpresa,UnDestino)).

esVentaExtravagante(UnaEmpresa,UnDestino):-
    findall(Destino,destinoQueVendeUnaEmpresa(UnaEmpresa,Destino),VentasExtravagantes),
    length(VentasExtravagantes, Cantidad).
    

esUnaEmpresa(UnaEmpresa):-
    vende(UnaEmpresa,_,_).
