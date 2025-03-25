Program actividadColaborativa;
Uses crt;
Type

rdia=1..31;
rmes=1..12;
rano=1950..2100;

tfecha =record
	dia:rdia;
	mes:rmes;
	ano:rano;
	end;


venta =record
	codigo:integer;
	cantidad:real;
	fecha:tfecha;
	cliente:integer;
	end;
	
arbolCodigoPasta=^nodoACP;
nodoACP=record
	codigo:integer;
	cantidad:real;
	HI: arbolCodigoPasta;
	HD: arbolCodigoPasta;
	end;

procedure agregarArbolCodigoPasta(var a:arbolCodigoPasta;v:venta);
begin
if a=nil then
	begin
	new(a);
	a^.codigo:=v.codigo;
	a^.cantidad:=v.cantidad;
	a^.HI:=nil;
	a^.HD:=nil;
	end
	else
		begin
		if v.codigo>a^.codigo then agregarArbolCodigoPasta(a^.HD,v)
		else if v.codigo<a^.codigo then agregarArbolCodigoPasta(a^.HI,v)
		else a^.cantidad:=a^.cantidad+v.cantidad;
		end;
end;

procedure AgregarVentasACP(var a:arbolCodigoPasta);
var v:venta;
begin
clrscr;
writeln('Ingrese el codigo de CLIENTE 0000 para finalizar la carga. ');
write('Ingrese el codigo de CLIENTE: ');readln(v.cliente);
if v.cliente<>0000 then 
	begin
	write('Ingrese el codigo de pasta: ');readln(v.codigo);
	write('Ingrese la cantidad en kg: ');readln(v.cantidad);
	write('Ingrese el  dia: ');readln(v.fecha.dia);
	write('Ingrese el  mes: ');readln(v.fecha.mes);
	write('Ingrese el e ano: ');readln(v.fecha.ano);
	agregarArbolCodigoPasta(a,v);
	writeln('venta agregada exitosa mente. Presione cualquier tecla para continuar');
	readln();
	AgregarVentasACP(a);
	end;
end;

procedure informarArbol(a:arbolCodigoPasta);
begin
if a<> nil then
	begin
	informarArbol(a^.HI);
	informarArbol(a^.HD);
	writeln('el codigo de la pasta es: ',a^.codigo,' y vendio ',a^.cantidad:0:3,' kilos.');
	writeln();
	end;
end;

procedure eliminarArbol(var a:arbolCodigoPasta);
begin
if a<> nil then
	begin
	eliminarArbol(a^.HI);
	eliminarArbol(a^.HD);
	dispose(a);
	a:=nil;
	end;
end;

procedure incializar(var a:arbolCodigoPasta);
var 
opcion:char;
begin
clrscr;
writeln('Si ya tiene datos cargados, este proceso los  eliminara.');
writeln('Precione ENTER para continuar o cualquier otra tecla para retroceder.');
opcion := Readkey;
if Ord(opcion)=13 then begin
	eliminarArbol(a);
	new(a);
	a:=nil;
	writeln('Estructura inicializada.');writeln('Presione cualquier tecla para volver al menu.');
	readln();
	end;
end;

function codidoMenosVendido(a:arbolCodigoPasta):arbolCodigoPasta;
var
act,aux:arbolCodigoPasta;
begin
	if a= nil then  codidoMenosVendido:=nil //si el arbol esta vacio
	else
	begin
	act:=a; //para comparar el nodo actual
	if a^.HI<> nil then
		begin
		aux:=codidoMenosVendido(a^.HI); //sigue buscando mas a la izquierda
		if aux^.cantidad<act^.cantidad then act:=aux; //compara donde estoy con lo que tengo a la izquierda
		end;
	if a^.HD<> nil then
		begin
		aux:=codidoMenosVendido(a^.HD);
		if aux^.cantidad<act^.cantidad then act:=aux;
		end;
	codidoMenosVendido:=act; //si el nodo actual tiene mas ventas, en realidad esta devolviendo los de mas abajo en el arbol
	end
end;

procedure informarSiMas10Kg(a:arbolCodigoPasta);
begin
if a<> nil then
	begin
	informarArbol(a^.HI);
	informarArbol(a^.HD);
	if a^.cantidad>= 10 then
		writeln('El codigo de la pasta es: ',a^.codigo,' y vendio ',a^.cantidad,' kilos.');
	writeln();
	end;
end;

var
a,a2:arbolCodigoPasta;
opcion: char;
begin

repeat
writeln('Bienvenido. Seleccion alguna opcion');
writeln();
writeln('a) Incializar estructuras de datos.');
writeln();
writeln('b) Agregar Ventas.');
writeln();
writeln('c) Imprimir toda la informacion almacenada.');
writeln();
writeln('d) Informar codigo de pasta menos vendido.');
writeln();
writeln('e) Informar los códigos de pasta que tuvieron más de 10 kilos en ventas.');
writeln();
writeln('f) Salir.');
opcion := Readkey;
Case opcion Of 
  'a':
       Begin
       clrscr;
       incializar(a);
       End;
  'b':
       Begin
       clrscr;
       AgregarVentasACP(a);
       End;
  'c':
       Begin
       clrscr;
        if a<>nil then 
       informarArbol(a)
       else writeln('No hay informacion almacenada.');
       writeln();writeln('Presione cualquier tecla para volver al menu.');
       readln();
       End;
  'd':
       Begin
       clrscr;
       a2:=codidoMenosVendido(a);
       if a2<>nil then begin
		   writeln('El codigo menos vendido es ',a2^.codigo,' con ',a2^.cantidad,' cantidad de kilos vendidos.');
		   dispose(a2);
       end
       else
		writeln('No hay informacion almacenada.');
       writeln();
       writeln('Presione cualquier tecla para volver al menu.');
       readln();
       End;
  'e':
       Begin
       clrscr;
       if a<> nil then 
       informarSiMas10Kg(a)
       else writeln('No hay informacion almacenada.');
       writeln();writeln('Presione cualquier tecla para volver al menu.');
       readln();       
       End;
  'f':
       Begin
         writeln('Vuelva a presionar la f para salir.');
         opcion := Readkey;
       End;
End;
clrscr;
until  opcion='f';
eliminarArbol(a);
END.
