{
   ej7.pas
   
   Copyright 2025 alejo <alejo@ALE_PC>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
  . Realizar un programa con opciones para:
a. Crear un archivo de registros no ordenados con la información
correspondiente a los alumnos de la facultad de ingeniería y cargarlo con
datos obtenidos a partir de un archivo de texto denominado “alumnos.txt”.
Los registros deben contener DNI, legajo, nombre y apellido, dirección, año
que cursa y fecha de nacimiento (longInt).
b. Listar en pantalla toda la información de los alumnos cuyos nombres
comiencen con un carácter proporcionado por el usuario.
c. Listar en un archivo de texto denominado “alumnosAEgresar.txt” todos los
registros del archivo de alumnos que cursen 5º año.
d. Añadir uno o más alumnos al final del archivo con sus datos obtenidos por
teclado.
e. Modificar el año que cursa un alumno dado. Las búsquedas son por legajo
del alumno.

   
}
program tp1ej7;

uses crt;
type
  tAlumno = record
    DNI: longInt;
    legajo: longInt;
    nombre: string;
    apellido: string;
    direccion: string;
    anioCursa: Integer;
    fechaNacimiento: longInt;
  end;

tArchivoAlumnos = file of tAlumno;



procedure crearArchivoAlumnosTxt(var carga:text);
var
alumno:tAlumno;
begin
  Rewrite(carga);  

  { Alumno 1 }
  alumno.DNI := 40234567;
  alumno.legajo := 12345;
  alumno.nombre := 'Juan';
  alumno.apellido := 'Pérez';
  alumno.direccion := 'Calle Falsa 123';
  alumno.anioCursa := 2;
  alumno.fechaNacimiento := 20030512;
  writeln(carga, alumno.DNI,' ', alumno.legajo, ' ',alumno.anioCursa, ' ',alumno.fechaNacimiento, ' ',alumno.nombre);
  writeln(carga, alumno.apellido);
  writeln(carga, alumno.direccion);
  { Alumno 2 }
  alumno.DNI := 37890123;
  alumno.legajo := 54321;
  alumno.nombre := 'María';
  alumno.apellido := 'Gómez';
  alumno.direccion := 'Av. Siempreviva 742';
  alumno.anioCursa := 3;
  alumno.fechaNacimiento := 20020708;
  writeln(carga, alumno.DNI,' ', alumno.legajo, ' ',alumno.anioCursa, ' ',alumno.fechaNacimiento, ' ',alumno.nombre);
  writeln(carga, alumno.apellido);
  writeln(carga, alumno.direccion);

  { Alumno 3 }
  alumno.DNI := 41567890;
  alumno.legajo := 67890;
  alumno.nombre := 'Carlos';
  alumno.apellido := 'Rodríguez';
  alumno.direccion := 'San Martín 456';
  alumno.anioCursa := 1;
  alumno.fechaNacimiento := 20040623;
  writeln(carga, alumno.DNI,' ', alumno.legajo, ' ',alumno.anioCursa, ' ',alumno.fechaNacimiento, ' ',alumno.nombre);
  writeln(carga, alumno.apellido);
  writeln(carga, alumno.direccion);

  { Alumno 4 }
  alumno.DNI := 38901234;
  alumno.legajo := 330;
  alumno.nombre := 'Laura';
  alumno.apellido := 'Fernández';
  alumno.direccion := 'Mitre 789';
  alumno.anioCursa := 5;
  alumno.fechaNacimiento := 20010430;
  writeln(carga, alumno.DNI,' ', alumno.legajo, ' ',alumno.anioCursa, ' ',alumno.fechaNacimiento, ' ',alumno.nombre);
  writeln(carga, alumno.apellido);
  writeln(carga, alumno.direccion);

  close(carga);
end;

procedure crearArchivoBinario(var carga:text;var arch:tArchivoAlumnos);
var
alumno:tAlumno;
begin
rewrite(arch);
reset(carga);
while (not eof(carga)) do
	begin
	writeln('hola');
	readln(carga, alumno.DNI,alumno.legajo,alumno.anioCursa,alumno.fechaNacimiento,alumno.nombre);
	writeln('lei primer renglon');
	readln(carga, alumno.apellido);
	writeln('lei apellido');
	readln(carga, alumno.direccion);
	writeln('lei direccion');
	write(arch,alumno);
	writeln('escribi en arch');
	end;
close(arch);
close(carga);

end;

procedure listarSiCaracter(var arch: tArchivoAlumnos);

var
alumno:tAlumno;
c,primerCaracter:char;
begin
reset(arch);
	writeln('escribi la letra con la que quieres filtrar.');
	readln(c);
	c:=upCase(c);
	writeln(c);
while (not eof(arch)) do begin
read(arch,alumno);
primerCaracter := alumno.nombre[2];
if (primerCaracter=c) then writeln(alumno.nombre);
	

end;

close(arch);
end;
var

arch: tArchivoAlumnos;
carga:Text;

opc:integer;
BEGIN

repeat 
assign(carga,'alumnos.txt');
assign(arch,'alumnos.dat');

crearArchivoAlumnosTxt(carga);
Writeln('1) Crear un archivo de registros no ordenados con la información correspondiente a los alumnos de la facultad de ingeniería y cargarlo con datos obtenidos a partir de un archivo de texto denominado “alumnos.txt”.');
writeln('2) listar todos los alumnos cuyo nombre arranque con un caracter');
writeln('3)Añadir uno o más alumnos al final del archivo con sus datos obtenidos por teclado.');
writeln('4) Salir,');
readln(opc);

case opc of
	1: begin
		crearArchivoBinario(carga,arch);
	end;
	
	2: begin
		listarSiCaracter(arch);
	end;
	
	3: begin
	
	end;
	
end;
	
until (opc=4);

END.

