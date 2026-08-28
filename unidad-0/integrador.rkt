#lang racket

;; Seccion 1

(struct num-exp (n) #:transparent)
(struct id-exp (x) #:transparent)
(struct add-exp (e1 e2) #:transparent)
(struct mul-exp (e1 e2) #:transparent)
(struct with-exp (nombre expr cuerpo) #:transparent)


;; Seccion 2

(define (asocs-vacias) '())

(define (extender asocs nombre valor)
  (cons (cons nombre valor) asocs))

(define (buscar nombre asocs)
  (cdr (assoc nombre asocs)))

(define (calc e asocs)
  (match e
    [(num-exp n) n]
    [(id-exp x) (buscar x asocs)]
    [(add-exp e1 e2) (+ (calc e1 asocs) (calc e2 asocs))]
    [(mul-exp e1 e2) (* (calc e1 asocs) (calc e2 asocs))]
    [(with-exp nombre expr cuerpo)
     (let ([val (calc expr asocs)])
       (calc cuerpo (extender asocs nombre val)))]))


;; casos

(define caso-a
  (add-exp
   (num-exp 3)
   (mul-exp (num-exp 2) (num-exp 4))))

(define caso-b
  (with-exp 'y
            (add-exp (num-exp 3) (num-exp 4))
            (mul-exp (id-exp 'y) (id-exp 'y))))

(define caso-c
  (with-exp 'x
            (add-exp (num-exp 2) (num-exp 3))
            (with-exp 'y
                      (mul-exp (id-exp 'x) (num-exp 2))
                      (add-exp (id-exp 'x) (id-exp 'y)))))

(define caso-d
  (with-exp 'a
            (num-exp 5)
            (mul-exp
             (with-exp 'b
                       (add-exp (id-exp 'a) (num-exp 1))
                       (id-exp 'b))
             (id-exp 'a))))


(calc caso-a (asocs-vacias))
(calc caso-b (asocs-vacias))
(calc caso-c (asocs-vacias))
(calc caso-d (asocs-vacias))


;; Seccion 3

#|
Trazado de: with x = add(2,3) in with y = mul(x,2) in add(x,y)

Abreviaturas:
N2 = (num-exp 2)
N3 = (num-exp 3)
Ex = (add-exp N2 N3)
Ix = (id-exp 'x)
Iy = (id-exp 'y)
Ey = (mul-exp Ix N2)
Cuerpo = (add-exp Ix Iy)

(calc (with-exp 'x Ex (with-exp 'y Ey Cuerpo)) sigma0)
= (calc (with-exp 'y Ey Cuerpo)
        extend(sigma0, x, (calc Ex sigma0))) [with]

= (calc (with-exp 'y Ey Cuerpo)
        extend(sigma0, x, (calc N2 sigma0) + (calc N3 sigma0))) [add]

= (calc (with-exp 'y Ey Cuerpo)
        extend(sigma0, x, 2 + (calc N3 sigma0))) [num]

= (calc (with-exp 'y Ey Cuerpo)
        extend(sigma0, x, 2 + 3)) [num]

= (calc (with-exp 'y Ey Cuerpo) sigma1)
con sigma1 = extend(sigma0, x, 5)

= (calc Cuerpo
        extend(sigma1, y, (calc Ey sigma1))) [with]

= (calc Cuerpo
        extend(sigma1, y, (calc Ix sigma1) * (calc N2 sigma1))) [mul]

= (calc Cuerpo
        extend(sigma1, y, lookup(x, sigma1) * (calc N2 sigma1))) [id]

= (calc Cuerpo
        extend(sigma1, y, 5 * (calc N2 sigma1))) [num]

= (calc Cuerpo
        extend(sigma1, y, 5 * 2)) [num]

= (calc Cuerpo sigma2)
con sigma2 = extend(sigma1, y, 10)

= (calc Ix sigma2) + (calc Iy sigma2) [add]

= lookup(x, sigma2) + (calc Iy sigma2) [id]

= 5 + lookup(y, sigma2) [id]

= 5 + 10

= 15
|#