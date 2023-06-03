	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

main:
    //x0 contiene la dirección base del framebuffer
    mov x20, x0 //Guarda la dirección base del framebuffer en x20
    //---------------- CODE HERE ------------------------------------
    arbolecitos:
    bl fondo
    bl asfalto
    bl lineasRojas
    bl puntBlanco
    bl separador
    bl arbolada
    
    //Configuraciones generales del GPIO
    mov x2, GPIO_BASE //Almaceno la dirección base del GPIO en x2
    str wzr, [x2, GPIO_GPFSEL0] //Setea gpios 0 - 9 como lectura
leoW:
    ldr w10, [x2, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    sub w10, w10, 0b10
    cbnz w10, leoW //Si la tecla 'w' no fue precionado leo de nuevo

pinitos:
    bl fondo
    bl asfalto
    bl lineasRojas
    bl puntBlanco
    bl separador
    bl pinar


    b InfLoop

//Funcion encargada de dibujar el fondo (pasto)
fondo:
    mov x1,lr
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2
    mov x15,0 //PY
    mov x17,0 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,SCREEN_WIDTH //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    br x1

//Funcion encargada de dibujar el asfalto
asfalto:
    mov x1,lr
    movz x10, 0xC0, lsl 16 //color gris parte 1
    movk x10, 0xC0C0, lsl 00 //color gris parte 2 
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    br x1

//Funcion encargada de plasmar las lineas rojas del borde del asfalto
lineasRojas:
    mov x1,lr
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,125 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,515 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    br x1

//Funcion encargada de dibujar lineas separadas en el borde del asfalto
puntBlanco:
    mov x1,lr
    movz x10, 0xE5, lsl 16 //color blanco parte 1
    movk x10, 0xE4E4, lsl 00 //color blanco parte 2 
    mov x17,120 //PX
    mov x18,125 //FX
    mov x15,0 //PY
    mov x16,15 //FY
    mov x23,10 //sep del punteado
    mov x24,SCREEN_HEIGH //tam de largo de todo
    bl repRectanguloY
    mov x17,515 //PX
    mov x18,520 //FX
    mov x15,0 //PY
    mov x16,15 //FY
    mov x23,10 //sep del punteado
    mov x24,SCREEN_HEIGH //tam de largo de todo
    bl repRectanguloY
    br x1

//Funcion encargada de plasmar las lineas que separan las carreteras
separador:
    mov x1,lr
    movz x10, 0xFF, lsl 16 //color blanco parte 1
    movk x10, 0xFFFF, lsl 00 //color blanco parte 2 
    mov x17,253 //PX
    mov x18,256 //FX
    mov x15,0 //PY
    mov x16,30 //FY
    mov x23,10 //sep del punteado
    mov x24,SCREEN_HEIGH //tam de largo de todo
    bl repRectanguloY
    mov x17,384 //PX
    mov x18,387 //FX
    mov x15,0 //PY
    mov x16,30 //FY
    mov x23,10 //sep del punteado
    mov x24,SCREEN_HEIGH //tam de largo de todo
    bl repRectanguloY
    br x1

//Funcion encargada de plasmar un pinar
pinar:
    mov x1,lr
    mov x15,80 //Y -> PY
    mov x29,x15//val inicial de Y
    pinoIzq:
        mov x17,60 //X -> PX
        mov x15,x29
        bl pino
        add x29,x29,160
        cmp x29,SCREEN_HEIGH
        b.lt pinoIzq

        mov x15,80 //Y -> PY
        mov x29,x15//val inicial de Y
    pinoDer:
        mov x17,580 //X -> PX
        mov x15,x29
        bl pino
        add x29,x29,160
        cmp x29,SCREEN_HEIGH
        b.lt pinoDer
    br x1


//Funcion encargada de dibujar un rectangulo
rectangulo://x15=PY;x16=FY;x17=PX;x18=FX;w10=color;x19=auxX;x21=auxY;x22=auxDire
    mov x22,lr //guardo dire de partida
    mov x19,x17 //almaceno el valor inicial de X
    mov x21,x15 //almaceno el valor inicial de y
    loop1:
        mov x17,x19 //restauro el valor inicial de X
    loop0:
        bl pintar_pixel
        add x17,x17,1 //X++
        subs xzr,x17,x18 //PX <= FX
        b.le loop0
        add x15,x15,1 //Y++
        subs xzr,x15,x16 //Y < FY 
        b.lt loop1
        mov x15,x21 //restauro el valor inicial de Y/PY
        mov x17,x19 //restauro el valor inicial de X/PX
        br x22 //Retorno a la ubicación de la llamada 


//Funcion encargada de dibujar rectangulos repetidos en Y
repRectanguloY:
    mov x25,lr //Almaceno la direccion de llamada
    sub x26,x16,x15 //tam y
    loopRec:
        bl rectangulo
        add x15,x16,x23 //PY += tamDeSeparación
        add x16,x15,x26 //FY 
        subs xzr,x16,x24
        b.lt loopRec
    br x25 //Retorno a la ubicación de la llamada 



//Funcion encargada de dibujar un circulo
circulo:
	// Draws a circle given a (x0, y0) center coords (x17, x15) a radius (x4) and a color (x10)
	mov x16,lr //guardo el valor del lr(x30)
	mov x18,x17 // Save center coords
	mov x19,x15
	add x27,x15,x4 // Save end of vertical lines
	add x25,x17,x4 // Save end of horizontal line
	sub x17,x17,x4
	sub x15,x15,x4 // set the coords to the leftmost top corner of the square r^2
	smull x22,w4,w4 // save r^2
    loopcircle:
        sub x23,x17,x18 
        smull x23,w23,w23 // (X - x0)^2
        sub x24,x15,x19
        smull x24,w24,w24 // (Y - y0)^2
        add x24,x24,x23 // add results
        cmp x22, x24
        b.le skip_paint
        bl pintar_pixel
    skip_paint:
        add x17,x17,1
        cmp x25,x17
        b.ne loopcircle
        sub x17,x17,x4
        sub x17,x17,x4 // Reset x coord
        add x15,x15,1
        cmp x27,x15
        b.ne loopcircle
        ret x16

pintar_pixel:
    mov x21,SCREEN_WIDTH //x21 = 640
    mul x21,x15,x21 //Y*640
    add x21,x17,x21 //X + Y*640
    lsl x21,x21,2 //4 * (X + Y*640)
    add x21,x0,x21 //direIni + 4*(X + Y*640)
    stur w10,[x21] //pinto el pixel
    mov x0,x20
    br lr

//Funcion encargada de dibujar un triangulo   
triangulo:
    //coordenadas (x,y) son (x17,x15), color x10, dire x27,alto x16
    mov x23,lr //almaceno la dire de llamada
    mov x4,1 //determino 1 la longitud de la fila horizontal
    bl pintar_pixel //pinto el pixel actual
    loopTriangulo:
        bl pintarFila //pinta una fila
        add x15,x15,1 //Y++
        bl pintarFila
        add x15,x15,1 //Y++
        sub x17,x17,1 //X--
        add x4,x4,2 //Incremento el tamaño de la fila
        sub x16, x16, 1  //Decremento el contador de tamaño
        cmp xzr,x16 // 0 < x16 (alt)
        b.lt loopTriangulo
        br x23

//Funcion encargada de pintar una fila
pintarFila:
    //Pinta una fila horizontal dadas unas (x,y) coords (x17,x15) una longitud (x4) y un color (x10)
    mov x24,lr //almaceno la dire de llamada
    mov x25,x4 //almaceno el valor inicial de la longitud en x25
    loopHorizontal:
        bl pintar_pixel //pinto el pixel actual
        add x17,x17,1 //X++
        sub x25,x25,1 //Disminuyo en 1 el valor de la longitud
        cmp xzr,x25 //0 < longitud
        b.lt loopHorizontal
        sub x17,x17,x4 //Reseteo X
        br x24

//Funcion encargada de dibujar un arbol normal (copa circular)
arbol:
    //tronco
    mov x27,x15 //inicial y
    mov x28,x17 //inicial x
    mov x26,lr //guardo la dire de partida
    movz x10, 0x6F, lsl 16 //color marron parte 1
    movk x10, 0x4908, lsl 00 //color marron parte 2
    sub x17,x17,3 //PX
    add x18,x28,3 //FX
    add x15,xzr,x15 //PY
    add x16,x15,60 //FY
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion
    //Hojas
    movz x10,0x15,lsl 16 //color verde oscuro parte 1
    movk x10,0x7705, lsl 00 //color verde oscuro parte 2
    mov x17,x28
    mov x15,x27
    mov x4,30
    bl circulo
    br x26 //regreso a la dire de llamada

//Funcion encargada de dibujar un pino
pino:
    //tronco
    mov x27,x15 //inicial y
    mov x28,x17 //inicial x
    mov x26,lr //guardo la dire de partida
    movz x10, 0x6F, lsl 16 //color marron parte 1
    movk x10, 0x4908, lsl 00 //color marron parte 2
    sub x17,x17,3 //PX
    add x18,x28,3 //FX
    add x15,xzr,x15 //PY
    add x16,x15,60 //FY
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion
    //Hojas
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    mov x17,x28
    sub x15,x27,35
    mov x16,40
    bl triangulo
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    mov x17,x28
    sub x15,x27,70
    mov x16,40
    bl triangulo
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    mov x17,x28
    sub x15,x27,50
    mov x16,40
    bl triangulo
    br x26 //regreso a la dire de llamada

//Funcion encargada de plasmar una arbolada de copa circular
arbolada:
    mov x1,lr
    mov x15,50 //Y -> PY
    mov x29,x15//val inicial de Y
    arbIzq:
        mov x17,60 //X -> PX
        mov x15,x29
        bl arbol
        add x29,x29,110
        cmp x29,SCREEN_HEIGH
        b.lt arbIzq

        mov x15,50 //Y -> PY
        mov x29,x15//val inicial de Y
    arbDer:
        mov x17,580 //X -> PX
        mov x15,x29
        bl arbol
        add x29,x29,110
        cmp x29,SCREEN_HEIGH
        b.lt arbDer
    br x1

InfLoop:
	b InfLoop
