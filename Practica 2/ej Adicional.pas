{
Archivos 
Se desea actualizar un archivo maestro a partir de 500 archivos detalle de votos de localidades.  


Cada archivo detalle contiene código de provincia, código de localidad, cantidad de votos válidos, cantidad de votos en 
blanco y cantidad de votos anulados.
  El archivo se encuentra ordenado por código de provincia y código de localidad. 
El archivo maestro tiene código de provincia, nombre de provincia, cantidad total de votos válidos, cantidad total de 
votos en blanco y cantidad total de votos anulados. El archivo se encuentra ordenado por código de provincia. 
Realizar la actualización de archivo maestro con la información de los archivos detalles. Además al final se debe 
informar en un archivo de texto denominado cantidad_votos_04_07_2023.txt la cantidad de archivos procesados,  la 
cantidad total de votos válidos, cantidad total de votos en blanco y cantidad total de votos anulados de los archivos 
detalles con el siguiente formato:  
Cantidad de archivos procesados : ___ 
Cantidad Total de votos: __ 
Cantidad de votos válidos: __ 
Cantidad de votos anulados: __ 
Cantidad de votos en blanco: __ 
Se debe realizar el programa completo con sus declaraciones de tipo.  
   
   
}


program untitled;
uses SysUtils;
const cantDetalles = 500;
const valorAlto=9999;
type

tVotoLoc=record
	prov:integer;
	loc:integer;
	validos:integer;
	blancos:integer;
	anulados:integer;
	end;
	
tVotoProv=record
	prov:integer;
	nombreProv:string[10];
	validos:integer;
	blancos:integer;
	anulados:integer;
	end;

tDetalle=file of tVotoLoc;
tMaestro = file of tVotoProv;
atDetalles=array[1..cantDetalles] of tDetalle;
atDatos=array[1..cantDetalles] of tVotoLoc;
	
procedure leer(var detalle:tDetalle;var dato:tVotoLoc);
begin
if(not eof(detalle)) then 
begin read(detalle,dato); end
else begin dato.prov:=valorAlto;end;
end;

procedure minimo(var detalles:atDetalles;var datos:atDatos;var min:tVotoLoc);
var
i,posMin :integer;
begin
posMin:=1;
min:=datos[1];
for i:=2 to cantDetalles do
begin
	if(min.prov>datos[i].prov) then
	begin
		min:=datos[i];
		posMin:=i;
	end;
end;
leer(detalles[posMin],datos[posMin])
end;


procedure iniciarDetalles(var archivos: atDetalles; var datos: atDatos);
var
  i: integer;
begin
  for i := 1 to cantDetalles do
  begin
    assign(archivos[i], 'Detalle' + IntToStr(i) + '.dat');
    reset(archivos[i]);
    leer(archivos[i], datos[i]);
  end;
end;

procedure cerrarDetalles(var archivos:atDetalles);
var
i:integer;
begin
for i:=1 to cantDetalles do
	begin
	close(archivos[i]);
	end;
end;


var 
regMae,auxMae:tVotoProv;

detalles :atDetalles;
datos:atDatos;
maestro:tMaestro;
min:tVotoLoc;
validosT,anuladosT,blancosT:integer;
texto:TEXT;

BEGIN
iniciarDetalles(detalles,datos);
minimo(detalles,datos,min);
assign(maestro,'maestro.dat');
reset(maestro);
read(maestro,regMae);
validosT:=0;
blancosT:=0;
anuladosT:=0;
while (min.prov<>valorALto) do
begin
	auxMae.validos:=0;
	auxMae.blancos:=0;
	auxMae.anulados:=0;
	auxMae.prov:=min.prov;
	while (min.prov=auxMae.prov) do
	begin
		auxMae.validos:=auxMae.validos+min.validos;
		auxMae.blancos:=auxMae.blancos+min.blancos;
		auxMae.anulados:=auxMae.anulados+min.anulados;
		minimo(detalles,datos,min);
	end;
	//aca cambio la provincia
	while(regMae.prov<>auxMae.prov) do
		read(maestro,regMae);
	regMae.validos:=auxMae.validos+regMae.validos;
	regMae.blancos:=auxMae.blancos+regMae.blancos;
	regMae.anulados:=auxMae.anulados+regMae.anulados;
	seek(maestro,filepos(maestro)-1);
	write(maestro,regMae);
	//maestro actualizado
	validosT:=validosT+auxMae.validos;
	blancosT:=blancosT+auxMae.blancos;
	anuladosT:=anuladosT+auxMae.anulados;
	
end;
cerrarDetalles(detalles);
close(maestro);
assign(texto,'cantidad_votos_04_07_2023.txt');
rewrite(texto);
writeln(texto,'lo que piden de los totales');
close(texto)
	
	
END.

