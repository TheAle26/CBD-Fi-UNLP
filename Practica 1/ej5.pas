program ej5;

type

tEspecieFlor = record
	numeroEspecie : integer;
	alturaMaxima : real;
	nombreCientifico : string;
	nombreVulgar : string;
	color: string;
	end;
	
tOpciones = set of 1..10;

tArchEspecieFlor = file of tEspecieFlor;



procedure tomarDatosEspecieFlor(var f:tEspecieFlor);
begin
	writeln('Ingrese el nombre cientifico: ');
	readln(f.nombreCientifico);
	if (f.nombreCientifico<>'zzz') then
	begin
		writeln('Ingrese el numero de especie : ');
		readln(f.numeroEspecie);
		writeln('Ingrese la altura maxima: ');
		readln(f.alturaMaxima);
		writeln('Ingrese el nombre vulgar: ');
		readln(f.nombreVulgar);
		writeln('Ingrese el color: ');
		readln(f.color);
	end;
end; 

procedure cargarEspeciesFloresAArchivo(var arch:tArchEspecieFlor);
var
eFlor : tEspecieFlor;

begin
	tomarDatosEspecieFlor(eFlor);
	while (eFlor.nombreCientifico<>'zzz') do begin
		write(arch,eFlor);
		writeln('Flor cargada. Ingrese a continuacion los datos de la siguente. ingrese "zzz" para fializar. ');
		tomarDatosEspecieFlor(eFlor);
	end;
	
end;

procedure evaluarMaximoMinimo(var max: tEspecieFlor; var min: tEspecieFlor; actual: tEspecieFlor);
begin
    if actual.alturaMaxima > max.alturaMaxima then
        max := actual;
    
    if actual.alturaMaxima < min.alturaMaxima then
        min := actual;
end;

procedure reportarEspecies(var arch:tArchEspecieFlor);
var
e,eFlorMinAltura,eFlorMaxAltura : tEspecieFlor;
cantE : integer;

begin
cantE :=0;
eFlorMaxAltura.alturaMaxima:=-1;
eFlorMinAltura.alturaMaxima := 9999;
while (not eof(arch)) do 
begin
	read(arch,e);
	writeln(e.numeroEspecie,' ',e.alturaMaxima,' ',e.nombreCientifico,' ',e.nombreVulgar,' ',e.color,' ');
	evaluarMaximoMinimo(eFlorMaxAltura,eFlorMinAltura,e);
	cantE:= cantE+1;
end;
writeln('La flor con la altura mas alta es: ',eFlorMaxAltura.nombreCientifico);
writeln('La flor con la altura mas baja es: ',eFlorMinAltura.nombreCientifico);
writeln('Hay un total de ',cantE,' especies.');

end;

procedure anadirEspeciesArchivo(var arch:tArchEspecieFlor);
begin
	seek(arch,sizeOf(arch)-1);
	cargarEspeciesFloresAArchivo(arch);
end;

procedure modificarNombreCientifico(var arch:tArchEspecieFlor);
var
eF : tEspecieFlor;
nombre : string;

begin
	writeln('ingrese nombre cientifico a cambiar');
	readln(nombre);
	read(arch,eF);
	while ((not eof(arch)) and (nombre<>ef.nombreCientifico)) do begin
		read(arch,eF);
		
	end;
	if (nombre = ef.nombreCientifico)then
	begin
		writeln('Por que nombre lo quiere cambiar?');
		readln(nombre);
		eF.nombreCientifico := nombre;
		seek(arch, filepos(arch) - 1);
		write(arch, eF);
	end
	else
	begin
		writeln('No se encontro');

	end;
	seek(arch,0); 
end;

procedure crearArchivoFloresTxt(var arch: tArchEspecieFlor);
var
	txt : TEXT;
	eF : tEspecieFlor;
begin
	Assign(txt,'flores.txt');
	rewrite(txt);
	while (not eof(arch)) do
	begin
		read(arch,eF);
		writeln(txt,eF.numeroEspecie,eF.alturaMaxima,eF.nombreCientifico);
		writeln(txt,eF.nombreVulgar);
		writeln(txt,eF.color);
	end;
	close(txt);
	seek(arch,0); 
	writeln('Archivo Creado.');
end;


var
	archEspecieFlor : tArchEspecieFlor;
	nombreArchivo : string;
	opc : integer;
	opciones : tOpciones;
	

begin
	opciones:= [1,2,3,4,5];
	{rewrite(archEspecieFlor);
	cargarEspeciesFloresAArchivo(archEspecieFlor);
	close(archEspecieFlor);
	}
	nombreArchivo :='Especies de flores tipo record';
	assign(archEspecieFlor,nombreArchivo);
	reset(archEspecieFlor);
	repeat
		repeat 
		writeln('1: listar en pantalla todas las epecies, reportar la cantidad, la mas alta y la mas baja');
		writeln('2: anadir al final del archivo mas especies');
		writeln('3: Modificar nombre cientifico');
		writeln('4: Crear Flores.txt');
		writeln('5: salir');
		readln(opc);
		until (opc in opciones);
		case opc of
			1: begin
				reportarEspecies(archEspecieFlor);
			end;
			2: begin 
				anadirEspeciesArchivo(archEspecieFlor);
			end;
			3: begin
				modificarNombreCientifico(archEspecieFlor);
			end;
			4: begin
				crearArchivoFloresTxt(archEspecieFlor);
			end;
			
		end;

	until (opc = 5);
	

	close(archEspecieFlor);

end.

	
	
