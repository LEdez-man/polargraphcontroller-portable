# Polargraph – Guía para dummies

**Para todas las personas que simplemente quieren empezar a dibujar**: docentes, madres y padres,
grupos juveniles, talleres de arte. No hace falta ningún conocimiento previo. Esta guía explica cada
paso.

[Deutsch](de.md) · [English](en.md) · [Français](fr.md)

---

## ¿Qué es un Polargraph?

Un Polargraph es un **robot dibujante que cuelga de la pared**. Arriba a la izquierda y arriba a la
derecha hay un pequeño motor. De cada motor cuelga un cordel, y entre los dos sostienen un
portalápices en el centro. Cuando los motores alargan o acortan los cordeles, el lápiz se desplaza
por el papel y dibuja, trazo a trazo.

La máquina la controla un ordenador. En él funciona el programa **Polargraph Controller**, que le
indica a la máquina, a través de un cable USB, adónde debe ir el lápiz.

Ideal para: llevar dibujos propios en grande a la pared, dibujar nombres y patrones, convertir fotos
en dibujos de líneas y observar cómo «piensa» un robot.

---

## Lo que necesita

- [ ] Una **máquina Polargraph ya montada**, con su fuente de alimentación
- [ ] Un **ordenador con Windows** (Windows 10 u 11). **No** necesita instalar Java ni ningún otro
      programa.
- [ ] El **cable USB** que corresponde a la máquina
- [ ] **Papel**, fijado a la pared o a un tablero grande
- [ ] Un **rotulador** que quepa en el portalápices
- [ ] Aproximadamente **una hora** la primera vez; después bastan unos minutos

---

## Resumen: tres pasos

| Paso | Qué ocurre | ¿Cuántas veces? |
|---|---|---|
| **A** | El «cerebro» de la máquina (el Arduino) recibe su programa de control | **solo una vez** |
| **B** | El programa de dibujo se coloca en el ordenador | **solo una vez** |
| **C** | Conectar, configurar y dibujar | en cada dibujo |

> **¿La máquina ya ha dibujado antes?** Entonces sáltese el paso A y empiece por el paso B.

---

## Paso A: cargar el programa de control en el Arduino (solo una vez)

Dentro de la máquina hay una pequeña placa electrónica, el **Arduino**. Es el cerebro de la máquina.
Para entender las órdenes del ordenador necesita un programa de control, llamado **firmware**. Se
carga una vez y se queda ahí para siempre.

### A1. Averiguar qué cerebro tiene su máquina

Mire las placas electrónicas de la máquina:

| Lo que ve | Su firmware |
|---|---|
| Una placa con la inscripción **«UNO»** y encima una segunda placa de **Adafruit** («Motor Shield») | **Variante 1:** `polargraph_server_a1` |
| Una placa larga con la inscripción **«MEGA»** y encima una placa con una pequeña **pantalla** (PolarShield, PolargraphSD) | **Variante 2:** `polargraph_server_polarshield` |

La variante 1 existe con dos versiones del Motor Shield:
- Si en la placa pone **«v2»** (por ejemplo «Motor Shield v2.3»), es la **v2**.
- Si no, casi siempre es la **v1**. Se reconoce por dos chips negros grandes con la inscripción
  «L293D».

¿No está seguro? Pregunte a la persona que construyó la máquina, o haga una foto de la placa y
consulte la [wiki de Polargraph](https://github.com/euphy/polargraph/wiki) (en inglés).

### A2. Instalar el programa de Arduino

1. Abra [arduino.cc/en/software](https://www.arduino.cc/en/software).
2. Descargue el **Arduino IDE para Windows** e instálelo. Cuando pregunte por los controladores,
   haga clic en «Instalar».

### A3. Descargar el firmware

1. Abra la
   [página de descarga de Polargraph](https://github.com/euphy/polargraphcontroller/releases/tag/2017-11-01-20-30)
   y haga clic en **`Polargraph.2017-11-01.zip`**.
2. Haga clic con el botón derecho en el archivo descargado, elija **«Extraer todo…»** y luego
   **«Extraer»**.
3. En la carpeta extraída encontrará la subcarpeta **`arduino-source`**. La necesita ahora.

### A4. Copiar los complementos en el lugar correcto

El firmware necesita algunos complementos, llamados bibliotecas.

1. En la carpeta `arduino-source`, abra la carpeta **`libraries`**. Contiene cinco carpetas
   (AccelStepper, AFMotor, Adafruit_MotorShield, UTFT, UTouch).
2. Seleccione las cinco y cópielas (Ctrl + C).
3. Abra su carpeta **Documentos**, después **`Arduino`** y después **`libraries`**. Si no existe la
   carpeta `libraries`, créela (botón derecho → Nuevo → Carpeta).
4. Pegue allí las cinco carpetas (Ctrl + V).
5. Si el Arduino IDE ya estaba abierto, reinícielo.

### A5. Abrir el firmware

- **Variante 1 (UNO):** haga doble clic en
  `arduino-source\polargraph_server_a1\polargraph_server_a1.ino`
- **Variante 2 (MEGA):** haga doble clic en
  `arduino-source\polargraph_server_polarshield\polargraph_server_polarshield.ino`

El Arduino IDE se abre y muestra mucho texto (código del programa). No se preocupe, no hace falta
entenderlo.

### A6. Solo para Motor Shield v2: dos pequeños cambios

**Para la v1 y para la variante 2, sáltese este paso.**

Hacia el principio del texto encontrará estas líneas:

```cpp
#define ADAFRUIT_MOTORSHIELD_V1
#include <AFMotor.h>
```

y debajo:

```cpp
//#define ADAFRUIT_MOTORSHIELD_V2
//#include <Wire.h>
//#include <Adafruit_MotorShield.h>
//#include "utility/Adafruit_PWMServoDriver.h"
```

Dos barras `//` al principio de una línea significan «desactivar esta línea». Cámbielo así:

- Escriba `//` **delante de** las dos líneas v1.
- Borre el `//` **delante de** las cuatro líneas v2.

Después queda así:

```cpp
//#define ADAFRUIT_MOTORSHIELD_V1
//#include <AFMotor.h>

#define ADAFRUIT_MOTORSHIELD_V2
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"
```

### A7. Subir

1. Conecte la máquina al ordenador con el cable USB.
2. Menú **Herramientas → Placa**: elija **«Arduino Uno»** (variante 1) o
   **«Arduino Mega or Mega 2560»** (variante 2).
3. Menú **Herramientas → Puerto**: elija la entrada con **COM** y un número, por ejemplo `COM3`. Si
   hay varias, desconecte un momento el cable USB. La entrada que desaparece es la correcta.
4. Haga clic en la **flecha hacia la derecha** de arriba («Subir»).
5. Espere hasta que abajo aparezca **«Subido»**. Tarda alrededor de un minuto.
6. **Cierre el Arduino IDE.** Si no, bloquea la conexión con la máquina.

¡Listo! No tendrá que volver a hacer este paso nunca más.

---

## Paso B: el programa de dibujo en el ordenador (solo una vez)

1. Abra la
   [página de descarga de este paquete](https://github.com/LEdez-man/polargraphcontroller-portable/releases)
   y haga clic en **`Polargraph-portable-win64-…zip`**.
2. Botón derecho sobre el archivo descargado → **«Extraer todo…»** → **«Extraer»**. Elija un lugar
   que pueda encontrar de nuevo, por ejemplo el escritorio o una memoria USB.
3. **Importante:** no inicie nada directamente desde el archivo zip, siempre desde la carpeta
   extraída.

No se instala nada. Para eliminarlo más adelante, basta con borrar la carpeta.

---

## Paso C: conectar, configurar, dibujar

### C1. Iniciar el programa

1. Abra la carpeta **`Polargraph-portable`**.
2. Haga doble clic en **`start-polargraph.cmd`**.
3. Si Windows muestra **«Windows protegió su PC»**: haga clic en **«Más información»** y luego en
   **«Ejecutar de todas formas»**. Ocurre porque el programa viene de Internet y no tiene una firma
   de pago.

Tras unos segundos se abre la ventana **Polargraph Controller**. En el centro verá una imagen de su
máquina.

### C2. Conectar la máquina

1. Enchufe la **fuente de alimentación** de la máquina y conecte el **cable USB**.
2. En el programa, haga clic en **«Serial port…»** (puerto serie) y elija el mismo puerto COM que en
   el paso A7.
3. Mire la línea de estado de arriba:
   - **Verde «Polargraph READY!»**: todo está conectado.
   - **Rojo «Polargraph is not connected.»**: vea «Si no funciona» más abajo.
4. Más arriba aparece en rojo **«CommandQueue: QUEUE PAUSED - click to start»**. Haga clic encima
   hasta que muestre en verde **«QUEUE RUNNING»**. Solo entonces la máquina ejecuta las órdenes.

### C3. Introducir el tamaño de la máquina (la primera vez)

El programa tiene que saber qué tamaño tiene su máquina. Haga clic arriba en la pestaña
**«Setup»** (configuración).

| Campo | ¿Qué introducir? |
|---|---|
| **Machine Width** (ancho de la máquina) | Distancia entre los dos motores en milímetros, de eje a eje |
| **Machine Height** (alto de la máquina) | Hasta dónde llega el papel hacia abajo, en milímetros desde los motores |
| **MM Per Rev** (mm por vuelta) | Cuánto cordel enrolla una vuelta del motor. La persona que construyó la máquina conoce este valor. |
| **Steps Per Rev** (pasos por vuelta) | Normalmente **200** |

Después haga clic en **«Upload machine spec»** para que la máquina reciba los valores, y en
**«Save»** para que el programa los recuerde. La próxima vez ya estarán ahí.

### C4. Fijar el punto de partida (antes de cada dibujo)

Al encenderse, la máquina no sabe dónde está el lápiz. Por eso existe un **punto de partida** fijo
(«Home»). En la pantalla aparece como una **cruz**; los números a su lado indican dónde está (en mm
desde la izquierda y desde la línea entre los motores). A menudo está marcado en la máquina.

1. Lleve con cuidado el portalápices a ese punto, con la mano.
2. En la pestaña **«input»** (entrada), haga clic en **«Set home»**.

Con **«Pen lift»** (levantar el lápiz) y **«Pen drop»** (bajar el lápiz) puede comprobar si el
lápiz se mueve.

### C5. Cargar un dibujo y dibujarlo

La máquina dibuja mejor **dibujos de líneas** en formato **SVG**.

1. En la pestaña **«input»**, haga clic en **«Load vector»** y elija un archivo SVG.
   (Un segundo clic en «Load vector» quita el dibujo para poder cargar otro.)
2. El dibujo aparece sobre la imagen de la máquina. Con **«Move vector»** (mover) y
   **«Resize vector»** (cambiar el tamaño) ajuste su posición y su tamaño.
3. Haga clic en **«Draw vectors»**. La máquina empieza a dibujar.
4. Para hacer una pausa, haga clic arriba en **«QUEUE RUNNING - click to pause»**.
5. Cuando haya terminado: **«Return to home»** devuelve el lápiz al punto de partida.

**¿De dónde saco archivos SVG?**
- Dibújelos usted mismo con el programa gratuito [Inkscape](https://inkscape.org).
- **Dibujos infantiles**: escanéelos o fotografíelos, ábralos en Inkscape y conviértalos en líneas
  con **Trayecto → Vectorizar mapa de bits**. Funciona mejor con líneas gruesas y oscuras sobre papel
  blanco.
- En [openclipart.org](https://openclipart.org) hay muchos dibujos de líneas gratuitos.

Las fotos también funcionan: con **«Load image file»**, elija después una zona con **«Select Area»**
y haga clic en **«Render pixels…»**. Déjelo para más adelante, cuando funcionen los primeros
dibujos.

---

## Consejos para trabajar con niños

- **Colgarla bien:** la máquina debe estar sujeta firmemente a la pared o al tablero y no debe poder
  caerse.
- **No tocar mientras dibuja:** los dedos pueden quedar atrapados en los motores y los cordeles.
  Mantenerse a un paso de la pared es una buena regla.
- **Fuente de alimentación:** use solo la fuente de alimentación de la máquina. Desenchúfela al
  terminar.
- **Rotuladores:** los rotuladores lavables son ideales. Cambie el rotulador solo con el
  portalápices levantado.
- **Empezar en pequeño:** un dibujo del tamaño de una postal está listo en pocos minutos. Las
  imágenes grandes pueden tardar más de una hora, perfecto para mirar y adivinar qué va a salir.
- **Idea para el grupo:** cada niño dibuja una parte y la máquina las une en un gran dibujo
  colectivo.

---

## Si no funciona

| Problema | Solución |
|---|---|
| No aparece ningún puerto COM en «Serial port…» | Compruebe el cable USB; algunos cables solo cargan y no transmiten datos. Muchos Arduino económicos necesitan una vez el controlador **CH340** (busque «controlador CH340 Windows»). |
| Rojo «Polargraph is not connected.» | Elija otro puerto COM. Cierre el Arduino IDE. ¿Se hizo el paso A? |
| Conectada, pero la máquina no se mueve | ¿Pone «QUEUE PAUSED» arriba? Haga clic encima. ¿Está enchufada la fuente de alimentación? |
| El dibujo sale deformado o demasiado grande | Compruebe las medidas en la pestaña «Setup» (paso C3) y vuelva a fijar el punto de partida (paso C4). |
| El programa no se inicia | Inicie `start-polargraph-console.cmd`. Muestra mensajes de error que puede adjuntar al pedir ayuda. |

Más ayuda (en inglés): [Solución de problemas](../troubleshooting.md),
[Firmware en detalle](../firmware.md), [wiki de Polargraph](https://github.com/euphy/polargraph/wiki).

---

## Pequeño glosario

| Palabra | Significado |
|---|---|
| **Arduino** | Pequeña placa electrónica, el «cerebro» de la máquina |
| **Firmware** | El programa de control que funciona en el Arduino |
| **Puerto COM** | El nombre que Windows da a la conexión USB con la máquina, por ejemplo `COM3` |
| **SVG** | Formato de archivo para dibujos de líneas |
| **Archivo zip** | Una carpeta comprimida; hay que «extraerla» antes de usarla |
| **Home** | El punto de partida fijo del lápiz |
| **Queue** | La cola de órdenes que se envían a la máquina una tras otra |

---

*Polargraph fue creado por Sandy Noble ([polargraph.co.uk](http://www.polargraph.co.uk)).
Este paquete portátil y la guía: Samuel Peters, realizados con la ayuda de Claude (Anthropic).*
