	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
	//---------------- CODE HERE ------------------------------------

	movz x10, 0xC7, lsl 16
	movk x10, 0x1585, lsl 00

	mov x2, SCREEN_HEIGH         // Y Size
loop1:
	mov x1, SCREEN_WIDTH         // X Size
loop0:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop0  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	and w11, w10, 0b00000010

	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado

	//---------------------------------------------------------------
	// Infinite Loop

	//AQUÍ EMPIEZA MI PRUEBA PARA TOCAR LA TECLA 'W' Y CAMBIAR DE ROSA A VERDE LA PANTALLA
	movz x15, 0x00, lsl 16
	movk x15, 0xFF00, lsl 00
	mov x0, x20 //guardo en x16 la dirección base del framebuffer
leyendo:
	ldr w10, [x9, GPIO_GPLEV0]//leo el estado de los GPIO 0 - 31
	//Al hacer AND revela el estado del bit 2,ie, el estado del GPIO 1
	and w11, w10, 0b00000010
	SUBS wzr, w11, 0b00000010
	B.NE leyendo
	mov x2, SCREEN_HEIGH         // Y Size
loop3:
	mov x1, SCREEN_WIDTH         // X Size
loop2:
	stur w15,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,loop2  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop3  // Si no es la última fila, salto
	//AQUÍ FINALIZA MI PRUEBA, SI SE TOCA 'W' DE NUEVO, 
	//NO SE REGRESA AL COLOR ANTERIOR YA QUE FINALIZO EL PROGRAMA

InfLoop:
	b InfLoop
