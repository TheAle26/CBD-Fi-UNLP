{
Una zapatería cuenta con 20 locales de ventas. Cada local de ventas envía un listado 
con los calzados vendidos indicando: código de calzado, número y cantidad vendida 
del mismo. 
El archivo maestro almacena la información de cada uno de los calzados que se 
venden, para ello se registra el código de calzado, número, descripción, precio unitario, 
color, el stock de cada producto y el stock mínimo. 
Escriba el programa principal con la declaración de tipos necesaria y realice un 
proceso que reciba los 20 detalles y actualice el archivo maestro con la información 
proveniente de los archivos detalle. Tanto el maestro como los detalles se encuentran 
ordenados por el código de calzado y el número.  
Además, se deberá informar qué calzados no tuvieron ventas y cuáles quedaron por 
debajo del stock mínimo. Los calzados sin ventas se informan por pantalla, mientras 
que los calzados que quedaron por debajo del stock mínimo se deben informar en un 
archivo de texto llamado calzadosinstock.txt. 
Nota: tenga en cuenta que no se realizan ventas si no se posee stock. 
   
}


program untitled;
uses SysUtils;
const valorAlto= '9999';
const cantDetalles= 20;
type
str4=string[4];

tCalzadoVendido = record
	codigo : str4;
	numero:integer;
	ventas : integer;
	end;

tCalzado = record
	codigo:str4;
	numero:integer;
	descripcion: string[50];
	precio: real;
	color: string[10];
	stock:integer;
	sMinimo:integer;
	end;

tMaestro= file of tCalzado;
tDetalle= file of tCalzadoVendido;
atDetalles= array[1..cantDetalles] of tDetalle;
atCalzadoVendido= array[1..cantDetalles] of tCalzadoVendido;


procedure leer(var archivo: tDetalle;var dato: tCalzadoVendido);
begin

if (not(EOF(archivo))) then  
		read (archivo, dato)
	 else  dato.codigo := valorAlto; 
	 
end;

procedure minimo(var archivos: atDetalles; var datos: atCalzadoVendido; var min: tCalzadoVendido);
var
posMin,i:integer;
begin
	posMin:=1;
	min:=datos[1];
	for i:=2 to cantDetalles do
	begin
		if (datos[i].codigo < min.codigo) or 
   ((datos[i].codigo = min.codigo) and (datos[i].numero < min.numero)) then
			begin
			posMin:=i;
			min:=datos[i];
			end;
	end;
	
	leer(archivos[posMin],datos[posMin]);

end;

procedure iniciarDetalles (var archivos: atDetalles;var datos: atCalzadoVendido);
var
i:integer;
begin
	for i:=1 to cantDetalles do
	begin
		assign(archivos[i],'Detalle numero '+ IntToStr(i));
		reset(archivos[i]);
		leer(archivos[i],datos[i]);
	end;
end;

procedure cerrarDetalles (var archivos: atDetalles);
var
i:integer;
begin
	for i:=1 to cantDetalles do
	begin
		close(archivos[i]);
	end;
end;


var 
maestro : tMaestro;
detalles : atDetalles;
calzados : atCalzadoVendido;
min,aux : tCalzadoVendido;
calzadoMaestro : tCalzado;
ventas:integer;
informe : text;

BEGIN
iniciarDetalles(detalles,calzados);
assign(maestro,'maestro.dat');
minimo(detalles,calzados,min);
read(maestro,calzadoMaestro);
assign(informe, 'calzadosinstock.txt');
rewrite(informe);
while (min.codigo<> valorAlto) do
begin
	aux:=min;

		ventas:=0;
		while ((min.codigo=aux.codigo)and(min.numero=aux.numero)) do
		begin
			ventas := ventas + min.ventas;
			minimo(detalles,calzados,min);
		end;
		
    while ((calzadoMaestro.codigo < aux.codigo) or 
          ((calzadoMaestro.codigo = aux.codigo) and (calzadoMaestro.numero < aux.numero))) do
		begin 
			writeln('El calzado de codigo ',calzadoMaestro.codigo,' En el numero ',calzadoMaestro.numero,' no tuvo ventas');
			read(maestro,calzadoMaestro);
		end;
		// si llegue aca es pq lo encontre
		calzadoMaestro.stock:= calzadoMaestro.stock-ventas;
		seek(maestro,filepos(maestro)-1);
		write(maestro,calzadoMaestro);
		if (calzadoMaestro.stock<calzadoMaestro.sMinimo) then
			writeln(informe,'El calzado de codigo ',calzadoMaestro.codigo,' En el numero ',calzadoMaestro.numero,' quedo por debajo del stock minimo');
		//al llegar aca ya actualice el archivo e informe lo nescesario. 
		//ahora vamos a volver a entrar al loop del mismo codigo de zapato
	end;
	
	
	cerrarDetalles(detalles);
close(informe);	
close(maestro);	
END.

