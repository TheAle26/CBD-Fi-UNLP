program tp1ej6;

type 
tlibro = record
	ISBN : integer;
	titulo : string;
	anoEdicion : integer;
	editorial :string;
	genero : string;
	end;
	
tArchLibroB = file of tlibro;

procedure crearArchivoBinario(var carga : Text;var arch:tArchLibroB);
var libro: tlibro;
begin

	Reset(carga);
	rewrite(arch);

	while (not eof(carga)) do begin
	readln(carga,libro.ISBN,libro.titulo);
	Writeln('Ayuda');
	readln(carga,libro.anoEdicion,libro.editorial);
	readln(carga,libro.genero);
	write(arch,libro);
	end;
	close(arch);
	close(carga);

end;

procedure actualizarArchivo(var arch:tArchLibroB);
var 
libro:tlibro;
ISBN:integer;

begin
reset(arch);
Writeln('Ingrese ISBN a actualizar');
readln(ISBN);
read(arch,libro);
while ((not eof(arch)) and (ISBN<>libro.ISBN)) do
	begin
	read(arch,libro);
	end;
	
if (ISBN<>libro.ISBN) then Writeln('No se encontro ISBN')

else begin
Writeln('Aca estaria la opcion de poder modificar el libro');
seek(arch,filepos(arch) - 1);
libro.genero:='genero modificadooo';
write(arch,libro);
Writeln('Actualizado');
end;
close(arch);

end;

procedure agregarLibro(var arch:tArchLibroB);
var
libro:tlibro;
begin
writeln('Ingrese ISBN');
readln(libro.ISBN);
writeln('Ingrese titulo');
readln(libro.titulo);
writeln('Ingrese anoEdicion');
readln(libro.anoEdicion);
writeln('Ingrese editorial');
readln(libro.editorial);
writeln('Ingrese genero');
readln(libro.genero);
reset(arch);
seek(arch, fileSize(arch));
write(arch,libro);
close(arch);

end;

var
carga :TEXT;
arch :tArchLibroB;
opc : integer;
libro:tlibro;


begin

Assign(carga,'libros.txt');
Assign(arch,'librosBinario');
libro.ISBN:=33;
libro.titulo:=' Titulo';
libro.anoEdicion:=200;
libro.editorial:=' editorial';
libro.genero:='genero';
rewrite(carga);
writeln(carga,libro.ISBN,libro.titulo);
writeLN(carga,libro.anoEdicion,libro.editorial);
writeLN(carga,libro.genero);
close(carga);
{VER PORQUE ANDA SI Y SOLO SI DEJO UN ESPECIO EN EL STRIGN"
}
writeln('LLEGUE');

repeat 
writeln('Ingrese una opcion');
writeln('1: Crear archivo binario. Si ya existe, se sobreescribe');
writeln('2: Abrir archivo binario y actualizar');
writeln('3: Abrir archivo binario y agregar libro');
writeln('4: Salir');
readln(opc);

case opc of
	1: begin
		crearArchivoBinario(carga, arch);
		writeln('Archivo binario creado.');
	end;
	
	2: begin
	actualizarArchivo(arch);
		
	end;
	
	3: begin
	agregarLibro(arch);
	writeln('Libro agregado');
	
	end;
	
end;

until (opc=4);	

end.

	
