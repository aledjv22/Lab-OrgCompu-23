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
    mov x2,0xA //Estado inicial del estado de los vehículos.
    mov x6,0xF //valor inicial del estado de las lineas de ruta
    mov x3,500 //Y de vehículos
    mov x5,-300 //Y arboles
//Inicio del paisaje de Arbolecitos
resetX7: //reseteo del registro x7 encargado del valor Y del auto azul para simular un retorno de posición
    mov x7,500
    subs xzr,x5,-10
    b.gt resetX5
    subs xzr,x3,-150
    b.lt resetX3
    b arbolecitos
resetX3: //reseteo del registro x3 encargado del valor Y de las camionetas para simular un retorno de posición
    mov x3,600 //y de camioneta
    b arbolecitos
resetX5:  //reseteo del registro x5 encargado del valor Y de los arboles, lineas que separan la ruta y bordes de la misma, simulando su infinidad
    mov x5,-300
arbolecitos:
        bl asfalto //llamado al procedimiento asfalto guardando su dirección
        subs xzr,x6,0xF7
        b.eq amariA //se consulta el valor del registro x6 para saber si se plasma las lineas amarillas o blancas en la ruta
        bl separador //llamado al procedimiento  encargado de plasmar las lineas blancas separadoras de la ruta
        b sigueA
    amariA:
        bl lineasAmarillas //Proc ejecutado dependiendo del estado de x6
    sigueA: //etiqueta a la que se recurre si no se ejecuta el proc lineasAmarillas
        sub x7,x7,3 //modificacion del x7 para simular el desplazamiento de autoAzul en el siguiente pasar
        bl autoAzul
        sub x3,x3,5
        subs xzr,x2,0xA //Inicia la consulta por el estado del x2 para saber si se recurrira al plasmado de 2,1 o 0 camionetas
        b.eq autosA
        subs xzr,x2,0xB
        b.eq autosB
        subs xzr,x2,0xC
        b.eq autosC
    autosC: //encargado de modificar los registros x5 y x3 de desplazamientos, pero sin plasmar las camionetas
        add x5,x5,3
        sub x3,x3,120
        add x3,x3,120
        b sigueD
    autosB: //modifica x5 y x3 y dibuja la camionetaBlanca
        bl caminetaBlanca
        add x5,x5,3
        sub x3,x3,120
        add x3,x3,120
        b sigueD
    autosA: //modifica x5 y x3, plasmando camionetaBlanca y camioneta777(violeta)
        bl caminetaBlanca
        add x5,x5,3
        sub x3,x3,120
        bl camineta777
        add x3,x3,120
    sigueD: //etiqueta de salto por si se hizo el salto a la etiqueta autosC o autosB
        bl lineasRojas //llamado al proc que pinta el borde rojo del asfalto
        bl puntBlanco //llama al proc que superpone un punteado blanco en las lineas rojas del borde del asfalto
        movz x10, 0x49, lsl 16 //color lima parte 1
        movk x10, 0x8602, lsl 00 //color lima parte 2
        bl suelo //Plasmo el suelo con el color anterior
        add x5,x5,7
        bl arbolada
        bl tiempo //realizo un "delay"
        bl lectura //inicia la lectura de GPIOs y por ende las teclas
        bl lecEspacio
        bl lecD
        bl lecA
        bl lecWArbol
        bl lecSArbol
        subs xzr,x5,-10 //analizo los valores de los registros para resetarlos
        b.gt resetX5
        subs xzr,x3,-150
        b.lt resetX3
        subs xzr,x7,-150
        b.lt resetX7
        b arbolecitos //realizo un salto para simular el bucle infinito de este paisaje

//Inicio del paisaje pinitos
resetX7B:                       //reseteo de registros
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
pinitos: //plasmado del paisaje de tematica pinos
        bl asfalto
        subs xzr,x6,0xF7
        b.eq amariP
        bl separador
        b sigueP
    amariP:   //dibuja lineasAmarillas de cumplirse el estado nesario del reg x6
        bl lineasAmarillas
    sigueP:
        sub x7,x7,3
        bl autoAzul
        sub x3,x3,5
        subs xzr,x2,0xA  //Analisis del estado de x2 para determinar el nro de camionetas a dibujar
        b.eq autosAp 
        subs xzr,x2,0xB
        b.eq autosBp
        subs xzr,x2,0xC
        b.eq autosCp
    autosCp:
        add x5,x5,3
        sub x3,x3,120
        add x3,x3,120
        b sigueDp
    autosBp:
        bl caminetaBlanca
        add x5,x5,3
        sub x3,x3,120
        add x3,x3,120
        b sigueDp
    autosAp:
        bl caminetaBlanca
        add x5,x5,3
        sub x3,x3,120
        bl camineta777
        add x3,x3,120
    sigueDp:
        bl lineasRojas
        bl puntBlanco
        movz x10, 0x49, lsl 16 //color lima parte 1
        movk x10, 0x8602, lsl 00 //color lima parte 2
        bl suelo
        add x5,x5,7
        bl pinar
        bl tiempo
        bl lectura //lectura de las GPIOs y por ende teclas
        bl lecEspacio
        bl lecD
        bl lecA
        bl lecWPino
        bl lecSPino
        subs xzr,x5,-10 //comprobación de valores de reg para determinar el reseteo de estos
        b.gt resetX5B
        subs xzr,x3,-150
        b.lt resetX3B
        subs xzr,x7,-150
        b.lt resetX7B
        b pinitos //realizo un salto para simular el bucle infinito de este paisaje

//Inicio del paisaje cactitus
resetX7C:       //reseteo de registros
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
cactitus: //plasmado del paisaje de tematica desierto
        bl asfalto
        subs xzr,x6,0xF7
        b.eq amariC
        bl separador
        b sigueC
    amariC: //dibuja lineasAmarillas de cumplirse el estado nesario del reg x6
        bl lineasAmarillas
    sigueC:
        sub x7,x7,3
        bl autoAzul
        sub x3,x3,5
        subs xzr,x2,0xA //Analisis del estado de x2 para determinar el nro de camionetas a dibujar
        b.eq autosAc 
        subs xzr,x2,0xB
        b.eq autosBc
        subs xzr,x2,0xC
        b.eq autosCc
    autosCc:
        add x5,x5,3
        sub x3,x3,120
        add x3,x3,120
        b sigueD_c
    autosBc:
        bl caminetaBlanca
        add x5,x5,3
        sub x3,x3,120
        add x3,x3,120
        b sigueD_c
    autosAc:
        bl caminetaBlanca
        add x5,x5,3
        sub x3,x3,120
        bl camineta777
        add x3,x3,120
    sigueD_c:
        bl lineasRojas
        bl puntBlanco
        movz x10, 0xFF, lsl 16 //color amarillo parte 1
        movk x10, 0xD500, lsl 00 //color amarillo parte 2
        bl suelo
        add x5,x5,7
        bl cactada
        bl tiempo
        bl lectura //lectura de las GPIOs y por ende teclas
        bl lecEspacio
        bl lecD
        bl lecA
        bl lecWCactus
        bl lecSCactus
        subs xzr,x5,-10 //comprobación de valores de reg para determinar el reseteo de estos
        b.gt resetX5C
        subs xzr,x3,-150
        b.lt resetX3C
        subs xzr,x7,-150
        b.lt resetX7C
        b cactitus //realizo un salto para simular el bucle infinito de este paisaje

//procedimiento encargado de dibujar el paisajeFinal del programa
paisajeFinal:
    mov x7,500 //Y del auto
    mov x6,217 //X del auto
    mov x5,-800 //Y de separadorB
    mov x3,0xD //bomba desactivada
    final: //plasmado del paisaje de tematica asesina
        bl caminoB
        bl separadorB
        subs xzr,x3,0xD
        b.eq sigueF0
        b fin
    sigueF0:
        bl autoGris
        add x5,x5,7
        add x13,x7,100
        sub x12,x6,100
        bl avioneta
        bl tiempo
        subs xzr,x5,-10
        b.lt sigueF1
        mov x5,-500
    sigueF1:
        subs xzr,x7,380
        b.lt sigueF3
        sub x7,x7,3
        b final
    sigueF2:
        sub x7,x7,3
        subs xzr,x6,360
        b.gt final
        add x6,x6,3
        b final
    sigueF3:
        subs xzr,x7,180
        b.gt sigueF2
        mov x3,0xA //bomba activada tras tirar el misil la avioneta
        b final
    fin: //eliminacion del autoGris y la bomba/explosion y misil derecho de avioneta
        bl autoGris
        bl bomba
        add x13,x7,100
        sub x12,x6,100
        bl avioneta
        bl tiempo
        bl tiempo
        bl tiempo
        bl tiempo
        bl tiempo
        mov x5,-900 //Y de separadorB
    resetAvionetita:  //desplazamiento de la avioneta tras la bomba
        subs xzr,x13,-300
        b.lt regreso
        sub x13,x13,5
        add x5,x5,7
        bl caminoB
        bl separadorB
        sub x12,x6,100
        bl avioneta
        bl tiempo
        b resetAvionetita
    regreso: //lectura de teclas W y S para regresar a los paisajes antiguos
             //No se implementan la A y D por no influir en esta secuencia como tal
        bl lectura
        bl lecWArbol
        bl lecSArbol
        b regreso

//Fin loop, al cual "nunca" se llega debido a que nunca se llega a ella.
    b InfLoop

//"Delay": simula un delay mediante el decrecimiento del reg x10
tiempo:
    movz x10,0x0773,lsl 16 //tiempo de delay parte 1
    movk x10,0x5940,lsl 00 //tiempo de delay parte 2
    delay_loop:
        sub x10, x10, #4
        cbnz x10,delay_loop
    br lr

//Lectura de las GPIOs
lectura:
    //Configuraciones generales del GPIO
    mov x10, GPIO_BASE //Almaceno la dirección base del GPIO en x10
    str wzr, [x10, GPIO_GPFSEL0] //Setea gpios 0 - 9 como lectura
    ldr w10, [x10, GPIO_GPLEV0] //leo los estados de los GPIO 0 - 31
    and w10, w10, 0b0000111110 //Hago un and para revelar el bit 2, ie, el estado de GPIO 1
    br lr
lecWArbol: 
    subs wzr, w10, 0b00010 //verifico si el GPIO1 es de estado alto
    b.eq pinitos //permite el salto al paisaje pinitos sin perder informacion de los vehículos y lineas en el asfalto
    br lr
lecWPino:
    subs wzr, w10, 0b00010
    b.eq cactitus //permite el salto al paisaje cactitus sin perder informacion de los vehículos y lineas en el asfalto
    br lr
lecWCactus:
    subs wzr, w10, 0b00010
    b.eq arbolecitos //permite el salto al paisaje arbolecitos sin perder informacion de los vehículos y lineas en el asfalto
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

lecA: //De ser estado ALTO permite cambiar las lineas que separan la ruta mediante el cambio del valor de x6
    subs wzr, w10, 0b00100
    b.eq est
    br lr
    est:
        subs xzr,x6,0xF7
        b.eq sigue
        mov x6,0xF7
        br lr
    sigue:
        mov x6,0xF
        br lr

lecD: //De ser estado ALTO consigue cambiar el valor de x2  y así el numero de camionetas
    subs wzr, w10, 0b10000
    b.eq estD
    br lr
    estD:
        subs xzr,x2,0xA
        b.eq sigueDb
        subs xzr,x2,0xB
        b.eq sigueDc
        subs xzr,x2,0xC
        b.eq sigueDa
        sigueDc:
            mov x2,0xC
            br lr
        sigueDb:
            mov x2,0xB
            br lr
        sigueDa:
            mov x2,0xA
            br lr

lecEspacio: //De ser estado ALTO ejecuta una cinematica antes de habilitar nuevamente la lectura de W y S.
    subs wzr, w10, 0b100000
    b.eq paisajeFinal
    br lr

//procedimiento encargado de plasmar una avioneta
avioneta:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamada
    // x13 = Y, x12 = X

    //boomb derecha
    subs xzr,x3,0xA
    b.eq bomIzq
    movz x10, 0x64, lsl 16 //color gris parte 1
    movk x10, 0x5454, lsl 00 //color gris parte 2
    add x17,x12,114 ///x
    add x15,x13,20 //y
    mov x4,12
    bl circulo
    add x15,x13,26//PY arriba abajo
    add x16,x15,75//FY
    sub x17,x12,-106//PX ancho hacia izq
    add x18,x12,123 //FX ancho
    bl rectangulo  
    add x17,x12,114
    sub x15,x13,5//y 
    mov x16,12
    bl triangulo
    //boomb izq
    bomIzq:
        movz x10, 0x64, lsl 16 //color gris parte 1
        movk x10, 0x5454, lsl 00 //color gris parte 2
        add x17,x12,28 //x
        add x15,x13,20 //y
        mov x4,12
        bl circulo
        add x15,x13,26//PY arriba abajo
        add x16,x15,75//FY
        sub x17,x12,-20 //PX ancho hacia izq
        add x18,x12,36 //FX ancho
        bl rectangulo 
        add x17,x12,28
        sub x15,x13,5//y 
        mov x16,12
        bl triangulo
        //finbombs
    
    //aletabaja
    movz x10, 0x80, lsl 16 //color rojo
    add x15,x13,38 //PY arriba abajo
    add x16,x15,40 //FY
    sub x17,x12,-1 //PX ancho hacia izq
    add x18,x12,140 //FX ancho
    bl rectangulo
    movz x10, 0xA0, lsl 16 //color rojo
    add x15,x13,38 //PY arriba abajo
    add x16,x15,35 //FY
    sub x17,x12,-1 //PX ancho hacia izq
    add x18,x12,140 //FX ancho
    bl rectangulo
    //uniones negras de aletas
    movz x10,00, lsl 16 //color negro
    add x15,x13,55//PY arriba abajo
    add x16,x15,25//FY
    sub x17,x12,-30 //PX ancho hacia izq
    add x18,x12,35 //FX ancho
    bl rectangulo
    movz x10,00, lsl 16 //color negro
    add x15,x13,55//PY arriba abajo
    add x16,x15,25//FY
    sub x17,x12,-108 //PX ancho hacia izq
    add x18,x12,113 //FX ancho
    bl rectangulo

    //helise
    movz x10, 0x70, lsl 16 //color gris parte 1
    movk x10, 0x7070, lsl 0 //color gris parte 2
    add x15,x13,-5 //PY arriba abajo
    add x16,x15,2//FY
    sub x17,x12,-55 //PX ancho hacia izq
    add x18,x12,88 //FX ancho
    bl rectangulo
    //tronk
    movz x10,0x8A,lsl 16 //color rojo sangre
    add x17,x12,70
    sub x15,x27,36
    mov x16,12
    bl triangulo
    movz x10, 0x70, lsl 16 //color rojo oscuro
    add x15,x13,20 //PY arriba abajo
    add x16,x15,105//FY
    sub x17,x12,-55 //PX ancho hacia izq
    add x18,x12,85 //FX ancho
    bl rectangulo
    movz x10, 0xAA, lsl 16 //color rojo
    add x15,x13,10 //PY arriba abajo
    add x16,x15,145//FY
    sub x17,x12,-60 //PX ancho hacia izq
    add x18,x12,80 //FX ancho
    bl rectangulo

    movz x10, 0x70, lsl 16 //color oscuro rojo
    add x15,x13,155 //PY arriba abajo
    add x16,x15,20//FY
    sub x17,x12,-67 //PX ancho hacia izq
    add x18,x12,72 //FX ancho
    bl rectangulo
 
    //cola
    movz x10, 0x70, lsl 16 //color rojo
    add x17,x12,85 ///x
    add x15,x13,155 //y
    mov x4,12
    bl circulo
    add x17,x12,55 ///x
    add x15,x13,155 //y
    mov x4,12
    bl circulo


    movz x10, 0x70, lsl 16 //color rojo
    add x15,x13,150 //PY arriba abajo
    add x16,x15,12//FY
    sub x17,x12,-49 //PX ancho hacia izq
    add x18,x12,91 //FX ancho

    bl rectangulo
    movz x10, 0xAA, lsl 16 //color rojo

    
    add x15,x13,148 //PY arriba abajo
    add x16,x15,10//FY
    sub x17,x12,-49 //PX ancho hacia izq
    add x18,x12,91 //FX ancho
    bl rectangulo
    //centro tronk
    movz x10, 0xE9, lsl 16 //color rojo
    add x15,x13,23 //PY arriba abajo
    add x16,x15,135//FY
    sub x17,x12,-63 //PX ancho hacia izq
    add x18,x12,78 //FX ancho
    bl rectangulo
    // --------
    add x17,x12,85 ///x
    add x15,x13,155 //y
    mov x4,8
    bl circulo
    add x17,x12,55 ///x
    add x15,x13,155 //y
    mov x4, 8
    bl circulo
    //aleta sup
    movz x10, 0x80, lsl 16 //color rojo
    add x15,x13,23 //PY arriba abajo
    add x16,x15,36 //FY
    sub x17,x12,2 //PX ancho hacia izq
    add x18,x12,143 //FX ancho
    bl rectangulo
    
    movz x10, 0xD0, lsl 16 //color rojo
    add x15,x13,25 //PY arriba abajo
    add x16,x15,29 //FY
    sub x17,x12,0 //PX ancho hacia izq
    add x18,x12,141 //FX ancho
    bl rectangulo
    //detalle aleta sup
    movz x10, 0xF0, lsl 16 //color rojo
    add x15,x13,30 //PY arriba abajo
    add x16,x15,14 //FY
    sub x17,x12,0 //PX ancho hacia izq
    add x18,x12,141 //FX ancho
    bl rectangulo
    ldur lr,[sp,0] //recupero la dirección de llamada
    add sp,sp,8
    br lr //salto a la dirección de partida.

//procedimiento encargado de plasmar una bomba en la ruta
bomba:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0xD7, lsl 16 //color rojo parte 1
    movk x10, 0x0505, lsl 00 //color rojo parte 2 
    mov x17,370 //determino la X para plasmar mi circulo
    mov x15,243 //determino la Y para plasmar mi circulo
    mov x4,30 //determino el radio del circulo necesario
    bl circulo //hago llamado del proc circulo
    movz x10, 0xFF, lsl 16 //color naranja parte 1
    movk x10, 0x0505, lsl 00 //color naranja parte 2
    mov x4,25
    bl circulo
    movz x10, 0xF7, lsl 16 //color amarillo parte 1
    movk x10, 0xFF00, lsl 00 //color amarillo parte 2
    mov x4,20
    bl circulo
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.
    
//procedimiento encargado de dibujar la calle de barro
caminoB: //Es el fondo personalizado para el paisajeFinal
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    movz x10, 0x79, lsl 16 //color barro parte 1
    movk x10, 0x5E1F, lsl 00 //color barro parte 2 
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x17,170 //PX
    mov x18,470 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    movz x10, 0x4C, lsl 16 //color pasto parte 1
    movk x10, 0x755A, lsl 00 //color pasto parte 2
    //mov x15,0 //PY
    //mov x16,SCREEN_HEIGH //FY
    mov x17,0 //PX
    mov x18,170 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    //mov x15,0 //PY
    //mov x16,SCREEN_HEIGH //FY
    mov x17,470 //PX
    mov x18,SCREEN_WIDTH //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar el suelo 
suelo:
    mov x1,lr //Almaceno la direccion de llamada
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x17,0 //PX
    mov x18,120 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    mov x15,0 //PY
    mov x16,SCREEN_HEIGH //FY
    mov x17,520 //PX
    mov x18,SCREEN_WIDTH //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    br x1 //Retorno a la direccion de llamada

//procedimiento encargado de dibujar el asfalto
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
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    br x1

//procedimiento encargado de plasmar las lineas rojas del borde del asfalto
lineasRojas:
    mov x1,lr
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,120 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,125 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    movz x10, 0xFF, lsl 16 //color rojo
    mov x15,0 //PY
    mov x17,515 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,520 //FX
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    br x1

//procedimiento encargado de dibujar lineas amarillas
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
    bl rectangulo //Salto a la "procedimiento" rectangulo y almaceno la direccion de partida
    mov x15,0 //PY
    mov x17,387 //PX
    mov x16,SCREEN_HEIGH //FY
    mov x18,390 //FX
    bl rectangulo 
    br x1
//procedimiento encargado de dibujar lineas separadas en el borde del asfalto
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

//procedimiento encargado de plasmar las lineas que separan las carreteras
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

//procedimiento encargado de plasmar lineas separadas en camino de tierra
separadorB:
    mov x1,lr
    movz x10, 0xE8, lsl 16 //color blanco amarronado parte 1
    movk x10, 0xC9A6, lsl 00 //color blanco amarronado parte 2 
    mov x17,318 //PX
    mov x18,322 //FX
    mov x15,x5 //PY
    add x16,x15,45 //FY
    mov x23,15 //sep del punteado
    mov x24,700 //tam de largo de todo
    bl repRectanguloY
    br x1

//procedimiento encargado de plasmar un pinar
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
	// Draws a circle given a (x0, y0) center coords (x17, x15) a radius (x4) and a color (x10).
	sub sp,sp,24
    stur x17,[sp,16]
    stur x15,[sp,8]
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
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,24
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
    mov x15,x5 //Y -> PY
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

//procedimiento encargado de dibujar un auto azul 
autoAzul:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,290 //valor de X
    mov x15,x7 //valor de Y
    movz x14,0xFF,lsl 00 //Color base azul
    movz x9,0x03,lsl 16 //color azul oscuro sombra parte 1
    movk x9,0x039F,lsl 00 //color azul oscuro sombra parte 2
    bl auto
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar un auto gris
autoGris:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,x6 //valor de X
    mov x15,x7 //valor de Y
    movz x14,0x69,lsl 16 //Color gris base parte 1
    movk x14,0x6969,lsl 00 //color gris base parte 2
    movz x9,0x48,lsl 16 //color gris oscuro sombra parte 1
    movk x9,0x4848,lsl 00 //color gris oscuro sombra parte 2
    bl auto
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,8
    br lr //salto a la direccion de partida.

//procedimiento encargado de dibujar una camioneta blanca:
caminetaBlanca:
    sub sp,sp,8
    stur lr,[sp,0] //almaceno la dirección de llamado
    mov x17,159 //X
    mov x15,x3 //Y
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
    mov x17,425 //valor de X
    mov x15,x3 //valor de Y
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

//arbolada de cactus
cactada:
    mov x15,x5 //Y -> PY
    sub sp,sp,16
    stur x15,[sp,8] //almaceno el valor inicial de PY
    stur lr,[sp,0] //almaceno la direccion de llamada
    cacIzq:
        mov x17,60 //X -> PX
        bl cactus
        add x15,x15,110
        cmp x15,SCREEN_HEIGH
        b.lt cacIzq
    ldur x15,[sp,8] //restauro el valor inicial de PY
    cacDer:
        mov x17,580 //X -> PX
        bl cactus
        add x15,x15,110
        cmp x15,SCREEN_HEIGH
        b.lt cacDer
    ldur lr,[sp,0] //recupero la direccion de partida
    add sp,sp,16
    br lr //salto a la direccion de partida.

//procedimiento encargado de plasmar un cactus
cactus:
    sub sp,sp,24
    stur x17,[sp,16]
    stur x15,[sp,8]
    stur lr,[sp,0]
    //mov x8,x15 //inicial y
    //mov x28,x17 //inicial x


    movz x10, 0x00, lsl 16 //color verde parte 1
    movk x10, 0x4900, lsl 00 //color verde parte 2
    //tronquitos
    add x18,x17,8 //FX
    sub x17,x17,2 //PX
    add x16,x15,60 //FY
    add x15,x15,0 //PY
    bl rectangulo 
    //leg izq
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    add x18,x17,5 //FX
    sub x17,x17,20 //PX
    add x16,x15,45 //FY
    add x15,x15,35 //PY
    bl rectangulo 
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    add x18,x17,-8 //FX
    sub x17,x17,20 //PX
    add x16,x15,40 //FY
    add x15,x15,12 //PY
    bl rectangulo

    //leg rgt
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    add x18,x17,20 //FX
    sub x17,x17,0 //PX
    add x16,x15,38 //FY
    add x15,x15,28 //PY
    bl rectangulo 
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    add x18,x17,26//FX
    sub x17,x17,-16//PX
    add x16,x15,38 //FY
    add x15,x15,12 //PY
    bl rectangulo
    
    //crc medio
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    movz x10,0x00,lsl 16 //color verde oscuro parte 1
    movk x10,0x4900, lsl 00 //color verde oscuro parte 2
    add x15,x15,3
    add x17,x17,3
    mov x4,6
    bl circulo 
    //crc der
    movz x10,0xFF,lsl 16 //color naranja parte 1
    movk x10,0x4900, lsl 00 //color naranja parte 2
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    add x15,x15,14
    add x17,x17,21
    mov x4,6
    bl circulo
    // crc izq
    ldur x17,[sp,16]
    ldur x15,[sp,8]
    movz x10,0xFF,lsl 16 //color naranja claro parte 1
    movk x10,0x7F50, lsl 00 //color naranja claro parte 2
    add x15,x15,10  // Y
    add x17,x17,-14 // X
    mov x4,6
    bl circulo
    ldur lr,[sp,0]
    add sp,sp,24
    br lr

InfLoop:
	b InfLoop
