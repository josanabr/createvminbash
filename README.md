# Creando una máquina virtual desde CLI

---
> [TAREA](#tarea)
---

En este repositorio se va a crear una máquina virtual desde la línea de comandos usando el comando `VBoxManage`.
Sin embargo, en lugar de correr los comandos uno tras otro, estos pasos se recopilan en un archivo plano, llamado script, para su posterior ejecución.

El script que se usará para la creación de la máquina virtual se encuentra en esta [página web](https://www.andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line/).
El código de este script se encuentra en el archivo [crearvm.sh](crearvm.sh).

---

A continuación de una serie de iteraciones se va a ir mejorando el script presentado en la rama `master` de este proyecto. 
A continuación algunas de las objeciones que tiene el script de la rama `master`:

* El script espera recibir un argumento el cual será el nombre de la máquina virtual a ser creada. Sin embargo, no se hace ninguna validación respecto a detener la ejecución del script en caso que no se pase dicho argumento al momento de invocar la ejecución de dicho script.

* El script al momento de crear la máquina tienes muchos paramétros de la máquina virtual que están *hard coded*. Por ejemplo, el tamaño de la RAM, el tamaño del disco duro, el tipo del sistema operativo, entre otros.

---

## Iteración 01

En esta iteración se modifica el script `crearvm.sh` de modo que detenga su ejecución si el nombre de la máquina virtual no se provee al momento de lanzar la ejecución del script.
[Aquí la nueva versión](crearvm.sh).

Lo que se ha adicionado al código son las siguientes instrucciones:

```
if [ ${#} -ne 1 ]; then
  echo "Uso: ${0} <nombre_vm>"
  exit 1
fi
```

Si el número de argumentos pasados al script (`${#}`) no es `1` entonces se muestra un mensaje por pantalla indicando la forma correcta de invocar el script.

---

Ahora se debe abordar el procesamiento de diferentes parámetros que caracterizan a una máquina virtual, tales como:

* Nombre de la máquina
* Tamaño de disco duro
* Tamaño de memoria RAM

---

## Iteración 02

El script presentado hasta el momento daba ninguna flexibilidad a la hora de fácilmente cambiar algunos parámetros de la máquina virtual.
Si se deseaba cambiar el tamaño del disco duro o si se quería cambiar el tamaño de la memoria RAM entonces se debía editar el script `crearvm.sh` en las líneas que corresponden y poner los valores deseados.

En esta nueva versión, el script se puede ejecutar de esta manera:

```
./crearvm.sh -n demo1 -d 10 -m 720
```

Se creará entonces una máquina virtual llamada `demo1` con un disco duro de tamaño `10 Gbytes` y una RAM de `720` megabytes.

---

## Tarea

Dentro del script [crearvm.sh](crearvm.sh) hay dos instrucciones, línea 80:

```
VBoxManage modifyvm "${MACHINENAME}" --nic1 nat
```

y la última línea del script:

```
VBoxHeadless --startvm $MACHINENAME
```

que crean una interfaz de red y arrancan la ejecución de la máquina virtual, respectivamente.

El script al momento recibe los siguientes *flags* `-n`, `-d`, `-m`; que permiten definir el nombre de la máquina, el tamaño en disco y la cantidad de RAM; asignada a la máquina virtual.

**Su tarea** modificar el script de modo que el usuario pueda pasar dos nuevos *flags*:

* `-r`: Si el usuario ejecuta el script de esta manera `./crearvm.sh -r n` entonces la máquina virtual  se creará sin interfaz de red. Es decir, la instrucción de la línea 80 **no se ejecuta**. Si el usuario digita `./crearvm.sh -r y` entonces se creará la interfaz de red. Esa es la opción por defecto, crear la interfaz de red. **IMPORTANTE** este *flag* espera recibir un caracter a su derecha o `n` o `y`. Si el usuario no invoca el *flag* `-r` entonces la interfaz de red se crea.
* `-s`: Si el usuario ejecuta el script de esta manera `./crearvm.sh -s` entonces la máquina virtual, después de creada **se ejecutará**. Si el usuario ejecuta el script `./crearvm.sh -n demo` (observe no se pasó el flag `-s`) entonces la máquina virtual no se ejecutará una vez se termine de crear.

---

## Referencias

A continuación un par de enlaces acerca de como parsear los argumentos que se le pasan a un script en Bash.

* [Enlace 1](https://linuxconfig.org/how-to-use-getopts-to-parse-a-script-options)
* [Enlace 1](https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/)

