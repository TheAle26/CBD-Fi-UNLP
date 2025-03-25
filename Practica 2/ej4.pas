{
Una cadena de cines de renombre desea administrar la asistencia del público a las
diferentes películas que se exhiben actualmente. Para ello cada cine genera
semanalmente un archivo indicando: código de película, nombre de la película, género,
director, duración, fecha y cantidad de asistentes a la función. Se sabe que la cadena
tiene 20 cines. Escriba las declaraciones necesarias y un procedimiento que reciba los
20 archivos y un String indicando la ruta del archivo maestro y genere el archivo
maestro de la semana a partir de los 20 detalles (cada película deberá aparecer una
vez en el maestro con los datos propios de la película y el total de asistentes que tuvo
durante la semana). Todos los archivos detalles vienen ordenados por código de
película. Tenga en cuenta que en cada detalle la misma película aparecerá tantas
veces como funciones haya dentro de esa semana.
   
   código de película, nombre de la película, género,
director, duración, fecha y cantidad de asistentes a la función.
}


program untitled;

uses crt;
const valorAlto = '9999';
const cantCines = 20;
type
  tFecha = record
    dia: integer;
    mes: integer;
    anio: integer;
  end;

  tDetPelicula = record
    codigo: string[10];      
    nombre: string[50];      
    genero: string[20];      
    director: string[50];  
    duracion: integer;       
    fecha: tFecha;           
    asistentes: integer;     
  end;
  
    tPelicula = record
    codigo: string[10];      
    nombre: string[50];      
    genero: string[20];      
    director: string[50];  
    duracion: integer;                
    asistentes: integer;     
  end;
  
 tdetalle = file of tDetPelicula;
 tmaestro = file of tPelicula;
 tADetalle = array[1..cantCines] of tdetalle;;
 tADetPelicula = array[1..cantCines] of tDetPelicula;

procedure iniciarDetalles(var archivos: tADetalle; var datos: tADetPelicula);
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

procedure cerrarDetalles(var archivos: tADetalle);
var
  i: integer;
begin
  for i := 1 to cantDetalles do
    close(archivos[i]);
end;


procedure leer ( var archivo: tdetalle ; var dato: tdetPelicula);
begin
if (not(EOF(archivo))) then  
		read (archivo, dato)
	 else  dato.codigo := valorAlto; 

end;
 
procedure minimo(var  detlles: tADetalle;var peliculas:tADetPelicula; var min:tDetPelicula);
var
pos,i:integer;
begin
	min:=peliculas[1];
	pos:=1;
	i:=2;
	for i to cantCines do
	begin
		if(peliculas[i].codigo<min.codigo) then
			begin
			posMin:=i;
			min:=datos[i];
			end;
	end;
	minimo(detalles[pos],peliculas[pos]);

end;

procedure crearMaestro(var detalles : tADetalles; nombre:string);
var
regD: tADetPelicula;
aux,min:tDetPelicula;
peliMaestro: tPelicula;
maestro: tMaestro;
asistentes:integer;
begin
iniciarDetalles(detalles,regD); //inicializados los detalles
assign(maestro,nombre);
rewrite(maestro);

minimo(detalles,regD,min);
while (min.codigo<>valorAlto) do 
begin
	aux:=min;
	asistentes:=0;
	while (min.codigo=aux.codigo) do
	begin
		asistentes:=asistentes +min.asistentes;
		minimo(detalles,regD,min);
	end;
	peliMaestro:= //aca le paso toda la info de aux a este registro y le cargo asistentes que es el total de asistentes.
	write(maestro,peliMaestro); //guardo en el maestro
end;
cerrarDetalles(detalles);
close(maestro);
end;

	
var 
detalles : tADetalles; nombre:string
BEGIN
crearMaestro(detalles,'peliculamestrooo');

	
END.

