#lang racket

#|
TAREA 1. Extender el lenguaje LET
Nombre: Melissa María Duarte Rodriguez

Para leer las reglas:
(value-of e ρ) = v dice que e da el valor v usando el entorno ρ.
En las reglas uso enteros, #t, #f y listas ⟨...⟩.
En las tablas pongo los resultados como salen en Racket, por ejemplo (intval 4).
La flecha ⇝ indica cómo se cambia el azúcar por expresiones del núcleo.
Si pongo error, la expresión falla y no devuelve un valor.

not
---
4. Contraste
Expresión             | Predicción por las reglas | Resultado al ejecutar
not(zero?(0))         | (boolval #f)              | (boolval #f)
not(false)            | (boolval #t)              | (boolval #t)
not(0) [borde]        | error: no es booleano     | error: val->bool
Trazas: zero?(0) = #t y [not-v] da #f. false ⇝ zero?(1) = #f y
[not-f] da #t. En not(0), 0 no es un booleano;
val->bool lo rechaza. Aquí 0 no cuenta como false.
Los tres casos dan lo que indican las reglas. not(0) falla porque necesita
un booleano. No hace falta cambiar las reglas ni el código.

and
---
4. Contraste
Expresión                          | Predicción por las reglas | Resultado al ejecutar
and(true, false)                   | (boolval #f)              | (boolval #f)
and(true, true)                    | (boolval #t)              | (boolval #t)
and(false, car(emptylist)) [borde] | (boolval #f)              | (boolval #f)
Trazas: [and] traduce a if. Con true, [if-v] evalúa el segundo
argumento: false en la primera fila y true en la segunda. Con false,
[if-f] elige false y no evalúa car(emptylist).
Los resultados coinciden. Cuando el primero es false, no se calcula el
segundo, así que no sale el error de car. No hace falta cambiar nada.

or
--
1. Propuesta informal
Primero calcula el valor de la expresión de la izquierda, que debe ser
booleana. Si da true, ya devuelve true y no calcula la otra. Si da false,
calcula la de la derecha; también debe ser booleana y ese es el resultado.

2. Especificación formal
Expression ::= or(Expression, Expression)    (or-exp e1 e2)

          (value-of e1 ρ) = #t
---------------------------------------------- [or-v]
(value-of (or-exp e1 e2) ρ) = #t

(value-of e1 ρ) = #f    (value-of e2 ρ) = b    b ∈ Bool
------------------------------------------------------ [or-f]
(value-of (or-exp e1 e2) ρ) = b

(value-of e1 ρ) = v    v ∉ Bool
---------------------------------------------- [or-tipo-1]
(value-of (or-exp e1 e2) ρ) = error

(value-of e1 ρ) = #f    (value-of e2 ρ) = v    v ∉ Bool
------------------------------------------------------ [or-tipo-2]
(value-of (or-exp e1 e2) ρ) = error

En [or-v] no aparece e2 arriba de la línea porque no se calcula.
En [or-f], b puede ser #t o #f. Si una expresión que sí se calcula falla,
la expresión completa también falla. Esto aplica a los demás constructos.

4. Contraste
Expresión                        | Predicción por las reglas | Resultado al ejecutar
or(false, true)                  | (boolval #t)              | (boolval #t)
or(false, false)                 | (boolval #f)              | (boolval #f)
or(true, car(emptylist)) [borde]  | (boolval #t)              | (boolval #t)
Trazas: en las primeras dos filas e1 = #f y [or-f] devuelve el booleano
de e2, #t y #f respectivamente. En la tercera, e1 = #t y [or-v]
devuelve #t sin evaluar car(emptylist).
Los tres casos coinciden con las reglas. En el último no se calcula
car(emptylist), justo como hace el código dado. No hay nada que corregir.

xor
---
1. Propuesta informal
Si los dos valores son booleanos, da true cuando son distintos y false
cuando son iguales. Primero calcula e1: si da true, usa not(e2); si da
false, devuelve e2. Solo calcula e2 una vez.

2. Especificación formal
Expression ::= xor(Expression, Expression)    (xor-exp e1 e2)
xor(e1, e2) ⇝ if e1 then not(e2) else e2        [xor]

e1 debe ser booleano porque es la condición del if. Cuando da true,
not también pide que e2 sea booleano. Cuando da false, el else devuelve
e2 tal cual. Por eso xor(false, 7) da 7: la traducción dada no revisa
que esa rama sea booleana.

4. Contraste
Expresión                 | Predicción por las reglas | Resultado al ejecutar
xor(true, true)           | (boolval #f)              | (boolval #f)
xor(true, false)          | (boolval #t)              | (boolval #t)
xor(false, 7) [borde]     | (intval 7)                | (intval 7)
Trazas: [xor] produce if; [if-v] elige not(true) o not(false), y
[not-v]/[not-f] dan #f/#t. En la tercera, [if-f] elige 7 y [const]
da 7 sin pasar por not.
Los tres resultados coinciden. El último puede parecer raro, pero sale
de la regla dada. Para rechazar ese 7 habría que cambiar la traducción;
aquí dejé la que pide la tarea.

cond
----
2. Especificación formal: solo la regla de cond end
cond end ⇝ car(emptylist)                      [cond-vacío]

Elegí car(emptylist) porque un cond sin ramas no tiene un resultado
que devolver. Si todas las pruebas dan false, también llega a este error.
Si una prueba no es booleana, falla el if. Traducir no calcula los valores:
las ramas se eligen después, cuando se evalúa la expresión.

4. Contraste
Expresión | Predicción por las reglas | Resultado al ejecutar
let x = 3 in cond zero?(x) ==> 100 zero?(-(x,3)) ==> 200 end | (intval 200) | (intval 200)
cond true ==> 8 true ==> car(emptylist) end | (intval 8) | (intval 8)
cond end [borde] | error: car de lista vacía | error: car
Trazas: [let] vincula x=3; la primera prueba vale #f y [if-f] continúa.
La segunda vale #t porque 3-3=0; [if-v] devuelve 200. En la segunda
fila, el primer if elige 8 y omite el resto. En la tercera,
[cond-vacío] produce car(emptylist), que no tiene primer elemento.
Los resultados coinciden. El cond vacío falla como indica la regla
que elegí, así que no hace falta cambiar la regla ni el código.

list
----
4. Contraste
Expresión | Predicción por las reglas | Resultado al ejecutar
let x = 4 in list(x, -(x,1), -(x,3)) | L1 | L1
list(true, list(2))                 | L2 | L2
list() [borde]                      | (listval '()) | (listval '())
L1 = (listval (list (intval 4) (intval 3) (intval 1)))
L2 = (listval (list (boolval #t) (listval (list (intval 2)))))
Usé L1 y L2 para que la tabla no quedara tan larga; en las dos columnas
representan los valores completos que aparecen arriba.
Trazas: [list] transforma cada elemento en la cabeza de un cons y
[list-vacía] termina la cola con emptylist. Bajo x=4, las cabezas valen
4, 3 y 1. En la segunda fila se conserva el booleano y la lista interna
como valores; no se aplana. La última usa directamente [list-vacía].
Los resultados coinciden, también con la lista vacía y la lista dentro
de otra lista. No hace falta cambiar las reglas ni el código.

unpack
------
2. Especificación formal
Expression ::= unpack Identifiers = Expression in Expression
                                               (unpack-exp xs e1 e2)
Identifiers ::= ε | Identifier Identifiers
Los nombres se separan con espacios, no con comas.

xs = (x1, ..., xn) es la lista de nombres. E agrega sus valores al entorno:
E((), (), ρ) = ρ
E((x :: xs), (v :: vs), ρ) = E(xs, vs, [x=v]ρ)
Así queda ρ* = [xn=vn] ... [x1=v1]ρ. Si un nombre se repite, se usa
el último valor. e1 se calcula antes de agregar esos nombres.

(value-of e1 ρ) = ⟨v1,...,vm⟩    n = m
ρ* = E(xs, (v1,...,vm), ρ)        (value-of e2 ρ*) = v
------------------------------------------------------ [unpack-ok]
(value-of (unpack-exp xs e1 e2) ρ) = v

(value-of e1 ρ) = ⟨v1,...,vm⟩    n ≠ m
------------------------------------------------------ [unpack-longitud]
(value-of (unpack-exp xs e1 e2) ρ) = error

(value-of e1 ρ) = v    v ∉ List(ExpVal)
------------------------------------------------------ [unpack-tipo]
(value-of (unpack-exp xs e1 e2) ρ) = error

Primero se calcula e1 una vez, con el entorno original, y debe dar una lista.
Si faltan o sobran elementos, hay error y no se calcula e2. Si no hay
nombres y la lista está vacía, el cuerpo usa el mismo entorno.
Sin nombres pero con elementos en la lista, también hay error de longitud.

4. Contraste
Expresión | Predicción por las reglas | Resultado al ejecutar
let u = 7 in unpack x y = list(u, 3) in -(x, y) | (intval 4) | (intval 4)
unpack = list() in 9 [borde] | (intval 9) | (intval 9)
unpack x y = list(1) in -(x, y) [borde] | error: longitud | error: unpack
Trazas: [let] vincula u=7 y [list] produce ⟨7,3⟩. [unpack-ok] extiende
primero x=7 y después y=3; [diff] da 4. En la segunda fila, n=m=0,
E devuelve ρ y [const] da 9. En la tercera, n=2 y m=1;
[unpack-longitud] falla antes de evaluar la resta.
Los resultados coinciden. Sin nombres y con lista vacía funciona;
si la cantidad no coincide, falla antes de calcular el cuerpo.
No hace falta cambiar las reglas ni el código.
|#

(require "ast.rkt"
         "env.rkt"
         "vals.rkt")

(provide
 (contract-out
  [value-of (-> expression? env?
                expval?)]))

;; Intérprete del lenguaje LET
(define (value-of e ρ)
  (match e
    [(const-exp n)    (intval n)]
    [(var-exp x)      (apply-env ρ x)]
    [(diff-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (intval (- (val->int v1)
                (val->int v2)))]
    [(zero?-exp e1)
     (define v1 (value-of e1 ρ))
     (boolval (zero? (val->int v1)))]
    [(if-exp e1 e2 e3)
     (define v1 (value-of e1 ρ))
     (if (val->bool v1)
         (value-of e2 ρ)
         (value-of e3 ρ))]
    [(let-exp x e1 e2)
     (define v1 (value-of e1 ρ))
     (define ρ* (extend-env x v1 ρ))
     (value-of e2 ρ*)]

    ;; La aritmética que va en el núcleo: minus, mul y quotient
    [(minus-exp e1)
     (define v1 (value-of e1 ρ))
     (intval (- (val->int v1)))]
    [(mul-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (intval (* (val->int v1)
                (val->int v2)))]
    [(quotient-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (intval (quotient (val->int v1)
                       (val->int v2)))]

    ;; Los booleanos que van en el núcleo: equal? y less?
    [(equal?-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (boolval (equal? v1 v2))]
    [(less?-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (boolval (val<? v1 v2))]

    ;; Las listas
    [(emptylist-exp)
     (listval '())]
    [(cons-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (define v2 (value-of e2 ρ))
     (listval (cons v1 (val->list v2)))]
    [(car-exp e1)
     (define v1 (value-of e1 ρ))
     (car (val->list v1))]
    [(cdr-exp e1)
     (define v1 (value-of e1 ρ))
     (listval (cdr (val->list v1)))]
    [(null?-exp e1)
     (define v1 (value-of e1 ρ))
     (boolval (null? (val->list v1)))]

    [(not-exp e1)
     (boolval (not (val->bool (value-of e1 ρ))))]
    [(unpack-exp xs e1 e2)
     (define vs (val->list (value-of e1 ρ)))
     (unless (= (length xs) (length vs))
       (error 'unpack "La cantidad de nombres y elementos no coincide"))
     (value-of e2 (extend-env-many xs vs ρ))]

    ;; La tarea, lo que viene hecho en el núcleo: or
    [(or-exp e1 e2)
     (define v1 (value-of e1 ρ))
     (if (val->bool v1)
         (boolval #t)
         (boolval (val->bool (value-of e2 ρ))))]))

;; Si una cláusula necesita una función auxiliar, va aquí abajo, con nombre
;; propio, y no escondida dentro de la cláusula.

;; Agrega cada nombre con su valor y sigue con los que faltan.
;; Las dos listas ya tienen la misma cantidad de elementos.
(define (extend-env-many xs vs ρ)
  (if (null? xs)
      ρ
      (extend-env-many (rest xs) (rest vs)
                       (extend-env (first xs) (first vs) ρ))))

;; El orden de los valores expresados: false es menor que todo lo demás,
;; true es mayor que todo lo demás, y entre números es el < de siempre.
;; Es estricto: ningún valor es menor que sí mismo.
(define (val<? v1 v2)
  (match (list v1 v2)
    [(list (boolval #f) (boolval #f)) #f]
    [(list (boolval #f) _)            #t]
    [(list (boolval #t) _)            #f]
    [(list _            (boolval #f)) #f]
    [(list _            (boolval #t)) #t]
    [(list (intval n1)  (intval n2))  (< n1 n2)]))
