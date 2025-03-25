{
Un restaurante posee un archivo con información de los montos por servicios cobrados 
por cada mozo durante la semana. De cada servicio se conoce: código de mozo, fecha 
y monto del servicio. La información del archivo se encuentra ordenada por código de 
mozo y cada mozo puede tener n servicios cobrados en diferentes fechas. No se 
conoce la cantidad de mozos del restaurante. 
Realice un procedimiento que reciba el archivo anterior y lo compacte. En 
consecuencia, deberá generar un nuevo archivo en el cual, cada mozo aparezca una 
única vez con el valor total cobrado por los servicios. El archivo debe recorrerse una 
única vez. 
}




program untitled;

uses SysUtils;
const cantDetalles = 20;

const valorAlto='9999';
type 
str4=string[4];
tServicio=record
	codigo:str4;
	fecha : integer;
	monto:real;
	end;
	
tMozo = record
	codigo:str4;
	monto:real;
	end;
	
tMaestro=file of tMozo;
tDetalle=file of tServicio;
atDetalle = array[1..cantDetalles] of tDetalle;
atServicio = array[1..cantDetalles] of tServicio;



procedure leer(var detalle:tDetalle; var dato:tServicio);
begin
if (not EOF(detalle)) then
	read(detalle,dato)
else
dato.codigo:=valorAlto;
end;

procedure iniciarDetalles(var archivos: atDetalle; var datos: atServicio);
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




procedure cerrarDetalles(var archivos: atDetalle);
var
  i: integer;
begin
  for i := 1 to cantDetalles do
  begin
    close(archivos[i]);
  end;
end;





procedure minimo(var archivos: atDetalle; var datos: atServicio; var min: tServicio);
var
i:integer;posMin:integer;
begin
posMin:=1;min:=datos[1];
for i:=2 to cantDetalles do
	begin
	if (min.codigo>datos[i].codigo) then
		begin
		min:=datos[i];
		posMin:=i
		end;
	end;
leer(archivos[posMin],datos[posMin]);

end;

var 
mozo:tMozo;
maestro: tMaestro;
detalles:atDetalle;
datos:atServicio;
min:tServicio;


BEGIN
iniciarDetalles(detalles,datos);
assign(maestro,'maestro.dat');
rewrite(maestro);
minimo(detalles,datos,min);
while (min.codigo<>valorAlto) do
begin
	mozo.codigo:=min.codigo;
	mozo.monto:=0;
	while (mozo.codigo=min.codigo) do
	begin
		mozo.monto:=mozo.monto+min.monto;
		minimo(detalles,datos,min);
	end; //salgo con los datos en la variable
	write(maestro,mozo);
end;
close(maestro);
cerrarDetalles(detalles);
	
END.

