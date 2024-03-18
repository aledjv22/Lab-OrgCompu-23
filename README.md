# Laboratorio de  Organización del Computador - Edición 2023

* Configuración de pantalla: `640x480` pixels, formato `ARGB` 32 bits.
* El registro `X0` contiene la dirección base del FrameBuffer (Pixel 1).
* El código de cada consigna debe ser escrito en el archivo _app.s_.
* El archivo _start.s_ contiene la inicialización del FrameBuffer **(NO EDITAR)**, al finalizar llama a _app.s_.
* El código de ejemplo pinta toda la pantalla un solo color.

## Estructura

* **[app.s](app.s)** Este archivo contiene a apliación. Todo el hardware ya está inicializado anteriormente.
* **[start.s](start.s)** Este archivo realiza la inicialización del hardware.
* **[Makefile](Makefile)** Archivo que describe como construir el software _(que ensamblador utilizar, que salida generar, etc)_.
* **[memmap](memmap)** Este archivo contiene la descripción de la distribución de la memoria del programa y donde colocar cada sección.

* **README.md** este archivo.

## Uso

El archivo _Makefile_ contiene lo necesario para construir el proyecto.
Se pueden utilizar otros archivos **.s** si les resulta práctico para emprolijar el código y el Makefile los ensamblará.

### **Para correr el proyecto ejecutar**
Debe ubicarse en el directorio [ejercicio01](./ejercicio01/) o en el directorio [ejercicio02](./ejercicio02/), ya que dependiendo del ejercicio que quiera correr obtendrá un resultado distinto.

```bash
$ make runQEMU
```
Esto construirá el código y ejecutará qemu para su emulación.

Si qemu se queja con un error parecido a `qemu-system-aarch64: unsupported machine type`, prueben cambiar `raspi3` por `raspi3b` en la receta `runQEMU` del **Makefile** (línea 23 si no lo cambiaron).

### **Para correr el gpio manager**

```bash
$ make runGPIOM
```

Ejecutar **en otra terminal luego** de haber corrido qemu.

### **Ejercicio 1:**
El código genera la imagen de una carretera con arboles de copa circular, un auto azul y una camioneta blanca. 
De pulsar la **tecla W** los arboles pasan a ser pinos, los vehiculos cambian de lugar y color. 
De **pulsar W** se regresa a la imagen inicial.

### **Ejercicio 2:**
La animacion muestra 3 paisajes distintos de rutas diferenciadas por los tipos de arboles y suelo, se pueden cambiar con las **teclas W y S** ya que son un ciclo bidireccional.
La **tecla A** cambia las lineas punteadas del asfalto por lineas amarillas.
**Tecla D** elimina y aparece uno a uno las camionetas mediante un ciclo repetitivo.
El **'espacio'** genera una secuencia de persecución entre un auto y una avioneta terminando el vehiculo eliminado por un misil. **Tras detenerse** la línea de ruta se habilita el uso de la W y S.

### **Imagenes de ejecución:**
![Ej01A](https://i.ibb.co/Y82JSWB/Captura-desde-2024-03-18-01-17-56.png "Ej01A")

![Ej01B](https://i.ibb.co/Y8tTQ8j/Captura-desde-2024-03-18-01-21-16.png "Ej01B")

![Ej02A](https://i.ibb.co/3fRc9nR/Captura-desde-2024-03-18-01-24-36.png "Ej02A")

![Ej02B](https://i.ibb.co/HrwmgQx/Captura-desde-2024-03-18-01-25-39.png "Ej02B")

![Ej02C](https://i.ibb.co/ssWbfDK/Captura-desde-2024-03-18-01-26-26.png "Ej02C")

![Ej02D](https://i.ibb.co/zXQ43Jx/Captura-desde-2024-03-18-01-27-12.png "Ej02D")

![Ej02E](https://i.ibb.co/WnKzHnH/Captura-desde-2024-03-18-01-28-14.png "Ej02E")

![Ej02F](https://i.ibb.co/X2mRF2r/Captura-desde-2024-03-18-01-29-03.png "Ej02F")

![Ej02G](https://i.ibb.co/CzzRp2M/Captura-desde-2024-03-18-01-29-06.png "Ej02G")

## Como correr qemu y gcc usando Docker containers

Los containers son maquinas virtuales livianas que permiten correr procesos individuales como el qemu y gcc.

Para seguir esta guia primero tienen que instala docker y asegurarse que el usuario que vayan a usar tenga permiso para correr docker (ie dockergrp) o ser root

### Linux
 * Para construir el container hacer
```bash
docker build -t famaf/rpi-qemu .
```
 * Para arrancarlo
```bash
xhost +
cd rpi-asm-framebuffer
docker run -dt --name rpi-qemu --rm -v $(pwd):/local --privileged -e "DISPLAY=${DISPLAY:-:0.0}" -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME/.Xauthority:/root/.Xauthority:rw" famaf/rpi-qemu
```
 * Para correr el emulador y el simulador de I/O
```bash
docker exec -d rpi-qemu make runQEMU
docker exec -it rpi-qemu make runGPIOM
```
 * Para terminar el container
```bash
docker kill rpi-qemu
```

### MacOS
En MacOS primero tienen que [instalar un X server](https://medium.com/@mreichelt/how-to-show-x11-windows-within-docker-on-mac-50759f4b65cb) (i.e. XQuartz)
 * Para construir el container hacer
```bash
docker build -t famaf/rpi-qemu .
```
 * Para arrancarlo
```bash
xhost +
cd rpi-asm-framebuffer
docker run -dt --name rpi-qemu --rm -v $(pwd):/local --privileged -e "DISPLAY=host.docker.internal:0" -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME/.Xauthority:/root/.Xauthority:rw" famaf/rpi-qemu
```
 * Para correr el emulador y el simulador de I/O
```bash
docker exec -d rpi-qemu make runQEMU
docker exec -it rpi-qemu make runGPIOM
```
 * Para terminar el container
```bash
docker kill rpi-qemu
```
----------------------------------
### Otros comandos utiles
```bash
# Correr el container en modo interactivo
docker run -it --rm -v $(pwd):/local --privileged -e "DISPLAY=${DISPLAY:-:0.0}" -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME/.Xauthority:/root/.Xauthority:rw" famaf/rpi-qemu
# Correr un shell en el container
docker exec -it rpi-qemu /bin/bash
```

## Licencia
Este proyecto es software libre, y está disponible bajo la licencia [MIT](LICENSE).

## Autores
- **[Alejandro Díaz.](https://github.com/aledjv22)**
- **[Lihuel Aravena.](https://github.com/y-36)**
- **[Nahuel Pitt.](https://github.com/Amourak0)**
