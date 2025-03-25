program ej3;

type
	tArchivoTexto = TEXT;

var
	dinosaurio : string;
	archTexto : tArchivoTexto;

begin
	Assign(archTexto,'Dinosaurio de Sudamerica');
	Rewrite(archTexto);
	Writeln('Ingrese el nombre del dinosaurio a agregar');
	Readln(dinosaurio);
	while (dinosaurio<>'zzz') do
		begin
		writeln(archTexto,dinosaurio);
		Writeln('Ingrese el nombre del dinosaurio a agregar');
		Readln(dinosaurio);
		end;

	close(archTexto);
end.
