	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32
    .equ CORD_Y,         240
    .equ CORD_X,         320

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

main:
    //x0 contiene la dirección base del framebuffer
    mov x20, x0 //Guarda la dirección base del framebuffer en x20
    //---------------- CODE HERE ------------------------------------
fondo:
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2
    mov x15,0 //PY
    mov x17,0 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,SCREEN_WIDTH //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

asfalto:
    movz x10, 0xC0, lsl 16 //color gris parte 1
    movk x10, 0xC0C0, lsl 00 //color gris parte 2 
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

lineasRojas:
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,125 //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,515 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    mov x22,SCREEN_HEIGH //tam de largo de lineas
    mov x23,0 //sep del punteado
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

puntBlanco:
    movz x10, 0xFF, lsl 16 //color blanco parte 1
    movk x10, 0xFFFF, lsl 00 //color blanco parte 2 
    mov x17,120 //PX
    mov x18,125 //FX
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x22,15 //tam de largo de lineas
    mov x23,10 //sep del punteado
    bl rectangulo
    mov x17,515 //PX
    mov x18,520 //FX
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x22,15 //tam de largo de lineas
    mov x23,10 //sep del punteado
    bl rectangulo

separador:
    movz x10, 0xFF, lsl 16 //color blanco parte 1
    movk x10, 0xFFFF, lsl 00 //color blanco parte 2 
    mov x17,253 //PX
    mov x18,256 //FX
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x22,30 //tam de largo de lineas
    mov x23,10 //sep del punteado
    bl rectangulo
    mov x17,384 //PX
    mov x18,387 //FX
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x22,30 //tam de largo de lineas
    mov x23,10 //sep del punteado
    bl rectangulo


    b InfLoop

//Funcion encargada de dibujar una linea punteada
rectangulo://x15=PY;x16=FY;x17=PX;x18=FX;w10=color;x19=auxX;x21=aux
        //x22=tam de lineas;x23=sep del punteado,x24=auxT
    mov x24,0 //inicializo en 0 el aux de tam
    mov x19,x17 //almaceno el valor inicial de X
    loop3:
        mov x17,x19 //restauro el valor inicial de X
    loop2:
        mov x21, SCREEN_WIDTH //almaceno 640
        mul x21,x15,x21 //multiplico Y*640
        add x21,x17,x21 //X + Y*640
        lsl x21,x21,2 //4 * (X + Y*640)
        add x21,x0,x21 //direIni + 4*(X + Y*640)
        stur w10,[x21] //pinto el pixel
        add x17,x17,1 //X++
        subs xzr,x17,x18 //PX <= FX
        b.le loop2
        add x15,x15,1 //Y++
        add x24,x24,1 //auxT++
        subs xzr,x24,x22 //auxT <= tamLine
        b.le loop3
        add x15,x15,x23 //Y += sep del punteado
        mov x24,0 //reinicio el valor del aux de tam
        subs xzr,x15,x16 //Y < FY 
        b.lt loop3
        br lr //Retorno a la ubicación de la llamada almacenada en LR (una alternativa es 'ret')

InfLoop:
	b InfLoop
