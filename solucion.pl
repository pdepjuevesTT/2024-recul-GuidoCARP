%se pide que agregue a la base de conocimientos la siguiente informaccion:
/*
juan vive en una casa de 120 metros cuadrados
nico vive en un 3 ambientes con 2 baños al igual que alf, pero alf tiene un baño solo
julian vive en un loft construido en el año 2000
vale vive en un 4 ambientes con 1 baño
*/

% Base de conocimientos
viveEn(juan, casa(120),almagro). %copado
viveEn(nico, departamento(3, 2),almagro). %copado
viveEn(alf, departamento(3, 1),almagro). %no copado
viveEn(julian, loft(2000),almagro). %no copado
viveEn(vale, departamento(4, 1),flores). %copado
viveEn(fer, casa(110),flores).

%felipe y rocio no se modelan

%queremos saber si en un barrio todas las personas viven en propiedades copadas

barrioCopado(Barrio) :-
    viveEn(_, _,Barrio),
    forall(viveEn(Persona,_, Barrio), viveEnPropiedadCopada(Persona)).

%una casa de mas de 100 metros es copada
viveEnPropiedadCopada(Persona):-
    viveEn(Persona, casa(Metros),_),
    Metros > 100.
%un departamento de mas de 3 ambientes es copado

viveEnPropiedadCopada(Persona):-
    viveEn(Persona, departamento(Ambientes,_),_),
    Ambientes > 3.

%Un departamento con mas de 1 baño es copado

viveEnPropiedadCopada(Persona):-
    viveEn(Persona, departamento(_,Banios),_),
    Banios > 1.

%un loft construido despues de 2015 es copado

viveEnPropiedadCopada(Persona):-
    viveEn(Persona, loft(Anio),_),
    Anio > 2015.

%3-ahora necesitamos conocer si hay un barrio caro, en el que no hay una casa que sea barata

%los loft construidos antes del 2005 son baratos
%las casa de menos de 90 metros son baratas
%los departamentos que tienen 1 o 2 ambientes son baratos

barrioCaro(Barrio):-
    viveEn(_, _,Barrio),
    not(hayCasaBarata(Barrio)).

hayCasaBarata(Barrio):-
    viveEn(_, casa(Metros),Barrio),
    Metros < 90.

hayCasaBarata(Barrio):-
    viveEn(_, departamento(Ambientes,_),Barrio),
    Ambientes < 3.

hayCasaBarata(Barrio):-
    viveEn(_, loft(Anio),Barrio),
    Anio < 2005.


%4-tenemos ahora las tasaciones de cada inmueble(eso no invalida el punto 3, la definicion de cara no varia)
% la propiedad de juan vale 150000 uss
% la propiedad de nico vale 80000 uss
% la propiedad de alf vale 75000 uss
% la propiedad de julian vale 140000 uss
% la propiedad de vale vale 75000 uss
% la propiedad de fer vale 95000 uss

/*queremos saber que casas podriamos comprar con una determinada cantidad de plata y cuanta plata nos quedaria,queremos comprar siemrpe al menos una propiedad
el predicado debe asumir que la plata es un argumento no inversible(debe venir siempre)*/

/*
algunos ejemplos:

comprar la casa de juan y quedarnos con uss100000
comprar la casa de juan y la de nico y quedarnos con uss 20000
comprar la casa de juan y de alf y quedarnos con uss 25000
comprar la casa de nico, de alf y de fer, y quedarnos con uss 35000
*/

/*
tip: se puede usar el predicado sublista
*/


sublista([], []).
sublista([_|Cola],Sublista):- sublista(Cola,Sublista).
sublista([Cabeza|Cola],[Cabeza|Sublista]):- sublista(Cola,Sublista).

tasacion(juan,150000).
tasacion(nico,80000).
tasacion(alf,75000).
tasacion(julian,140000).
tasacion(vale,95000).
tasacion(fer,60000).

%juan + nico = 20000 plata restante
%juan + alf = 25000 plata restante
%nico + alf + fer = 35000 plata restante

%siempre debe comprar una propiedad

comprarConPlata(Plata,Propiedades,PlataRestante):-
    findall(Valor, tasacion(_, Valor), Tasaciones),
    sublista(Tasaciones, Propiedades),
    Propiedades \= [], % Asegurarse de que la lista no esté vacía
    sumlist(Propiedades, Total),
    Total =< Plata,
    PlataRestante is Plata - Total.