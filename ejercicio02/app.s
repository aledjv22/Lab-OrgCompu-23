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
    
    mov x6,0xF
iniArbolecitos:
    mov x3,500 //y de auto
    mov x5,-300 //Y arboles
resetX7:
    mov x7,500
    subs xzr,x5,-10
    b.gt resetX5
    subs xzr,x3,-150
    b.lt resetX3
    b arbolecitos
resetX3:
    mov x3,600 //y de camioneta
    b arbolecitos
resetX5:
    mov x5,-300
arbolecitos:
    bl asfalto
    subs xzr,x6,0xF7
    b.eq amariA
    bl separador
    b sigueA
amariA:
    bl lineasAmarillas
sigueA:
    sub x7,x7,3
    bl autoAzul
    sub x3,x3,5
    bl caminetaBlanca
    add x5,x5,3
    sub x3,x3,120
    bl camineta777
    add x3,x3,120
    bl lineasRojas
    bl puntBlanco
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2
    bl fondo
    add x5,x5,7
    bl arbolada
    bl tiempo
    bl lectura
    bl lecA
    bl lecWArbol
    bl lecSArbol
    subs xzr,x5,-10
    b.gt resetX5
    subs xzr,x3,-150
    b.lt resetX3
    subs xzr,x7,-150
    b.lt resetX7
    b arbolecitos

iniPinitos:
    mov x3,500 //y de auto
    mov x5,-300 //Y arboles
resetX7B:
    mov x7,500
    subs xzr,x5,-10
    b.gt resetX5B
    subs xzr,x3,-150
    b.lt resetX3B
    b pinitos
resetX3B:
    mov x3,600 //y de camioneta
    b pinitos
resetX5B:
    mov x5,-300
    //pinitos
pinitos:
    bl asfalto
    subs xzr,x6,0xF7
    b.eq amariP
    bl separador
    b sigueP
amariP:
    bl lineasAmarillas
sigueP:
    sub x7,x7,3
    bl autoAzul
    sub x3,x3,5
    bl caminetaBlanca
    add x5,x5,3
    sub x3,x3,120
    bl camineta777
    add x3,x3,120
    bl lineasRojas
    bl puntBlanco
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2
    bl fondo
    add x5,x5,7
    bl pinar
    bl tiempo
    bl lectura
    bl lecA
    bl lecWPino
    bl lecSPino
    subs xzr,x5,-10
    b.gt resetX5B
    subs xzr,x3,-150
    b.lt resetX3B
    subs xzr,x7,-150
    b.lt resetX7B
    b pinitos

iniCactitus:
    mov x3,500 //y de auto
    mov x5,-300 //Y arboles
resetX7C:
    mov x7,500
    subs xzr,x5,-10
    b.gt resetX5
    subs xzr,x3,-150
    b.lt resetX3
    b cactitus
resetX3C:
    mov x3,600 //y de camioneta
    b cactitus
resetX5C:
    mov x5,-300
    //b arbolecitos
cactitus:
    bl asfalto
    subs xzr,x6,0xF7
    b.eq amariC
    bl separador
    b sigueC
amariC:
    bl lineasAmarillas
sigueC:
    sub x7,x7,3
    bl autoAzul
    sub x3,x3,5
    bl caminetaBlanca
    add x5,x5,3
    sub x3,x3,120
    bl camineta777
    add x3,x3,120
    bl lineasRojas
    bl puntBlanco
    movz x10, 0xFF, lsl 16 //color lima parte 1
    movk x10, 0xD500, lsl 00 //color lima parte 2
    bl fondo
    add x5,x5,7
    bl cactada
    bl tiempo
    bl lectura
    bl lecA
    bl lecWCactus
    bl lecSCactus
    subs xzr,x5,-10
    b.gt resetX5C
    subs xzr,x3,-150
    b.lt resetX3C
    subs xzr,x7,-150
    b.lt resetX7C
    b cactitus

//Fin loop
    b InfLoop

tiempo:
    //mov x10, #0x0EE6B280 = 250000000 //07735940
    movz x10,0x0773,lsl 16 //tiempo de delay parte 1
    movk x10,0x5940,lsl 00 //tiempo de delay parte 2
    delay_loop:
        sub x10, x10, #4
        cbnz x10,delay_loop
    br lr

//Leo
lectura:
    //Configuraciones generales del GPIO
    mov x10, GPIO_BASE //Almaceno la dirección base del GPIO en x10
    str wzr, [x10, GPIO_GPFSEL0] //Setea gpios 0 - 9 como lectura
    ldr w10, [x10, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000111110 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    br lr
lecWArbol:
    subs wzr, w10, 0b00010
    b.eq pinitos
    br lr
lecWPino:
    subs wzr, w10, 0b00010
    b.eq cactitus
    br lr
lecWCactus:
    subs wzr, w10, 0b00010
    b.eq arbolecitos 
    br lr
lecSArbol:
    subs wzr, w10, 0b01000
    b.eq cactitus
    br lr
lecSPino:
    subs wzr, w10, 0b01000
    b.eq arbolecitos 
    br lr
lecSCactus:
    subs wzr, w10, 0b01000
    b.eq pinitos 
    br lr

lecA:
    subs wzr, w10, 0b00100
    b.eq estA1
    br lr
    estA1:
        subs xzr,x6,0xF7
        b.eq sigueA1
        mov x6,0xF7
        br lr
    sigueA1:
        mov x6,0xF
        br lr


//Funcion encargada de dibujar el fondo (pasto)
fondo:
    mov x1,lr //Almaceno la direccion de llamada
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x17,0 //PX
    mov x18,120 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x17,520 //PX
    mov x18,SCREEN_WIDTH //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    br x1 //Retorno a la direccion de llamada

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

//Funcion encargada de dibujar lineas amarillas
lineasAmarillas:
    mov x1,lr
    movz x10, 0xFF, lsl 16 //color amarillo
    movk x10, 0xE53D, lsl 0
    mov x15,0 //PY
    mov x17,250 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,253 //FX
    bl rectangulo 
    mov x15,0 //PY
    mov x17,256 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,259 //FX
    bl rectangulo 
    movz x10, 0xFF, lsl 16 //color amarillo
    movk x10, 0xE53D, lsl 0
    mov x15,0 //PY
    mov x17,381 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,384 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    mov x15,0 //PY
    mov x17,387 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,390 //FX
    bl rectangulo 
    br x1
//Funcion encargada de dibujar lineas separadas en el borde del asfalto
puntBlanco:
    mov x1,lr
    movz x10, 0xE5, lsl 16 //color blanco parte 1
    movk x10, 0xE4E4, lsl 00 //color blanco parte 2 
    mov x17,120 //PX
    mov x18,125 //FX
    mov x15,x5 //PY
    add x16,x15,15 //FY
    mov x23,10 //sep del punteado
    mov x24,700 //tam de largo de todo
    bl repRectanguloY
    mov x17,515 //PX
    mov x18,520 //FX
    mov x15,x5 //PY
    add x16,x15,15 //FY
    mov x23,10 //sep del punteado
    mov x24,700 //tam de largo de todo
    bl repRectanguloY
    br x1

//Funcion encargada de plasmar las lineas que separan las carreteras
separador:
    mov x1,lr
    movz x10, 0xFF, lsl 16 //color blanco parte 1
    movk x10, 0xFFFF, lsl 00 //color blanco parte 2 
    mov x17,253 //PX
    mov x18,256 //FX
    mov x15,x5 //PY
    add x16,x15,30 //FY
    mov x23,10 //sep del punteado
    mov x24,700 //tam de largo de todo
    bl repRectanguloY
    mov x17,384 //PX
    mov x18,387 //FX
    mov x15,x5 //PY
    add x16,x15,30 //FY
    mov x23,10 //sep del punteado
    mov x24,700 //tam de largo de todo
    bl repRectanguloY
    br x1

//Funcion encargada de plasmar un pinar
pinar:
    mov x1,lr
    mov x15,x5 //Y -> PY
    mov x29,x15//val inicial de Y
    pinoIzq:
        mov x17,60 //X -> PX
        mov x15,x29
        bl pino
        add x29,x29,160
        cmp x29,800
        b.lt pinoIzq

    add x15,x5,20 //Y -> PY
    mov x29,x15//val inicial de Y
    pinoDer:
        mov x17,580 //X -> PX
        mov x15,x29
        bl pino
        add x29,x29,160
        cmp x29,800
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
        cmp x16,x24
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
        br x16

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
    sub x15,x27,50
    mov x16,40
    bl triangulo
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    mov x17,x28
    sub x15,x27,70
    mov x16,40
    bl triangulo
    br x26 //regreso a la dire de llamada

//Funcion encargada de plasmar una arbolada de copa circular
arbolada:
    mov x1,lr
    mov x15,x5 //Y -> PY
    mov x29,x15//val inicial de Y
    arbIzq:
        mov x17,60 //X -> PX
        mov x15,x29
        bl arbol
        add x29,x29,110
        cmp x29,800
        b.lt arbIzq

    mov x15,x5 //Y -> PY
    mov x29,x15//val inicial de Y
    arbDer:
        mov x17,580 //X -> PX
        mov x15,x29
        bl arbol
        add x29,x29,110
        cmp x29,800
        b.lt arbDer
    br x1

//Funcion encargada de dibujar un auto azul 
autoAzul:
    mov x1,lr //almaceno la dire de llamado
    mov x17,290 //valor de X
    mov x15,x7 //valor de Y
    movz x14,0xFF,lsl 00 //Color base
    movz x9,0x03,lsl 16 //color sombra parte 1
    movk x9,0x039F,lsl 00 //color sombra parte 2
    bl auto
    br x1

//Funcion encargada de dibujar una camioneta blanca:
caminetaBlanca:
    mov x1,lr //almaceno la dire de llamado
    mov x17,159 //X
    mov x15,x3 //Y
    movz x14,0xFF,lsl 16 //Color base parte 1
    movk x14,0xFFFF,lsl 00 //Color base parte 2
    movz x9,0xBC,lsl 16 //color sombra parte 1
    movk x9,0xBCBC,lsl 00 //color sombra parte 2
    bl camioneta
    br x1 //retorno a la dire de llamado

//Funcion encargada de dibujar una camioneta morada:
camineta777:
    mov x1,lr //almaceno la dire de llamado
    mov x17,425 //valor de X
    mov x15,x3 //valor de Y
    movz x14,0xA2,lsl 16 //Color base parte 1
    movk x14,0x00FF,lsl 00 //Color base parte 2
    movz x9,0x89,lsl 16 //color sombra parte 1
    movk x9,0x04D7,lsl 00 //color sombra parte 2
    bl camioneta
    br x1 //retorno a la dire de llamado
auto:
    mov x11,lr //almaceno la dire de llamado
    
    //guardado de valores iniciales X e Y
    mov x12,x17 //x12 val inicial de X
    mov x13,x15 //x13 val inicial de Y

    //ruedas superiores
    movz x10,0x00,lsl 16 //color negro
    add x15,x13,15 //PY
    add x16,x15,22 //FY
    sub x17,x12,5 //PX
    add x18,x12,65 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //ruedas inferiores 
    add x15,x13,68 //PY
    add x16,x15,22 //FY
    sub x17,x12,5 //PX
    add x18,x12,65 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //base del auto
    mov x10,x14 //color base
    mov x15,x13 //PY
    add x16,x15,105 //FY
    mov x17,x12 //PX
    add x18,x17,60 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //luces amarillas 
    movz x10,0xFF,lsl 16 //color amarillo parte 1
    movk x10,0xF500,lsl 00 //color amarillo parte 2
    sub x15,x13,4 //PY
    mov x16,x13 //FY
    add x17,x12,4 //PX
    add x18,x17,10 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    sub x15,x13,4 //PY
    mov x16,x13 //FY
    add x17,x12,46 //PX
    add x18,x17,10 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //luces rojas
    movz x10,0xFF,lsl 16 //color rojo
    add x15,x13,105 //PY
    add x16,x15,4 //FY
    add x17,x12,4 //PX
    add x18,x17,12 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    add x15,x13,105 //PY
    add x16,x15,4 //FY
    add x17,x12,44 //PX
    add x18,x17,12 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //linea blanca de arriba
    movz x10,0xFF,lsl 16 //color blanco parte 1
    movk x10,0xFFFF,lsl 00 //color blanco parte 2
    mov x15,x13 //PY
    add x16,x15,20 //FY
    add x17,x12,26 //PX
    add x18,x17,8 //FX 
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //vidrio delantero
    movz x10,0x00,lsl 16 //color negro
    add x17,x12,30 //X
    add x15,x13,35 //Y
    mov x4,17
    bl circulo
    //arreglo de vidrio delantero
    mov x10,x14 //color base
    add x15,x13,37 //PY
    add x16,x15,15 //FY
    mov x17,x12 //PX
    add x18,x17,60 //FX 
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    mov x10,x9 //color sombra
    add x15,x13,40 //PY
    add x16,x15,29 //FY
    add x17,x12,19 //PX
    add x18,x17,22 //FX 
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //linea blanca de baja
    movz x10,0xFF,lsl 16 //color blanco parte 1
    movk x10,0xFFFF,lsl 00 //color blanco parte 2
    add x15,x13,37 //PY
    add x16,x15,68 //FY
    add x17,x12,26 //PX
    add x18,x17,8 //FX 
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //ventana izquierda
    movz x10,0x00,lsl 16 //color negro parte
    add x15,x13,40 //PY
    add x16,x15,25 //FY
    add x17,x12,10 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    add x15,x13,44 //PY
    add x16,x15,25 //FY
    add x17,x12,13 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //ventana derecha
    movz x10,0x00,lsl 16 //color negro parte
    add x15,x13,40 //PY
    add x16,x15,25 //FY
    add x17,x12,47 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    add x15,x13,44 //PY
    add x16,x15,25 //FY
    add x17,x12,44 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

    //ventana trasera
    add x15,x13,72 //PY
    add x16,x15,25 //FY
    add x17,x12,16 //PX
    add x18,x17,28 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    br x11

//Funcion encargada de dibujar una camioneta
camioneta:
    mov x11, lr //almaceno la dire de llamado
    mov x12,x17 //x12 almacena el valor inicial de X
    mov x13,x15 //x13 almacena el valor inicial de Y

    //Ruedas de arriba del auto
    movz x10, 0x00, lsl 16 // Color negro parte 1
    add x15,x13,34 // PY (posición Y)
    add x16,x15,29 // FY (fin Y)
    sub x17,x12,11 // PX (posición X)
    add x18,x17,83 // FX (fin X)
    bl rectangulo 
    //Ruedas de abajo del auto
    add x15,x13,101 // PY (posición Y)
    add x16,x15,29 // FY (fin Y)
    sub x17,x12,11 // PX (posición X)
    add x18,x12,72 // FX (fin X)
    bl rectangulo 

    //contornos negros
    add x15,x13,23 //PY  arriba abajo
    add x16,x15,121 //FY
    sub x17,x12,6 //PX ancho hacia izq
    add x18,x12,67 //FX ancho
    bl rectangulo
    //Base del auto
    mov x10,x14 //color base
    add x15,x13,25 //PY  arriba abajo
    add x16,x15,110 //FY
    sub x17,x12,4 //PX ancho hacia izq
    add x18,x12,66 //FX ancho
    bl rectangulo
    
    //capot centro  
    mov x10,x9 //color sombra
    add x15,x13,20 // PY (posición Y)
    add x16,x15,120 // FY (fin Y)
    add x17,x12,11 // PX (posición X)
    add x18,x17,40 // FX (fin X)
    bl rectangulo 
    //detalle blanco capot
    mov x10,x14 //color base
    add x15,x13,20 // PY (posición Y)
    add x16,x15,90// FY (fin Y)
    add x17,x12,20 // PX (posición X)
    add x18,x17,21 // FX (fin X)
    bl rectangulo

    //sobra izq
    mov x10,x14 //color base
    add x15,x13,30 // PY (posición Y)
    add x16,x15,110 // FY (fin Y)
    add x17,x12,51 // PX (posición X)
    add x18,x17,15 // FX (fin X)
    bl rectangulo // Dibujar rueda izquierda

    //parabrisa delantero y parte del baul
    movz x10, 0x00, lsl 16 // Color negro 
    add x15,x13,57 // PY (posición Y)
    add x16,x15,68 // FY (fin Y)
    add x17,x12,12 // PX (posición X)
    add x18,x17,40 // FX (fin X)
    bl rectangulo 
    //parabrisa puertas izq
    add x15,x13,77 // PY (posición Y)
    add x16,x15,17 // FY (fin Y)
    add x17,x12,1 // PX (posición X)
    add x18,x17,7 // FX (fin X)
    bl rectangulo 
    //parabrisa puertas der
    add x15,x13,77 // PY (posición Y)
    add x16,x15,17 // FY (fin Y)
    add x17,x12,56 // PX (posición X)
    add x18,x17,7 // FX (fin X)
    bl rectangulo 

    //BAUL
    add x15,x13,100 // PY (posición Y)
    add x16,x15,30 // FY (fin Y)
    add x17,x12,4 // PX (posición X)
    add x18,x17,57 // FX (fin X)
    bl rectangulo
    //detalles baul
    movz x10, 0x40, lsl 16 // Color negro parte 1
    movk x10, 0x4040, lsl 00 // Color negro parte 2
    add x15,x13,103 // PY (posición Y)
    add x16,x15,24 // FY (fin Y)
    add x17,x12,9 // PX (posición X)
    add x18,x17,5 // FX (fin X)
    bl rectangulo
    add x15,x13,98 // PY (posición Y)
    add x16,x15,29 // FY (fin Y)
    add x17,x12,19 // PX (posición X)
    add x18,x17,6 // FX (fin X)
    bl rectangulo
    add x15,x13,98 // PY (posición Y)
    add x16,x15,29 // FY (fin Y
    add x17,x12,31 // PX (posición X)
    add x18,x17,6 // FX (fin X)
    bl rectangulo
    add x15,x13,98 // PY (posición Y)
    add x16,x15,29 // FY (fin Y
    add x17,x12,43 // PX (posición X)
    add x18,x17,4 // FX (fin X)
    bl rectangulo
    add x15,x13,103 // PY (posición Y)
    add x16,x15,24 // FY (fin Y)
    add x17,x12,53 // PX (posición X)
    add x18,x17,4 // FX (fin X)
    bl rectangulo

    //PARABRISA DELANTERO
    movz x10, 0x00, lsl 16 // Color negro
    add x15,x13,64 // PY (posición Y)
    add x16,x15,8 // FY (fin Y)
    add x17,x12,6 // PX (posición X)
    add x18,x17,52 // FX (fin X)
    bl rectangulo
    movk x10, 0x2828, lsl 00 // Color
    add x15,x13,52 // PY (posición Y)
    add x16,x15,6 // FY (fin Y
    add x17,x12,16 // PX (posición X)
    add x18,x17,32 // FX (fin X)
    bl rectangulo 

    //techo
    mov x10,x9 //color sombra
    add x15,x13,72 // PY (posición Y)
    add x16,x15,23 // FY (fin Y)
    add x17,x12,11 // PX (posición X)
    add x18,x17,42 // FX (fin X)
    bl rectangulo

    //contorno de luces
    movz x10, 0x00, lsl 16 //negro sombra
    add x15,x13,20 //PY  arriba abajo
    add x16,x15,10 //FY
    sub x17,x12,4 //PX ancho hacia izq
    add x18,x12,14 //FX ancho
    bl rectangulo
    add x15,x13,20 //PY  arriba abajo
    add x16,x15,10 //FY
    add x17,x12,48//PX ancho hacia izq
    add x18,x17,18 //FX ancho
    bl rectangulo
    add x15,x13,134 //PY  arriba abajo
    add x16,x15,13 //FY
    sub x17,x12,6 //PX ancho hacia izq
    add x18,x12,14 //FX ancho
    bl rectangulo
    add x15,x13,134 //PY  arriba abajo
    add x16,x15,13 //FY
    add x17,x12,47 //PX ancho hacia izq
    add x18,x17,20 //FX ancho
    bl rectangulo
    
    //Luces amarillas
    movz x10, 0xFF, lsl 16 //amarillo
    movk x10, 0xF500, lsl 00
    add x15,x13,23 //PY  arriba abajo
    add x16,x15,4  //FY
    mov x17,x12 //PX ancho hacia izq
    add x18,x17,11 //FX ancho
    bl rectangulo
    add x15,x13,23 //PY  arriba abajo
    add x16,x15,4  //FY
    add x17,x12,52 //PX ancho hacia izq
    add x18,x17,11 //FX ancho
    bl rectangulo

    //Luces rojas 
    movz x10, 0xFF, lsl 16 //color rojo
    add x15,x13,136 //PY arriba abajo
    add x16,x15,5 //FY
    sub x17,x12,2 //PX ancho hacia izq
    add x18,x12,11 //FX ancho
    bl rectangulo
    add x15,x13,136 //PY arriba abajo
    add x16,x15,5 //FY
    add x17,x12,51 //PX ancho hacia izq
    add x18,x17,13 //FX ancho
    bl rectangulo

    br x11 //retorno a la dire de llamado




//arbolada de cactus
cactada:
    mov x1,lr
    mov x15,x5 //Y -> PY
    mov x29,x15//val inicial de Y
    cacIzq:
        mov x17,60 //X -> PX
        mov x15,x29
        bl cacto
        add x29,x29,110
        cmp x29,800
        b.lt cacIzq

    mov x15,x5 //Y -> PY
    mov x29,x15//val inicial de Y
    cacDer:
        mov x17,580 //X -> PX
        mov x15,x29
        bl cacto 
        add x29,x29,110
        cmp x29,800
        b.lt cacDer
    br x1
//Funcion encargada de plasmar un cactus
cacto:
    mov x8,x15 //inicial y
    mov x28,x17 //inicial x
    mov x26,lr //guardo la dire de partida


    movz x10, 0x00, lsl 16 //color verde parte 1
    movk x10, 0x4900, lsl 00 //color verde parte 2
    //tronquitos
    sub x17,x28,2 //PX
    add x18,x28,8 //FX
    add x15,x8,0 //PY
    add x16,x8,60 //FY
    bl rectangulo 
    //leg izq
    sub x17,x28,20 //PX
    add x18,x28,5 //FX
    add x15,x8,35 //PY
    add x16,x8,45 //FY
    bl rectangulo 
    sub x17,x28,20 //PX
    add x18,x28,-8 //FX
    add x15,x8,12 //PY
    add x16,x8,40 //FY
    bl rectangulo

    //leg rgt
    sub x17,x28,0 //PX
    add x18,x28,20 //FX
    add x15,x8,28 //PY
    add x16,x8,38 //FY
    bl rectangulo 
    sub x17,x28,-16//PX
    add x18,x28,26//FX
    add x15,x8,12 //PY
    add x16,x8,38 //FY
    bl rectangulo
    
    //crc medio
    movz x10,0x00,lsl 16 //color verde oscuro parte 1
    movk x10,0x4900, lsl 00 //color verde oscuro parte 2
    add x15, x8, 3
    add x17, x28, 3
    mov x4,6
    bl circulo 
    //crc der
    movz x10,0xFF,lsl 16 //color verde oscuro parte 1
    movk x10,0x4900, lsl 00 //color verde oscuro parte 2
    add x15, x8, 14
    add x17, x28, 21
    mov x4,6
    bl circulo
    // crc izq
    movz x10,0xFF,lsl 16 //color verde oscuro parte 1
    movk x10,0x7F50, lsl 00 //color verde oscuro parte 2
    add x15, x8, 10  // Y
    add x17, x28, -14 // X
    mov x4,6
    bl circulo
    br x26 //regreso a la dire de llamada

InfLoop:
	b InfLoop
