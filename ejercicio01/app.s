	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

main:
    //x0 contiene la dirección base del framebuffer
    //---------------- CODE HERE ------------------------------------
//Implementación del SP implementado a ultimo momneto ya que recién lo aprendimos
//Procedimiento encargado de plasmar el paisaje arbolecito usando el llamado de otros procedimientos
arbolecitos:
    bl fondo
    bl asfalto
    bl lineasRojas
    bl puntBlanco
    bl separador
    bl arbolada
    bl autoAzul
    bl caminetaBlanca
    bl leoW

//Procedimiento encargado de plasmar el paisaje pinitos usando el llamado de otros procedimientos
pinitos:
    bl fondo
    bl asfalto
    bl lineasRojas
    bl puntBlanco
    bl separador
    bl pinar
    bl autoGris
    bl camineta777
    bl leoW
    b arbolecitos

//"Fin" loop
    b InfLoop

//Procedimiento encargado de la lectura de la tecla W
leoW:
    //Configuraciones generales del GPIO
    mov x2, GPIO_BASE //Almaceno la dirección base del GPIO en x2
    str wzr, [x2, GPIO_GPFSEL0] //Setea gpios 0 - 9 como lectura
    leo:
        ldr w10, [x2, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
        and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
        sub w10, w10, 0b10
        cbnz w10, leo //Si la tecla 'w' no fue presionado leo de nuevo
    releo:
        ldr w10, [x2, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
        and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
        cbnz w10, releo //Si la tecla 'w' no dejo de ser presionada leo de nuevo
    br lr

//procedimiento encargado de dibujar el fondo (pasto)
fondo:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamada
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2
    mov x15,0 //PY
    mov x17,0 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,120 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    mov x17,520
    mov x18,SCREEN_WIDTH
    bl rectangulo
    ldur lr,[sp,0] //recupero la dirección de llamada
    add sp,sp,8
    br lr //salto a la dirección de partida.

//procedimiento encargado de dibujar el asfalto
asfalto:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0xC0, lsl 16 //color gris parte 1
    movk x10, 0xC0C0, lsl 00 //color gris parte 2 
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de plasmar las lineas rojas del borde del asfalto
lineasRojas:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,125 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    mov x17,515 //PX
    mov x18,520 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar lineas separadas en el borde del asfalto
puntBlanco:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0xE5, lsl 16 //color blanco parte 1
    movk x10, 0xE4E4, lsl 00 //color blanco parte 2 
    mov x17,120 //PX
    mov x18,125 //FX
    mov x15,0 //PY
    mov x16,15 //FY
    mov x23,10 //sep del punteado
    mov x24,500 //tam de largo de todo
    bl repRectanguloY
    mov x17,515 //PX
    mov x18,520 //FX
    bl repRectanguloY
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de plasmar las lineas que separan las carreteras
separador:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
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
    bl repRectanguloY
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de plasmar un pinar
pinar:
    mov x15,80 //Y -> PY
    sub sp,sp,16
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la dirección de llamado
    pinoIzq:
        mov x17,60 //X -> PX
        bl pino
        add x15,x15,160
        cmp x15,SCREEN_HEIGH
        b.lt pinoIzq
    ldur x15,[sp,8] //restauro el valor inicial de PY
    pinoDer:
        mov x17,580 //X -> PX
        bl pino
        add x15,x15,160
        cmp x15,SCREEN_HEIGH
        b.lt pinoDer
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,16
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar un rectangulo
rectangulo://x15=PY;x16=FY;x17=PX;x18=FX;w10=color
    sub sp,sp,40
    stur x18,[sp,32] //Almaceno el valor inicial de FX
    stur x16,[sp,24] //almaceno el valor inicial de FY
    stur lr,[sp,16] //almaceno la direccion de llamada
    stur x17,[sp,8] //almaceno el valor inicial de PX
    stur x15,[sp,0] //almaceno el valor inicial de PY
    loop1:
        ldur x17,[sp,8] //reseteo el valor inicial de PX
    loop0:
        bl pintar_pixel
        add x17,x17,1 //X++
        subs xzr,x17,x18 //PX <= FX
        b.le loop0
        add x15,x15,1 //Y++
        subs xzr,x15,x16 //Y < FY 
        b.lt loop1
    ldur x18,[sp,32] //restauro el valor inicial de FX
    ldur x16,[sp,24] //restauro el valor inicial de FY
    ldur lr,[sp,16] //restauro la dirección de partida
    ldur x17,[sp,8] //restauro el valor inicial de PX
    ldur x15,[sp,0] //restauro el valor inicial de PY
    add sp,sp,40
    br lr //Retorno a la ubicación de la llamada 

//procedimiento encargado de dibujar rectangulos repetidos en Y
repRectanguloY:
    sub sp,sp,24
    stur x15,[sp,16] //almaceno el valor inicial de PY
    stur x16,[sp,8] //almaceno el valor inicial de FY
    stur lr,[sp,0] //almaceno la dirección de llamado
    sub x26,x16,x15 //tam y
    loopRec:
        bl rectangulo
        add x15,x16,x23 //PY += tamDeSeparación
        add x16,x15,x26 //FY 
        subs xzr,x16,x24
        b.lt loopRec
    ldur x15,[sp,16] //Restauro el valor inicial de PY
    ldur x16,[sp,8] //Restauro el valor inicial de FY
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,24
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar un circulo
circulo:
	// Draws a circle given a (x0, y0) center coords (x17, x15) a radius (x4) and a color (x10)
	sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
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
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de pintar un pixel
pintar_pixel:
    sub sp,sp,8
    stur x21,[sp,0]
    mov x21,SCREEN_WIDTH //x21 = 640
    mul x21,x15,x21 //Y*640
    add x21,x17,x21 //X + Y*640
    lsl x21,x21,2 //4 * (X + Y*640)
    add x21,x0,x21 //direIni + 4*(X + Y*640)
    stur w10,[x21] //pinto el pixel
    ldur x21,[sp,0]
    add sp,sp,8
    br lr

//procedimiento encargado de dibujar un triangulo   
triangulo:
    //coordenadas (x,y) son (x17,x15), color x10, alto x16
    sub sp,sp,16
    stur x16,[sp,8]
    stur lr,[sp,0]
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
    ldur x16,[sp,8]
    ldur lr,[sp,0]
    add sp,sp,16
    br lr

//procedimiento encargado de pintar una fila
pintarFila:
    //Pinta una fila horizontal dadas unas (x,y) coords (x17,x15) una longitud (x4) y un color (x10)
    sub sp,sp,24
    stur x4,[sp,16] //almaceno el valor inicial de x4
    stur x17,[sp,8] //almaceno el valor inicial de x17
    stur lr,[sp,0] //almaceno la dirección de llamado
    loopHorizontal:
        bl pintar_pixel //pinto el pixel actual
        add x17,x17,1 //X++
        sub x4,x4,1 //Disminuyo en 1 el valor de la longitud
        cbnz x4,loopHorizontal //0 < longitud
        //b.lt loopHorizontal
    ldur x4,[sp,16] //restauro el valor inicial de x4
    ldur x17,[sp,8] //restauro el valor inicial de x17
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,24
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar un arbol normal (copa circular)
arbol:
    //tronco
    sub sp,sp,24
    stur x17,[sp,16] //almaceno el valor inicial de PX
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0x6F, lsl 16 //color marron parte 1
    movk x10, 0x4908, lsl 00 //color marron parte 2
    sub x17,x17,3 //PX
    add x18,x17,6 //FX
    add x16,x15,60 //FY
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion
    //Hojas
    movz x10,0x15,lsl 16 //color verde oscuro parte 1
    movk x10,0x7705, lsl 00 //color verde oscuro parte 2
    ldur x17,[sp,16] //restauro el valor inicial de PX
    ldur x15,[sp,8] //restauro el valor inicial de PY
    mov x4,30
    bl circulo
    ldur lr,[sp,0] //restauro el valor de la dirección de llamado
    add sp,sp,24
    br lr //regreso a la dire de llamada

//procedimiento encargado de dibujar un pino
pino:
    //tronco
    sub sp,sp,24
    stur x17,[sp,16] //almaceno el valor inicial de PX
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0x6F, lsl 16 //color marron parte 1
    movk x10, 0x4908, lsl 00 //color marron parte 2
    sub x17,x17,3 //PX
    add x18,x17,6 //FX
    add x15,xzr,x15 //PY
    add x16,x15,60 //FY
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion
    //Hojas
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    ldur x17,[sp,16] //restauro el valor inicial de PX
    ldur x15,[sp,8] //restauro el valor inicial de PY
    sub x15,x15,35
    mov x16,40
    bl triangulo
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    ldur x17,[sp,16] //restauro el valor inicial de PX
    ldur x15,[sp,8] //restauro el valor inicial de PY
    sub x15,x15,50
    bl triangulo
    movz x10,0x0F,lsl 16 //color verde oscuro parte 1
    movk x10,0x6C41, lsl 00 //color verde oscuro parte 2
    ldur x17,[sp,16] //restauro el valor inicial de PX
    ldur x15,[sp,8] //restauro el valor inicial de PY
    sub x15,x15,70
    bl triangulo
    ldur lr,[sp,0] //restauro el valor de la dirección de llamado
    add sp,sp,24
    br lr //regreso a la dire de llamada

//procedimiento encargado de plasmar una arbolada de copa circular
arbolada:
    mov x15,50 //Y -> PY
    sub sp,sp,16
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la direccion de llamada
    arbIzq:
        mov x17,60 //X -> PX
        bl arbol
        add x15,x15,110
        cmp x15,SCREEN_HEIGH
        b.lt arbIzq
    ldur x15,[sp,8] //restauro el valor inicial de PY
    arbDer:
        mov x17,580 //X -> PX
        bl arbol
        add x15,x15,110
        cmp x15,SCREEN_HEIGH
        b.lt arbDer
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,16
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar un auto gris
autoGris:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,159 //valor de X
    mov x15,320 //valor de Y
    movz x14,0x69,lsl 16 //Color gris claro base parte 1
    movk x14,0x6969,lsl 00 //color gris claro base parte 2
    movz x9,0x48,lsl 16 //color gris oscuro sombra parte 1
    movk x9,0x4848,lsl 00 //color gris oscuro sombra parte 2
    bl auto
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar un auto azul 
autoAzul:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,290 //valor de X
    mov x15,320 //valor de Y
    movz x14,0xFF,lsl 00 //Color azul base
    movz x9,0x03,lsl 16 //color azul oscuro sombra parte 1
    movk x9,0x039F,lsl 00 //color azul oscuro sombra parte 2
    bl auto
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar una camioneta blanca:
caminetaBlanca:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,159 //X
    mov x15,295 //Y
    movz x14,0xFF,lsl 16 //Color blanco base parte 1
    movk x14,0xFFFF,lsl 00 //Color blanco base parte 2
    movz x9,0xBC,lsl 16 //color gris claro sombra parte 1
    movk x9,0xBCBC,lsl 00 //color gris claro sombra parte 2
    bl camioneta
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar una camioneta morada:
camineta777:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,159 //X
    mov x17,290 //valor de X
    mov x15,300 //valor de Y
    movz x14,0xA2,lsl 16 //Color violeta base parte 1
    movk x14,0x00FF,lsl 00 //Color violeta base parte 2
    movz x9,0x89,lsl 16 //color violeta oscuro sombra parte 1
    movk x9,0x04D7,lsl 00 //color violeta oscuro sombra parte 2
    bl camioneta
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//Procedimiento encargado de plasmar un auto 
auto:
    sub sp,sp,24
    stur x17,[sp,16] //almaceno el valor inicial de PX
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la dirección de llamado

    //ruedas superiores
    movz x10,0x00,lsl 16 //color negro
    add x15,x15,15 //PY
    add x16,x15,22 //FY
    sub x17,x17,5 //PX
    add x18,x17,70 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //ruedas inferiores 
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,68 //PY
    add x16,x15,22 //FY
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //base del auto
    mov x10,x14 //color base
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x16,x15,105 //FY
    ldur x17,[sp,16] //restauro valor inicial de PX
    add x18,x17,60 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //luces amarillas 
    movz x10,0xFF,lsl 16 //color amarillo parte 1
    movk x10,0xF500,lsl 00 //color amarillo parte 2
    ldur x15,[sp,8] //restauro valor inicial de PY
    mov x16,x15 //FY
    sub x15,x15,4 //PY
    ldur x17,[sp,16] //restauro valor inicial de PX
    add x17,x17,4 //PX
    add x18,x17,10 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur x17,[sp,16] //restauro valor inicial de PX
    add x17,x17,46 //PX
    add x18,x17,10 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //luces rojas
    movz x10,0xFF,lsl 16 //color rojo
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,105 //PY
    add x16,x15,4 //FY
    ldur x17,[sp,16] //restauro valor inicial de PX
    add x17,x17,4 //PX
    add x18,x17,12 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,105 //PY
    add x16,x15,4 //FY
    ldur x17,[sp,16] //restauro valor inicial de PX
    add x17,x17,44 //PX
    add x18,x17,12 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //linea blanca de arriba
    movz x10,0xFF,lsl 16 //color blanco parte 1
    movk x10,0xFFFF,lsl 00 //color blanco parte 2
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x16,x15,20 //FY
    ldur x17,[sp,16] //restauro valor inicial de PX
    add x17,x17,26 //PX
    add x18,x17,8 //FX 
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //vidrio delantero
    movz x10,0x00,lsl 16 //color negro
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x17,x17,30 //X
    add x15,x15,35 //Y
    mov x4,17
    bl circulo
    //arreglo de vidrio delantero
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    mov x10,x14 //color base
    add x15,x15,37 //PY
    add x16,x15,15 //FY
    add x18,x17,60 //FX 
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    mov x10,x9 //color sombra
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,40 //PY
    add x16,x15,29 //FY
    add x17,x17,19 //PX
    add x18,x17,22 //FX 
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //linea blanca de baja
    movz x10,0xFF,lsl 16 //color blanco parte 1
    movk x10,0xFFFF,lsl 00 //color blanco parte 2
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,37 //PY
    add x16,x15,68 //FY
    add x17,x17,26 //PX
    add x18,x17,8 //FX 
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //ventana izquierda
    movz x10,0x00,lsl 16 //color negro
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,40 //PY
    add x16,x15,25 //FY
    add x17,x17,10 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,44 //PY
    add x16,x15,25 //FY
    add x17,x17,13 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //ventana derecha
    movz x10,0x00,lsl 16 //color negro
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,40 //PY
    add x16,x15,25 //FY
    add x17,x17,47 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,44 //PY
    add x16,x15,25 //FY
    add x17,x17,44 //PX
    add x18,x17,3 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida

    //ventana trasera
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,72 //PY
    add x16,x15,25 //FY
    add x17,x17,16 //PX
    add x18,x17,28 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,24
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar una camioneta
camioneta:
    sub sp,sp,24
    stur x17,[sp,16] //almaceno el valor inicial de PX
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la dirección de llamado

    //Ruedas de arriba del auto
    movz x10, 0x00, lsl 16 // Color negro 
    add x15,x15,34 // PY (posición Y)
    add x16,x15,29 // FY (fin Y)
    sub x17,x17,11 // PX (posición X)
    add x18,x17,83 // FX (fin X)
    bl rectangulo 
    //Ruedas de abajo del auto
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,101 // PY (posición Y)
    add x16,x15,29 // FY (fin Y)
    add x18,x17,72 // FX (fin X)
    sub x17,x17,11 // PX (posición X)
    bl rectangulo 

    //contornos negros
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,23 //PY  arriba abajo
    add x16,x15,121 //FY
    add x18,x17,67 //FX ancho
    sub x17,x17,6 //PX ancho hacia izq
    bl rectangulo
    //Base del auto
    mov x10,x14 //color base
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,25 //PY  arriba abajo
    add x16,x15,110 //FY
    add x18,x17,66 //FX ancho
    sub x17,x17,4 //PX ancho hacia izq
    bl rectangulo
    
    //capot centro  
    mov x10,x9 //color sombra
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,20 // PY (posición Y)
    add x16,x15,120 // FY (fin Y)
    add x17,x17,11 // PX (posición X)
    add x18,x17,40 // FX (fin X)
    bl rectangulo 
    //detalle blanco capot
    mov x10,x14 //color base
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,20 // PY (posición Y)
    add x16,x15,90// FY (fin Y)
    add x17,x17,20 // PX (posición X)
    add x18,x17,21 // FX (fin X)
    bl rectangulo

    //sobra izq
    mov x10,x14 //color base
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,30 // PY (posición Y)
    add x16,x15,110 // FY (fin Y)
    add x17,x17,51 // PX (posición X)
    add x18,x17,15 // FX (fin X)
    bl rectangulo // Dibujar rueda izquierda

    //parabrisa delantero y parte del baul
    movz x10, 0x00, lsl 16 // Color negro 
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,57 // PY (posición Y)
    add x16,x15,68 // FY (fin Y)
    add x17,x17,12 // PX (posición X)
    add x18,x17,40 // FX (fin X)
    bl rectangulo 
    //parabrisa puertas izq
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,77 // PY (posición Y)
    add x16,x15,17 // FY (fin Y)
    add x17,x17,1 // PX (posición X)
    add x18,x17,7 // FX (fin X)
    bl rectangulo 
    //parabrisa puertas der
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,77 // PY (posición Y)
    add x16,x15,17 // FY (fin Y)
    add x17,x17,56 // PX (posición X)
    add x18,x17,7 // FX (fin X)
    bl rectangulo 

    //BAUL
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,100 // PY (posición Y)
    add x16,x15,30 // FY (fin Y)
    add x17,x17,4 // PX (posición X)
    add x18,x17,57 // FX (fin X)
    bl rectangulo
    //detalles baul
    movz x10, 0x40, lsl 16 // Color gris claro parte 1
    movk x10, 0x4040, lsl 00 // Color gris claro parte 2
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,103 // PY (posición Y)
    add x16,x15,24 // FY (fin Y)
    add x17,x17,9 // PX (posición X)
    add x18,x17,5 // FX (fin X)
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,98 // PY (posición Y)
    add x16,x15,29 // FY (fin Y)
    add x17,x17,19 // PX (posición X)
    add x18,x17,6 // FX (fin X)
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,98 // PY (posición Y)
    add x16,x15,29 // FY (fin Y
    add x17,x17,31 // PX (posición X)
    add x18,x17,6 // FX (fin X)
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,98 // PY (posición Y)
    add x16,x15,29 // FY (fin Y
    add x17,x17,43 // PX (posición X)
    add x18,x17,4 // FX (fin X)
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,103 // PY (posición Y)
    add x16,x15,24 // FY (fin Y)
    add x17,x17,53 // PX (posición X)
    add x18,x17,4 // FX (fin X)
    bl rectangulo

    //PARABRISA DELANTERO
    movz x10, 0x00, lsl 16 // Color negro
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,64 // PY (posición Y)
    add x16,x15,8 // FY (fin Y)
    add x17,x17,6 // PX (posición X)
    add x18,x17,52 // FX (fin X)
    bl rectangulo
    movk x10, 0x2828, lsl 00 // Color gris oscuro
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,52 // PY (posición Y)
    add x16,x15,6 // FY (fin Y
    add x17,x17,16 // PX (posición X)
    add x18,x17,32 // FX (fin X)
    bl rectangulo 

    //techo
    mov x10,x9 //color sombra
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,72 // PY (posición Y)
    add x16,x15,23 // FY (fin Y)
    add x17,x17,11 // PX (posición X)
    add x18,x17,42 // FX (fin X)
    bl rectangulo

    //contorno de luces
    movz x10, 0x00, lsl 16 //color negro sombra
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,20 //PY  arriba abajo
    add x16,x15,10 //FY
    add x18,x17,14 //FX ancho
    sub x17,x17,4 //PX ancho hacia izq
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,20 //PY  arriba abajo
    add x16,x15,10 //FY
    add x17,x17,48//PX ancho hacia izq
    add x18,x17,18 //FX ancho
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,134 //PY  arriba abajo
    add x16,x15,13 //FY
    add x18,x17,14 //FX ancho
    sub x17,x17,6 //PX ancho hacia izq
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,134 //PY  arriba abajo
    add x16,x15,13 //FY
    add x17,x17,47 //PX ancho hacia izq
    add x18,x17,20 //FX ancho
    bl rectangulo
    
    //Luces amarillas
    movz x10, 0xFF, lsl 16 //color amarillo parte 1
    movk x10, 0xF500, lsl 00 //color amarillo parte 2
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,23 //PY  arriba abajo
    add x16,x15,4  //FY
    add x18,x17,11 //FX ancho
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,23 //PY  arriba abajo
    add x16,x15,4  //FY
    add x17,x17,52 //PX ancho hacia izq
    add x18,x17,11 //FX ancho
    bl rectangulo

    //Luces rojas 
    movz x10, 0xFF, lsl 16 //color rojo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,136 //PY arriba abajo
    add x16,x15,5 //FY
    add x18,x17,11 //FX ancho
    sub x17,x17,2 //PX ancho hacia izq
    bl rectangulo
    ldur x17,[sp,16] //restauro valor inicial de PX
    ldur x15,[sp,8] //restauro valor inicial de PY
    add x15,x15,136 //PY arriba abajo
    add x16,x15,5 //FY
    add x17,x17,51 //PX ancho hacia izq
    add x18,x17,13 //FX ancho
    bl rectangulo

    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,24
    br lr //salto a la direccion de partida.

InfLoop:
	b InfLoop
