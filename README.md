# Creando una máquina virtual desde CLI

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


