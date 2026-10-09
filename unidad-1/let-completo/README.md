# Tarea 1: extensión de LET

Se agregaron `not`, `and`, `cond`, `list` y `unpack` a la base entregada.
Se conservaron las implementaciones dadas de `or` y `xor`.

La explicación, las reglas y las siete tablas de contraste están en el
comentario inicial de `interp.rkt`. Las producciones de `or`, `xor` y
`unpack` también están en el comentario de `parser.rkt`.

## Comprobar y ejecutar

Desde `unidad-1/let-completo/`, con Racket instalado:

```bash
raco test tests
raco test contraste.rkt
racket main.rkt
```

El primer comando ejecuta las 268 pruebas originales. El segundo ejecuta
los 21 ejemplos de las tablas e imprime los valores y errores obtenidos.
El último abre el REPL: escribe una expresión por línea; una línea vacía sale.

Ejemplo:

```text
==> let u = 7 in unpack x y = list(u, 3) in -(x, y)
(intval 4)
```

## Decisiones de los casos de borde

- `cond end` se traduce a `car(emptylist)` y produce un error.
- `list()` produce la lista vacía.
- `unpack` exige una lista con tantos elementos como nombres. La lista
  se evalúa antes de crear las vinculaciones; el cuerpo solo se evalúa
  cuando las longitudes coinciden.
- `unpack = list() in 9` devuelve 9 sin agregar vinculaciones.
- En nombres repetidos de `unpack`, prevalece el último.
- `or` omite el segundo argumento si el primero es verdadero.
- Las traducciones dadas de `and` y `xor` conservan el comportamiento de
  `if`: `and(true, 7)` y `xor(false, 7)` devuelven `(intval 7)`.

## Entrega

Copia la carpeta completa a `unidad-1/let-completo/` en tu repositorio
del curso y sube los archivos a GitHub. La entrega es esa carpeta;
no se solicita un PDF adicional.
