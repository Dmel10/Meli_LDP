# Cómo revisar y entregar la tarea

## 1. Extraer el ZIP

En Windows, da clic derecho al ZIP y elige Extraer todo. Abre la carpeta
que se creó. Adentro debe estar unidad-1 y dentro de ella let-completo.
No trabajes directamente dentro del ZIP.

## 2. Ver qué contiene

Abre DrRacket. Usa Archivo > Abrir y elige un archivo de let-completo.

- interp.rkt: al principio están las reglas, las explicaciones y las siete
  tablas. Después viene el intérprete.
- ast.rkt: define las estructuras que representan las expresiones.
- desugar.rkt: cambia el azúcar por expresiones que el intérprete entiende.
- parser.rkt: reconoce el texto; se completaron las producciones del comentario.
- main.rkt: permite escribir expresiones y ver sus resultados.
- contraste.rkt: ejecuta los 21 casos que aparecen en las tablas.
- tests: conserva las siete suites de pruebas que dio el profesor.

Los comentarios entre #| y |#, o después de ;;, son explicaciones.
No se ejecutan. Las reglas deben conservar su notación formal.

## 3. Qué se agregó al código

not invierte un booleano. and se convierte en un if. cond se convierte en
varios if, uno dentro de otro. list se convierte en varios cons que terminan
en emptylist. unpack toma una lista y le pone un nombre a cada elemento.

La auxiliar extend-env-many recibe tres cosas: los nombres xs, los valores
vs y el entorno ρ. Si no quedan nombres, devuelve el entorno. Si quedan,
agrega el primer nombre con el primer valor y se llama otra vez con el
resto. Antes de usarla, unpack revisa que las cantidades coincidan.

or y xor ya venían implementados por el profesor. Se conservaron.

## 4. Probar una expresión

Abre main.rkt en DrRacket y pulsa Run / Ejecutar. Si solo aparece el prompt
normal de DrRacket, escribe (repl) y presiona Enter. Cuando aparezca ==>,
escribe:

let u = 7 in unpack x y = list(u, 3) in -(x, y)

El resultado debe ser (intval 4). No escribas el ==> como parte de la expresión.
Una línea vacía termina el REPL.

## 5. Ejecutar las pruebas originales

Abre let-completo en el Explorador de archivos. En la barra de dirección,
escribe cmd y presiona Enter. La terminal se abre en esa carpeta.
Escribe:

raco test tests

Debe decir 268 tests passed. Luego puedes escribir:

raco test contraste.rkt

Este imprime las expresiones de las tablas y debe decir 21 tests passed.
Algunos ejemplos muestran errores a propósito: son los casos de borde.

Si Windows dice que raco no se reconoce, no significa que falló la tarea:
Windows no encontró Racket. Puedes abrir contraste.rkt en DrRacket y
pulsar Run para revisar esos ejemplos. Para el comando raco, localiza la
carpeta donde instalaste Racket y agrega su ruta al PATH, o usa la ruta
completa de raco.exe entre comillas antes de test tests.

## 6. Subir desde la página de GitHub

Entra al repositorio que usas para el curso. Si ya existe unidad-1, entra
ahí. Pulsa Add file > Upload files. Desde Windows arrastra la carpeta
let-completo completa a esa página. Si todavía no existe unidad-1,
haz la carga desde la raíz del repositorio arrastrando unidad-1 completa.

Revisa la lista antes de confirmar: los archivos deben quedar dentro de
unidad-1/let-completo. Evita que quede unidad-1/unidad-1 o let-completo/let-completo.
Escribe un mensaje como Tarea 1 LET y confirma con Commit changes.
Si elegiste crear otra rama y aparece Propose changes, todavía falta
crear el pull request y combinarlo para dejar la entrega en la rama del curso.

Después vuelve a la lista del repositorio y abre unidad-1 > let-completo.
Comprueba que estén los archivos .rkt y la carpeta tests. Abre interp.rkt
para revisar que sea esta versión y que tu nombre esté bien escrito.

Se entrega la carpeta completa, no solamente el ZIP, main.rkt o un PDF.
El enunciado pide subirla al repositorio a más tardar el 8 de octubre de
2026 a las 23:59. Si el profesor te pide un enlace, copia el de la carpeta
en GitHub. Para un repositorio privado, el profesor debe tener acceso.
