# Proyecto QBasic - Entorno de Desarrollo Asistido por IA

Este repositorio contiene un **marco de trabajo (Framework) completo** para el desarrollo estructurado y moderno de aplicaciones y videojuegos clásicos en QBasic y QB64. Fue diseñado específicamente para aprovechar la asistencia de Inteligencia Artificial (IA) asegurando código limpio, evitando malas prácticas antiguas y facilitando la compilación nativa en Windows.

## 🚀 Capacidades del Entorno

El framework está preparado para construir desde simples programas de texto hasta **videojuegos con gráficos retro**. Entre las capacidades demostradas que puede manejar la IA en este entorno se incluyen:

- **Programación Estructurada y Limpia:** Se fomenta el uso de `SUB`, `FUNCTION`, ciclos estructurados (`DO...LOOP`, `FOR...NEXT`) y se prohíbe terminantemente el uso de la instrucción `GOTO` o los números de línea.
- **Gráficos Avanzados (Sin Parpadeo):** Soporte para modos gráficos (como `SCREEN 7` o `SCREEN 12`) implementando *Double Buffering* mediante el uso de páginas de video y la instrucción `PCOPY`. Esto logra animaciones ultra suaves sin el clásico parpadeo de pantalla ("flicker" o "tearing").
- **Sprites e Imágenes Vectoriales:** Capacidad para generar pixel art dinámicamente en la memoria gráfica (`GET` y `PUT`), evitando depender de caracteres ASCII o archivos externos y manteniendo el código 100% autocontenido.
- **Detección de Colisiones (AABB):** Manejo matemático de coordenadas X, Y para colisiones precisas (ej. impacto de balas con enemigos, o desgaste localizado de escudos destructibles).
- **Sonidos y Música:** Uso nativo de la instrucción `SOUND` para efectos de sonido (disparos, explosiones) y de la función `PLAY` para componer melodías retro (ej. canciones de victoria o "game over").
- **Lógica de Videojuegos:** Rutinas de física básica, sistemas de probabilidad (`RND`) para el comportamiento de entidades (como invasores que deciden disparar), temporizadores (Frames) y manejo fluido de múltiples objetos en pantalla usando matrices (`DIM SHARED`).

## 🎨 ¿Cómo crear Sprites sin archivos externos?

Este framework utiliza un sistema de **"Sprites por Código"** que permite crear gráficos sin depender de archivos de imagen externos (`.bmp`, `.png`), manteniendo todo el código en un único archivo ejecutable. El proceso se basa en dibujar figuras geométricas en la memoria gráfica oculta y capturarlas en arrays.

### Pasos para crear un Sprite:
1. **Definir un Array (Vector):** Se reserva espacio en memoria utilizando `DIM SHARED` para almacenar los datos de los píxeles. El tamaño del array depende de las dimensiones en píxeles de la imagen.
2. **Dibujar la forma:** Se limpia la pantalla temporalmente (`CLS`) y se utilizan comandos gráficos puros de QBasic como `LINE` (con los parámetros `B` para cajas huecas o `BF` para rellenar). Los colores se basan en la paleta del modo de pantalla elegido (ej. `SCREEN 7` tiene 16 colores).
3. **Capturar la imagen:** Se usa la instrucción `GET` para leer el bloque rectangular de píxeles en pantalla y guardarlo dentro del array previamente creado.
4. **Limpiar y Continuar:** La pantalla se vuelve a limpiar. Todo esto ocurre de forma casi instantánea al iniciar el programa, y es imperceptible para el jugador.

### Ejemplo de Código:
```basic
' 1. Crear el array para guardar la imagen
DIM SHARED imgPlayer(100) AS INTEGER

' 2. Entorno de dibujo (se hace en la inicialización)
CLS

' Dibujar partes de la nave (verde brillante = color 10)
LINE (7, 0)-(8, 4), 10, BF   ' Cañón principal
LINE (5, 5)-(10, 9), 10, BF  ' Cuerpo superior
LINE (1, 10)-(14, 15), 10, BF ' Base

' 3. Capturar la imagen completa (rectángulo de 16x16 píxeles)
GET (0, 0)-(15, 15), imgPlayer
CLS
```

Para dibujar el sprite en la pantalla durante el ciclo principal del juego, simplemente usa la instrucción `PUT`:
```basic
PUT (playerX, playerY), imgPlayer, PSET
```

## 📁 Estructura del Proyecto

* **`agents/`**: Contiene la definición de rol y el prompt del Agente (`qbasic_agent.md`) que actúa como el Ingeniero de Software Senior en QBasic.
* **`skills/`**: Contiene las reglas, mejores prácticas y restricciones de sintaxis para generar código limpio en QBasic (`qbasic_skill.md`).
* **`tools/`**: Herramientas y scripts de automatización. Incluye el poderoso `run.ps1` para compilar y ejecutar de forma sencilla con QB64.
* **`docs/`**: Especificaciones y documentación adicional del marco de trabajo (`qbasic_spec.md`).
* **`src/`**: Carpeta principal para todo el código fuente `.bas` y `.bi`.
  - Contiene ejemplos listos para usar, como el clásico juego **"Adivina el Número"** (`src\juego\juego.bas`) y un clon completo de **Space Invaders** (`src\space_invaders\space_invaders.bas`) que demuestra gráficos fluidos, sonido y escudos destructibles.
* **`build/`**: Carpeta de destino para los ejecutables `.exe` compilados por el script `run.ps1`.
* **`assets/`**: Archivos de recursos auxiliares, sprites (ASCII o gráficos puros), textos o bases de datos utilizados por los programas.

## 🎮 ¿Cómo Ejecutar y Compilar?

El entorno cuenta con un script de PowerShell inteligente que detecta tu código, busca la instalación de QB64 y compila el juego automáticamente. 

Desde la raíz del proyecto (`C:\Personal\qbasic`), utiliza el script especificando la ruta al archivo que deseas ejecutar.

Para jugar al **Space Invaders**:
```powershell
.\tools\run.ps1 -File .\src\space_invaders\space_invaders.bas
```

Para probar **Adivina el Número**:
```powershell
.\tools\run.ps1 -File .\src\juego\juego.bas
```

Para **solamente compilar** (generará el archivo ejecutable `.exe` dentro de la carpeta `build/`) sin lanzarlo:
```powershell
.\tools\run.ps1 -File .\src\space_invaders\space_invaders.bas -CompileOnly
```

## 🧠 Memoria y Contexto del Agente (Knowledge)
Todos los cambios arquitectónicos y decisiones de desarrollo respetan firmemente las reglas establecidas en la carpeta `skills/` y `docs/`. Al iniciar cualquier sesión de desarrollo en este repositorio, el asistente de IA consulta automáticamente estas reglas para "memorizar" el contexto. Esto garantiza que cualquier ampliación del código o la creación de un juego completamente nuevo se realizará aplicando verdaderos principios de *game design* retro, manteniendo la compatibilidad nativa, un excelente rendimiento de memoria y una perfecta organización modular.
