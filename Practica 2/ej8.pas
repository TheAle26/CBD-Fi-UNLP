{

La municipalidad de la Plata, en pos de minimizar los efectos de posibles inundaciones, 
construye acueductos que permitan canalizar rápidamente el agua de la ciudad hacia 
diferentes arroyos que circundan la misma. La construcción está dividida por zonas. 
Los arquitectos encargados de las obras realizan recorridos diariamente y guardan 
información de la 
zona, fecha y cantidad de metros construidos. Cada arquitecto envía 
mensualmente un archivo que contiene la siguiente información: 
cod_zona, nombre de la zona, descripción de ubicación geográfica, fecha, cantidad de metros construidos 

ese día. Se sabe que en la obra trabajan 15 arquitectos y que durante el mes van 
rotando de zona. 
Escriba un procedimiento que reciba los 15 archivos correspondiente y genere un 
archivo maestro indicando para cada 
zona: cod_zona, nombre de zona y cantidad de 
metros construidos. Además se deberá informar en un archivo de texto, para cada 
zona, la cantidad de metros construidos indicando: cod_zona, nombre, ubicación y 
metros construidos. Nota: todos los archivos están ordenados por cod_zona.
   
}

program untitled;

uses SysUtils;
const arquitectos=15;
const valorAlto='999';
type
str4=string[4];
informe_construccion = record
	cod_zona:str4;
	nombre:string[20];
	descripcion:string[20];
	fecha:integer;
	m2:real;
	end;
	
tconstruccion = record
	cod_zona:str4;
	nombre:string[20];
	m2:real;
	end;

tDetalle = file of informe_construccion;
tMaestro = file of tconstruccion;
atDetalle = array[1..arquitectos] of tDetalle;
aDatos = array[1..arquitectos] of informe_construccion;

procedure leer(var archivo:tDetalle;var dato:informe_construccion);
begin
if (not eof(archivo)) then
	read(archivo,dato)
else
	dato.cod_zona:=valorAlto;

end;

procedure minimo(var archivos:atDetalle;var datos:aDatos; var min:informe_construccion);
var
i,posMin:integer;
begin
posMin:=1;
min:=datos[1];
for i:=1 to arquitectos do
begin
	if (min.cod_zona>datos[i].cod_zona) then
	begin
		min:=datos[i];
		posMin:=i;
	end;

end;
leer(archivos[posMin],datos[posMin]);
end;


procedure iniciarDetalles(var archivos: atDetalle; var datos: aDatos);
var
  i: integer;
begin
  for i := 1 to arquitectos do
  begin
    assign(archivos[i], 'Detalle' + IntToStr(i) + '.dat');
    reset(archivos[i]);
     leer(archivos[i], datos[i]);
  end;
end;

procedure cerrarDetalles(var archivos: atDetalle);
var
  i: integer;
begin
  for i := 1 to arquitectos do
  begin
    close(archivos[i]);
  end;
end;



var 
maestro:tMaestro;
regMaestro: tconstruccion;
detalles :atDetalle;
datos:aDatos;
min,aux: informe_construccion;
tipoTexto:text;


BEGIN
assign(tipotexto,'informe.txt');
rewrite(tipoTexto);
assign(maestro,'maestro.dat');
rewrite(maestro);
iniciarDetalles(detalles,datos);
minimo(detalles,datos,min);

while (min.cod_zona<>valorAlto) do
begin
	aux:=min;
	regMaestro.cod_zona:=min.cod_zona;
	regMaestro.nombre:=min.nombre;
	regMaestro.m2:=0;
	while(regMaestro.cod_zona=min.cod_zona) do
	begin
		regMaestro.m2:=regMaestro.m2+min.m2;
		minimo(detalles,datos,min);
	end;
	// si llegue aca es pq cambio la zona
	write(maestro,regMaestro);
	writeln(tipoTexto,aux.cod_zona);
	writeln(tipoTexto,aux.nombre);
	writeln(tipoTexto,aux.m2,aux.descripcion);

end;
cerrarDetalles(detalles);
close(maestro);
	
END.

