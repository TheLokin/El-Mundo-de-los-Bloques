<h1 align="center">El Mundo de los Bloques</h1>

## Introducción

Un ejercicio clásico de inteligencia artificial es el diseño de un programa para construir planes de acciones en "El Mundo de
los Bloques". Este mundo está formado por bloques (un mínimo de uno y un máximo de ocho) situados en un plano de tres
posiciones. Se supone además la existencia de un brazo mecánico encargado de mover los bloques. Dicho brazo mecánico es capaz
de realizar las seis acciones usuales: subir, bajar, ir a la izquierda, ir a la derecha, coger un bloque y soltarlo. De esta
forma, se pueden manejar sólo los bloques situados en las cimas. Es decir, en ningún caso se podrá acceder directamente a un
bloque que esté situado debajo de otro bloque, ni podrá situarse directamente un bloque debajo de otro. El número máximo de
bloques que se pueden apilar juntos es de tres. Los bloques no pueden dejarse caer, es decir, el brazo mecánico sólo puede
ejecutar la acción de soltar un bloque cuando justo debajo de él esté el suelo u otro bloque.

La figura 1 muestra dos posibles configuraciones de este mundo. Una posible secuencia de acciones del brazo mecánico que
transforma la configuración de la izquierda en la configuración de la derecha podría ser la siguiente: Abajo, Izquierda, Coger,
Derecha, Abajo, Soltar, Izquierda, Coger, Arriba, Derecha, Derecha, Soltar, Izquierda, Abajo, Coger, Arriba, Arriba, Derecha,
Soltar, Izquierda.

<div align="center">
  <img alt="Figura 1" src="img/figura1.png" />
  <p>Figura 1: Dos posibles configuraciones de "El Mundo de los Bloques"</p>
</div>

## Implementación

El archivo llamado *bloques.ml* contiene toda la funcionalidad, donde dado un mundo inicial y un mundo final obtiene el plan más
eficiente posible para pasar de uno a otro, y seguidamente escribe en la salida estándar los nombres de todas las acciones que
forman el plan, cada una de ellas en una línea independiente. Si no existiera ningún plan capaz de pasar de un mundo a otro, el
programa escribe en la salida estándar una única línea con la palabra *Imposible*.

A la hora de definir y manejar las configuraciones de los mundos inicial y final, se supone que el brazo mecánico comienza a
trabajar siempre en el nivel más elevado de la posición Q, y que el plan obtenido debe devolver el brazo a esa misma posición
tras realizar todos los movimientos de bloques que sean necesarios.

El programa debe recibir las configuraciones de los mundos inicial y final en la línea de comandos, siguiendo el siguiente
formato: los mundos se describen por columnas, de izquierda a derecha y de arriba a abajo, y reservando el número 0 para las
posiciones vacías y los números del 1 al 8 para las posiciones en las que están los bloques. De esta forma, considerando de
nuevo la figura 1, el orden para obtener y escribir el plan que pasa de la configuración de la izquierda a la configuración
de la derecha sería:

```
./bloques 012000003 000000123
```

## Interfaz

Junto con el código en OCaml se proporciona una interfaz de simulación desarrollada en Tcl/Tk, cuyo aspecto se puede
observar en la figura 2. Esta interfaz permite:

- Construir gráficamente un mundo inicial y un mundo final (pulsando los botones **Configurar** y moviendo los bloques a nuestro
antojo).

- Transformar ambos mundos en sus correspondientes secuencias de números enteros del 0 al 8, invocar al programa ejecutable
*bloques* pasándole dichas secuencias de números como parámetros en la línea de comandos, y capturar su salida (el plan de
acciones) para su correcta visualización (todo ello pulsando el botón **Plan**).

- Verificar si los planes de acciones obtenidos para el programa bloques realizan correctamente la transformación del mundo
inicial en el final (pulsando el botón **Ejecutar**).

La interfaz gráfica de simulación se lanza mediante el comando blq.tcl seguido del número de bloques a manejar. Por ejemplo:

```
./blq.tcl 5
```

<div align="center">
  <img alt="Figura 2" src="img/figura2.png" />
  <p>Figura 2: Interfaz gráfica para la simulación de "El Mundo de los Bloques"</p>
</div>
