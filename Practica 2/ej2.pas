{
   ej2.pas
. Se necesita contabilizar los CD vendidos por una discográfica. Para ello se dispone de 
un archivo con la siguiente información: código de autor, nombre del autor, nombre 
disco, género y la cantidad vendida de ese CD. Realizar un programa que muestre un 
listado como el que se detalla a continuación. Dicho listado debe ser mostrado en 
pantalla y además listado en un archivo de texto. En el archivo de texto se debe listar 
nombre del disco, nombre del autor y cantidad vendida. El archivo origen está 
ordenado por código de autor, género y nombre disco.   
   
   
}

program untitled;
uses crt;
const valorAlto= '9999';

type
str4 = String[4];
tCD = record
	codigo : str4;
	autor : String[20];
	nombre : String[20];
	genero : String[20];
	ventas : integer;
	end;

tCarga = file of tCD;

procedure leer (var archivo:tCarga; var dato:tCD);
begin

if (not(EOF(archivo))) then  
		read (archivo, dato)
	 else  dato.codigo := valorAlto; 
end;

var
vDisco, vGenero, vAutor,vTotal : integer;
carga:tCarga;
cd:tCD;
codigoAux,generoAux,discoAux:String[20];
aText: text;
BEGIN
	vTotal:=0;
	assign(carga,'ventasCD.dat');
	assign(aText,'ventas.txt');
	rewrite(aText);
	reset(carga);
	leer(carga,cd);
	while (cd.codigo<>valorAlto) do
	//bucle hasta llegar al fin de archivo. hay que separar por autor genero y disco"
		begin
		vAutor:=0;
		codigoAux:=cd.codigo;
		writeln('Autor: ',cd.autor);
		writeln(aText,'Autor: ',cd.autor);
		while (codigoAux=cd.codigo) do 
		begin
			vGenero:=0;
			generoAux:=cd.genero;
			writeln('genero: ',cd.genero);
			writeln(aText,'genero: ',cd.genero);
			while (generoAux=cd.genero) do 
			begin
				vDisco:=0;
				discoAux:=cd.nombre;
				write('Disco: ',cd.nombre);
				write(aText,'Disco: ',cd.nombre);
				while (discoAux=cd.nombre) do 
				begin
					vDisco:=vDisco +cd.ventas;
					leer(carga,cd);
				end;
				writeln('cantidad vendida: ',vDisco);
				writeln(aText,'cantidad vendida: ',vDisco);
				vGenero:=vDisco+vGenero;
			end;
			writeln('Total Género: ',vGenero);
			writeln(aText,'Total Género: ',vGenero);
			vAutor:=vAutor+vGenero;
		end;
		writeln('Total Autor:: ',vAutor);
		writeln(aText,'Total Autor:: ',vAutor);
		vTotal:=vTotal+vAutor;
	end;
	writeln('Total Discográfica: ',vTotal);
	writeln(aText,'Total Discográfica: ',vTotal);
	close(carga);
	close(aText);
END.

