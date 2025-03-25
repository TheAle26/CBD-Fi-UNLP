program ej2;

uses crt;
	
Type
	tArchInteger = File of integer;

procedure evaluarMaximoMinimo(var max: integer; var min:integer; cant:integer);
begin
	if cant>max then max:=cant
	else
	begin
		if cant<min then min:=cant;
	end;

end;
	
var 

	nombreArchivo : string;
	cantVotantes, cantMinVotantes, cantMaxVotantes : integer;
	arch : tArchInteger;
BEGIN
	cantMinVotantes:=9999;
	cantMaxVotantes := -1;
	Write('Ingrese archivo a abrir');
	ReadLn(nombreArchivo);
	Assign(arch,nombreArchivo);
	Reset(arch);
	
	while (not eof(arch)) do begin
		Read(arch,cantVotantes);
		Write('votantes: ');
		WriteLn(cantVotantes);
	evaluarMaximoMinimo(cantMaxVotantes,cantMinVotantes,cantVotantes);
	end;
	close(arch);
	Writeln('El lugar con mas votantes tiene',cantMaxVotantes);
	Writeln('El lugar con menos votantes tiene',cantMinVotantes);
END.

