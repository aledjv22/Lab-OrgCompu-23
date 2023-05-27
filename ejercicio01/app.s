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
    mov x0, x20
    movz x10, 0x49, lsl 16 //color lima parte 1
    movk x10, 0x8602, lsl 00 //color lima parte 2


    mov x2, SCREEN_HEIGH //almaceno el tamaño de Y en x2
loop3:
    mov x1, SCREEN_WIDTH //almaceno el tamaño de X en x1
loop2:
    stur w10,[x0]  // Colorear el pixel N
    add x0,x0,4    // Siguiente pixel
    sub x1,x1,1    // Decrementar contador X
    cbnz x1,loop2  // Si no terminó la fila, salto
    sub x2,x2,1    // Decrementar contador Y
    cbnz x2,loop3  // Si no es la última fila, salto
    add w10, wzr, wzr //reseteo el valor de w10



gris:
    mov x0, x20
    movz x10, 0xC0, lsl 16 //color gris parte 1
    movk x10, 0xC0C0, lsl 00 //color gris parte 2

    mov x2, 520 //almaceno el tamaño de X en x2
loop4:
    mov x1, SCREEN_HEIGH //almaceno el tamaño de Y en x1
loop5:
    mov x12, 640 //almaceno 640
    mul x11, x1,x12 //Multiplico Y * 640
    add x11, x11,x2 //Le sumo la X a x11: X + Y*640 
    mov x13, 4 //Almaceno 4
    mul x11, x11, x13 //4 * (X + Y*640 )
    add x11, x0, x11 //Sumo la dirección de inicio
    stur w10,[x11] //Pinto pixel
    sub x1,x1,1
    subs xzr,x1,0
    b.ge loop5
    sub x2,x2,1
    subs xzr,x2,120
    b.ge loop4
    //cbnz x2,loop4

InfLoop:
	b InfLoop
