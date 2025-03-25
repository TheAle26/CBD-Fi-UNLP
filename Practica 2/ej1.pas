{
El área de recursos humanos de un ministerio administra el personal del mismo 
distribuido en 10 direcciones generales. 
Entre otras funciones, recibe periódicamente un archivo detalle de cada una de las 
direcciones conteniendo información de las licencias solicitadas por el personal. 
Cada archivo detalle contiene información que indica: 
código de empleado, 
la fecha y 
la cantidad de días de licencia solicitadas.
 
 El archivo maestro tiene información de 
cada empleado: código de empleado,
 nombre y 
 apellido, 
 fecha de nacimiento, 
dirección,
 cantidad de hijos,
  teléfono, cantidad de días que le corresponden de 
vacaciones en ese periodo.

 Tanto el maestro como los detalles están ordenados por 
CODIGO  de empleado. 

Escriba el programa principal con la declaración de tipos 
necesaria y realice un proceso que reciba los detalles y actualice el archivo maestro 
con la información proveniente de los archivos detalles. Se debe actualizar la cantidad 
de días que le restan de vacaciones. Si el empleado tiene menos días de los que 
solicita deberá informarse en un archivo de texto indicando: código de empleado, 
nombre y apellido, cantidad de días que tiene y cantidad de días que solicita. 
   
}


program ej1;

uses SysUtils;
const valorAlto= '9999';
const cantDetalles = 10;

type
 strCod = string[4];
tEmpleado = record
	codigo: strCod;
	nombreApellido: string[50];
	nacimiento : integer;
	direccion: string[50];
	cantHijos: integer;
	telefono : integer;
	cantVacaciones: integer;
	end;

tDetEmpleado = record
	codigo:strCod;
	fecha:integer;
	diasSolicitados:integer;
	end;
	
	
tMae = file of tEmpleado;
tDet = file of tDetEmpleado;
tADet = array[1..cantDetalles] of tDet;
tADetEmpleado=array[1..cantDetalles] of tDetEmpleado;

	
procedure leer (var archivo: tDet;  var dato: tDetEmpleado);
 begin
	 if (not(EOF(archivo))) then  
		read (archivo, dato)
	 else  dato.codigo := valorAlto; 
end;

procedure minimo (var archivos: tADet; var datos: tADetEmpleado; var min:tDetEmpleado);
var
posMin,i :integer;
begin
	posMin:=1;
	min:=datos[1];
	for i:=2 to cantDetalles do
	begin
		if(datos[i].codigo<min.codigo) then
			begin
			posMin:=i;
			min:=datos[i];
			end;
	end;
	
	leer(archivos[posMin],datos[posMin]);
end;


var

aDet : tADet;
aDetEmpleado : tADetEmpleado;
codAct: strCod;
empMae : tEmpleado;
min: tDetEmpleado;
maestro : tMae;
i,dias:integer;
informe : text;

BEGIN
assign(informe,'informe.txt');
assign(maestro,'maestro');
read(maestro, empMae);
for i:=1 to cantDetalles do begin

	assign(aDet[i],'detalle' +IntToStr(i));
	reset(aDet[i]);
	leer(aDet[i],aDetEmpleado[i]);
end;

minimo(aDet,aDetEmpleado,min);
while (min.codigo<>valorAlto) do 
begin
	codAct:= min.codigo;
	dias:= 0;
	while (min.codigo=codAct) do //sumo todos los dias
	begin
		dias:= min.diasSolicitados;
		minimo(aDet,aDetEmpleado,min);
	end;
	// si estoy aca es porque cambio el codigo, los busco en el maestro
	while (empMae.codigo<>min.codigo) do
	begin
		read(maestro,empMae);
	end;
	// encontre el registro
	empMae.cantVacaciones:= empMae.cantVacaciones -dias;
	//if (empMae.cantVacaciones<0) do informar(empMae);
	seek(maestro, filepos(maestro)-1);
	write(maestro,empMae);
	if (not(EOF(maestro))) then  read(maestro, empMae); //me queda leido para despues.
	//aca ya lo actualice, por lo que vuelvo a compara si el codigo minimo es o no valor alto.

end;
	
	
END.

