program Zapateria;
uses
  SysUtils;
  
const 
  valorAlto = '9999';
  cantDetalles = 20;

type
  str4 = string[4];

  tCalzadoVendido = record
    codigo : str4;
    numero: integer;
    ventas : integer;
  end;

  tCalzado = record
    codigo: str4;
    numero: integer;
    descripcion: string[50];
    precio: real;
    color: string[10];
    stock: integer;
    sMinimo: integer;
  end;

  tMaestro = file of tCalzado;
  tDetalle = file of tCalzadoVendido;
  atDetalles = array[1..cantDetalles] of tDetalle;
  atCalzadoVendido = array[1..cantDetalles] of tCalzadoVendido;

{ Lee un registro del detalle; si ya no hay, asigna valor alto }
procedure leer(var archivo: tDetalle; var dato: tCalzadoVendido);
begin
  if not EOF(archivo) then
    read(archivo, dato)
  else
    dato.codigo := valorAlto;
end;

{ Devuelve en "min" el registro detalle mínimo (según código y número)
  y avanza ese detalle en su archivo }
procedure minimo(var archivos: atDetalles; var datos: atCalzadoVendido; var min: tCalzadoVendido);
var
  posMin, i: integer;
begin
  posMin := -1;
  { Inicialmente asignamos un valor alto a "min" }
  min.codigo := valorAlto;
  for i := 1 to cantDetalles do
  begin
    if datos[i].codigo <> valorAlto then
    begin
      if (min.codigo = valorAlto) or 
         (datos[i].codigo < min.codigo) or 
         ((datos[i].codigo = min.codigo) and (datos[i].numero < min.numero)) then
      begin
        min := datos[i];
        posMin := i;
      end;
    end;
  end;
  if posMin <> -1 then
    leer(archivos[posMin], datos[posMin]);
end;

{ Abre y lee el primer registro de cada archivo detalle }
procedure iniciarDetalles(var archivos: atDetalles; var datos: atCalzadoVendido);
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

procedure cerrarDetalles(var archivos: atDetalles);
var
  i: integer;
begin
  for i := 1 to cantDetalles do
    close(archivos[i]);
end;

{ Programa principal }
var 
  maestro: tMaestro;
  detalles: atDetalles;
  detalleActual: atCalzadoVendido;
  min, aux: tCalzadoVendido;
  calzadoMaestro: tCalzado;
  ventas: integer;
  informe: text;
begin
  { Inicializamos los detalles }
  iniciarDetalles(detalles, detalleActual);
  
  assign(maestro, 'maestro.dat');
  reset(maestro);
  
  assign(informe, 'calzadosinstock.txt');
  rewrite(informe);
  
  { Leemos el primer registro del maestro }
  if not EOF(maestro) then
    read(maestro, calzadoMaestro)
  else
  
  begin
    writeln('El archivo maestro está vacío.');
    halt(1);
  end;
  
  { Obtenemos el primer registro de los detalles }
  minimo(detalles, detalleActual, min);
  
  while (min.codigo <> valorAlto) do
  begin
    aux := min;
    ventas := 0;
    
    { Acumula todas las ventas del detalle para un mismo calzado (código y número) }
    while (min.codigo = aux.codigo) and (min.numero = aux.numero) do
    begin
      ventas := ventas + min.ventas;
      minimo(detalles, detalleActual, min);
    end;
    
    { Avanza en el maestro hasta encontrar el registro correspondiente }
    while ((calzadoMaestro.codigo < aux.codigo) or 
          ((calzadoMaestro.codigo = aux.codigo) and (calzadoMaestro.numero < aux.numero))) do
    begin
      { Si el calzado del maestro no tuvo ventas, se informa por pantalla }
      writeln('El calzado de codigo ', calzadoMaestro.codigo, ' en el numero ', calzadoMaestro.numero, ' no tuvo ventas');
      if not EOF(maestro) then
        read(maestro, calzadoMaestro)
      else
        break;
    end;
    
    { Si se encontró el registro en el maestro que coincide con el detalle }
    if (calzadoMaestro.codigo = aux.codigo) and (calzadoMaestro.numero = aux.numero) then
    begin
      { Solo se realizan ventas si se posee stock suficiente }
      if calzadoMaestro.stock >= ventas then
        calzadoMaestro.stock := calzadoMaestro.stock - ventas
      else
        { Si no hay stock suficiente, se podría informar o simplemente no actualizar }
        writeln('No se realizaron ventas para el calzado de codigo ', calzadoMaestro.codigo, ' en el numero ', calzadoMaestro.numero, ' por falta de stock.');
      
      { Actualizamos el registro maestro }
      seek(maestro, filepos(maestro) - 1);
      write(maestro, calzadoMaestro);
      
      { Si el stock queda por debajo del stock mínimo, se informa en el archivo de texto }
      if calzadoMaestro.stock < calzadoMaestro.sMinimo then
        writeln(informe, 'El calzado de codigo ', calzadoMaestro.codigo, ' en el numero ', calzadoMaestro.numero, ' quedo por debajo del stock minimo');
      
      { Leemos el siguiente registro del maestro }
      if not EOF(maestro) then
        read(maestro, calzadoMaestro);
    end;
  end;
  
  { Procesamos el resto de registros del maestro que no tuvieron ventas }
  while not EOF(maestro) do
  begin
    writeln('El calzado de codigo ', calzadoMaestro.codigo, ' en el numero ', calzadoMaestro.numero, ' no tuvo ventas');
    read(maestro, calzadoMaestro);
  end;
  
  cerrarDetalles(detalles);
  close(informe);
  close(maestro);
end.
