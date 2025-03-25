{
 Se desea administrar el stock de los productos de una tienda de electrodomésticos con 
varias sucursales en el país. Para ello se cuenta con un archivo maestro donde figuran 
todos los productos que comercializa. 
De cada producto se almacena la siguiente 
información: código de producto, nombre comercial, descripción, precio de venta, 
cantidad vendida, y mayor cantidad vendida en un mes. 
Mensualmente se genera un 
archivo detalle en cada sucursal en el que registran todas las ventas de productos. De 
cada
 venta se registra el código de producto y la cantidad de unidades vendidas. 
Mensualmente la empresa recibe un archivo detalle de cada sucursal (son 8 
sucursales) y debe actualizar el archivo maestro. Se pide realizar un programa que 
realice la declaración de tipos e invoque un proceso que actualice el archivo maestro 
con los archivos detalle sabiendo que: 
a. Todos los archivos están ordenados por código de producto. 
b. Cada registro del archivo maestro puede ser actualizado por 0, 1 ó más registros de 
los archivos detalle. 
c. Los archivos detalle sólo contienen ventas de productos que están en el archivo 
maestro.  
Además si la cantidad vendida en el mes actual supera a la mayor cantidad vendida en un mes 
previo, se debe actualizar este dato y también se debe informar en pantalla el código del producto, 
nombre, mayor cantidad vendida hasta el mes anterior (la del archivo maestro) y cantidad vendida 
en el mes actual. 
Nota: deberá implementar el programa principal, todos los procedimientos y los tipos de 
datos necesarios.
}


program untitled;

uses SysUtils;
const sucursales = 8;
const valorAlto = '9999';
type
str4=string[4];
tProducto = record
	codigo:str4;
	cantidadVendida:integer;
	mayorVenta:integer;
	end;
tVenta = record
	codigo:str4;
	cantidad:integer;
	end;

tDetalle = file of tVenta;
tMaestro = file of tProducto;
atDetalle = array[1..sucursales] of tDetalle;
atVenta = array [1..sucursales] of tVenta;

procedure leer (var archivo:tDetalle; var dato: tVenta);
begin
	if (not eof(archivo)) then read(archivo,dato)
	else dato.codigo:= valorAlto;
end;

procedure minimo(var archivos:atDetalle;var datos:atVenta;var min:tVenta);
var
i,posMin:integer;
begin
min:=datos[1];
posMin:=1;
for i:=2 to sucursales do
	begin
	if (min.codigo>datos[i].codigo) then
		begin
		posMin:=i;
		min:=datos[i];
		end;
	end;
leer(archivos[posMin],datos[posMin]);
end;

procedure iniciarDetalles(var archivos: atDetalle; var datos: atVenta);
var
  i: integer;
begin
  for i := 1 to sucursales do
  begin
    assign(archivos[i], 'Detalle' + IntToStr(i) + '.dat');
    reset(archivos[i]);
    leer(archivos[i], datos[i]);
  end;
end;

procedure cerrarDetalles(var archivos:atDetalle);
var
i:integer;
begin
for i:=1 to sucursales do
	begin
	close(archivos[i]);
	end;
end;

procedure actualizarMaestro();
var
maestro:tMaestro;
archivos:atDetalle;
min:tVenta;
datos:atVenta;
regMae:tproducto;
codAux:str4;
cantidadMes:integer;
begin
iniciarDetalles(archivos,datos);
minimo(archivos,datos,min);
assign(maestro,'maestro.dat');
reset(maestro);
read(maestro,regMae);
while(min.codigo<>valorAlto) do
begin
	codAux:=min.codigo;
	cantidadMes:=0;
	while(min.codigo=codAux) do
	begin
		cantidadMes:=cantidadMes+min.cantidad;
		minimo(archivos,datos,min);
	end;
	//cambio el codigo
	while(regMae.codigo<>codAux) do 
	begin
	read(maestro,regMae);
	end;
	//encontre el registro en el maestro
	if (regMae.mayorVenta<cantidadMes) then
	begin
		writeln('bla bla bla',regMae.mayorVenta,' ',cantidadMes);
		regMae.mayorVenta:=cantidadMes;
	end;
	regMae.cantidadVendida:=regMae.cantidadVendida +cantidadMes;
	seek(maestro,filepos(maestro)-1);
	write(maestro,regMae);
	
end;
close(maestro);
cerrarDetalles(archivos);
end;



BEGIN
actualizarMaestro();
	
END.

