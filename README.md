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
