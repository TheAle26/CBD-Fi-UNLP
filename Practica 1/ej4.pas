program ej4;

type
	tArchTexto = TEXT;
	tArchInteger = file of integer;
	
var
	archTexto : tArchTexto;
	archInteger : tArchInteger;
	i : integer;
	nombreArch : string;

	
begin
	writeln('ingrese nombre del archivo del archivo de carga: ');
	readln(nombreArch);
	Assign(archInteger,nombreArch);
	writeln('ingrese nombre del archivo del archivo de texto a crear: ');
	readln(nombreArch);
	Assign(archTexto,nombreArch);
	reset(archInteger);
	rewrite(archTexto);
	
	while (not eof(archInteger)) do
	begin
		read(archInteger,i);
		writeln(archTexto,i);
	end;
	
	close(archInteger);
	close(archTexto);

end.
