
program untitled;

uses crt;

type
	tNombreMateriales = string;
	tArchNombreMateriales = file of tNombreMateriales;

var
	nombreMaterial : tNombreMateriales;
	nombreArchivo : string;
	ArchNombreMateriales : tArchNombreMateriales;

BEGIN
	WriteLn('Ingrese el nombre que deseas que tenga el archivo');
	Readln(nombreArchivo);
	Assign(ArchNombreMateriales,nombreArchivo);
	Rewrite(ArchNombreMateriales);
	repeat
		WriteLn('Ingrese el nombre del material a agregar. El programa finalia con cemento.');
		Readln(nombreMaterial);
		Write(ArchNombreMateriales,nombreMaterial);
		
	
	until  (nombreMaterial = 'cemento');
	close(ArchNombreMateriales);
	
END.

