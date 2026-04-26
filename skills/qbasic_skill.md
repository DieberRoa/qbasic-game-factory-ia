# Skill: Programación Estructurada en QBasic

## Nombre del Skill
`qbasic_expert_developer`

## Descripción
Habilidad especializada en la creación, estructuración y depuración de código QBasic.

## Reglas y Mejores Prácticas (Knowledge Base)

### 1. Tipos de Datos y Declaración
- Usa `DIM` para todas las variables.
- Usa sufijos de tipo o declaraciones explícitas:
  - `%` para INTEGER (ej. `DIM contador AS INTEGER`)
  - `&` para LONG (ej. `DIM puntaje AS LONG`)
  - `!` para SINGLE (ej. `DIM velocidad AS SINGLE`)
  - `#` para DOUBLE (ej. `DIM pi AS DOUBLE`)
  - `$` para STRING (ej. `DIM nombre AS STRING`)

### 2. Control de Flujo (Estructurado)
- **NO usar** números de línea (10, 20, 30...) a menos que sea estrictamente necesario para portar código muy antiguo.
- **Evitar** `GOTO`.
- Usar `DO...LOOP` para ciclos condicionales:
  ```qbasic
  DO WHILE condicion
      ' lógica
  LOOP
  ```
- Usar `FOR...NEXT` para iteraciones conocidas.
- Usar `SELECT CASE` en lugar de múltiples `IF...ELSEIF`.

### 3. Modularización
- Dividir la lógica compleja usando `SUB` (procedimientos sin retorno) y `FUNCTION` (procedimientos con retorno).
- Declarar siempre los procedimientos usando `DECLARE SUB` o `DECLARE FUNCTION` al inicio del archivo (QB64 a veces lo hace automáticamente, pero es buena práctica de compatibilidad).

### 4. Gráficos y Pantalla
- Para texto limpio: `CLS`
- Para gráficos básicos: `SCREEN 12` (VGA 640x480, 16 colores) o `SCREEN 13` (VGA 320x200, 256 colores).
- Funciones útiles: `COLOR`, `LOCATE`, `LINE`, `CIRCLE`, `PSET`.

### 5. Entrada y Salida
- Entrada del usuario: `INPUT` y `LINE INPUT` (para cadenas con espacios).
- Lectura de teclas en tiempo real: `INKEY$`
  ```qbasic
  DO
      tecla$ = INKEY$
  LOOP UNTIL tecla$ <> ""
  ```
