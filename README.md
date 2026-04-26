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

Este framework utiliza un sistema de **"Sprites por Código"** que permite crear gráficos sin depender de archivos de imagen externos (`.bmp`, `.png`), manteniendo todo el código en un único archivo ejecutable. Existen dos métodos principales implementados:

### Método 1: Dibujo por Formas Geométricas (Básico)
Utilizado en juegos como *Space Invaders*. Consiste en dibujar figuras geométricas usando instrucciones puras de QBasic.
1. **Definir un Array (Vector):** Se reserva espacio en memoria utilizando `DIM SHARED` para almacenar los datos de los píxeles.
2. **Dibujar la forma:** Se limpia la pantalla (`CLS`) y se usan comandos como `LINE` para pintar rectángulos. Los colores se basan en la paleta del modo de pantalla (ej. 16 colores).
3. **Capturar la imagen:** Se usa la instrucción `GET` para leer el bloque rectangular de píxeles y guardarlo en el array.

```basic
' 1. Crear el array y limpiar entorno
DIM SHARED imgPlayer(100) AS INTEGER
CLS

' 2. Dibujar partes de la nave (verde brillante = color 10)
LINE (7, 0)-(8, 4), 10, BF   ' Cañón principal
LINE (5, 5)-(10, 9), 10, BF  ' Cuerpo superior
LINE (1, 10)-(14, 15), 10, BF ' Base

' 3. Capturar la imagen completa (rectángulo de 16x16 píxeles) y limpiar
GET (0, 0)-(15, 15), imgPlayer
CLS
```

### Método 2: Modelador Basado en Texto (Avanzado - `src/engine`)
Utilizado en el motor físico (`framework.bas`). Permite crear pixel art de forma mucho más visual usando bloques de texto en el propio código, donde cada carácter representa un color Hexadecimal (0-F).
1. **Crear el mapa visual con DATA:** Se "dibuja" la imagen usando strings debajo de una etiqueta. Cada carácter representa un color Hexadecimal de la paleta estándar de 16 colores:
   | Hex | Color | Hex | Color |
   |---|---|---|---|
   | `0` | Transparente / Negro | `8` | Gris Oscuro |
   | `1` | Azul Oscuro | `9` | Azul Claro |
   | `2` | Verde Oscuro | `A` | Verde Claro |
   | `3` | Cian Oscuro | `B` | Cian Claro |
   | `4` | Rojo Oscuro | `C` | Rojo Claro |
   | `5` | Magenta Oscuro | `D` | Magenta Claro |
   | `6` | Marrón / Naranja | `E` | Amarillo |
   | `7` | Gris Claro | `F` | Blanco |
2. **Cargar mediante un renderizador:** La rutina `DrawSpriteFromData` lee estos datos con `READ`, los convierte a colores y dibuja los píxeles (con la opción de escalarlos) automáticamente antes de guardarlos con `GET`.

```basic
' 1. Diseñar el Sprite Visualmente en el Código
SpritePersona:
DATA "10011001"
DATA "10011001"
DATA "11111111"
DATA "00444400"
DATA "04000400"
DATA "F000000F"

' 2. Cargar el Sprite en el Array (indicando ancho y alto)
DIM SHARED imgPlayer(100) AS INTEGER
RESTORE SpritePersona
DrawSpriteFromData imgPlayer(), 8, 6
```

Para dibujar el sprite en la pantalla durante el ciclo principal del juego (independientemente del método usado), usa la instrucción `PUT`:
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
