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
lima:
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2
    mov x15,0 //PY
    mov x17,0 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,SCREEN_WIDTH //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

gris:
    movz x10, 0xC0, lsl 16 //color gris parte 1
    movk x10, 0xC0C0, lsl 00 //color gris parte 2 
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    bl rectangulo //Salto a la "funcion" rectangulo y almaceno la direccion de partida

//Funcion encargada de dibujar un rectangulo
rectangulo://x15=PY;x16=FY;x17=PX;x18=FX;w10=color;x19=auxX;x21=aux
    mov x19,x17 //almaceno el valor inicial de X
    loop0:
        mov x17,x19 //restauro el valor inicial de X
    loop1:
        mov x21, SCREEN_WIDTH //almaceno 640
        mul x21,x15,x21 //multiplico Y*640
        add x21,x17,x21 //X + Y*640
        lsl x21,x21,2 //4 * (X + Y*640)
        add x21,x0,x21 //direIni + 4*(X + Y*640)
        stur w10,[x21] //pinto el pixel
        add x17,x17,1 //X++
        subs xzr,x17,x18
        b.le loop1
        add x15,x15,1//Y++
        subs xzr,x15,x16
        b.le loop0
        br lr //Retorno a la ubicación de la llamada almacenada en LR (una alternativa es 'ret')

InfLoop:
	b InfLoop
