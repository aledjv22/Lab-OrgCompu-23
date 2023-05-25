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
    
    //Configuraciones generales:
    mov x9, GPIO_BASE //Almaceno la dirección base del GPIO en x9
    str wzr, [x9, GPIO_GPFSEL0] //Setea gpios 0 - 9 como lectura

    //Fondo de color rosa
rosa:
    mov x0, x20
    movz x10, 0xC7, lsl 16 //color rosa parte 1
    movk x10, 0x1585, lsl 00//color rosa parte 2

    mov x2, SCREEN_HEIGH //almaceno el tamaño de Y en x2
loop1:
	mov x1, SCREEN_WIDTH //almaceno el tamaño de X en x1
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto
    add w10, wzr, wzr //reseteo el valor de w10

leoRosa:
    ldr w10, [x9, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    sub w10, w10, 0b10
    cbnz w10, leoRosa //Si la tecla 'w' no fue precionado leo de nuevo

releoRosa:
    ldr w10, [x9, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    //sub w10, w10, 0b10
    cbnz w10, releoRosa //Si la tecla 'w' no fue precionado leo de nuevo
    b verde 

verde: 
    mov x0, x20
    movz x10, 0x00, lsl 16 //color rosa parte 1
    movk x10, 0xFF00, lsl 00//color rosa parte 2

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

leoVerde:
    ldr w10, [x9, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    sub w10, w10, 0b10
    cbnz w10, leoVerde //Si la tecla 'w' no fue precionado leo de nuevo

releoVerde:
    ldr w10, [x9, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000000010 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    cbnz w10, releoVerde //Si la tecla 'w' no fue precionado leo de nuevo
    b rosa 

InfLoop:
	b InfLoop
