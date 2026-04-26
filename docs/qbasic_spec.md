# Marco de Trabajo para Desarrollo en QBasic (QBasic Framework Spec)

## 1. Visión General
Este marco de trabajo está diseñado para automatizar, asistir y estandarizar la creación de programas en QBasic. Proporciona una estructura clara para el desarrollo, compilación y ejecución de código heredado, utilizando herramientas modernas como QB64 para garantizar la compatibilidad con sistemas operativos actuales (Windows).

## 2. Estructura del Proyecto
Todo proyecto de QBasic bajo este marco debe seguir la siguiente estructura de directorios:
```text
qbasic_project/
├── src/                # Código fuente (.bas, .bi)
│   ├── proyecto_a/     # REGLA 6: Cada proyecto debe tener su propia carpeta
│   │   └── main.bas    
│   └── proyecto_b/     
│       └── app.bas     
├── assets/             # Recursos adicionales (txt, dat)
├── build/              # Ejecutables compilados (.exe)
├── docs/               # Documentación del proyecto
└── tools/              # Scripts de utilidades (ej. run.ps1)
```

## 3. Entorno de Ejecución
- **Compilador Recomendado:** [QB64](https://qb64.com/) (o QB64-PE). QB64 es un compilador moderno que es 100% compatible con el código original de QBasic 4.5 y compila nativamente para Windows.
- **Alternativa:** DOSBox con el ejecutable original `qbasic.exe` (solo para fines puramente nostálgicos o dependencias muy específicas del hardware antiguo).

## 4. Convenciones de Código
- Usar identificadores descriptivos.
- Evitar números de línea a menos que se use `GOTO` o `GOSUB` por necesidad estricta (preferir estructuras de control modernas como `DO...LOOP`, `WHILE...WEND`, `SELECT CASE`).
- Modularizar el código usando `SUB` y `FUNCTION`.
- Definir variables explícitamente (`DIM variable AS TIPO`).

## 5. Flujo de Trabajo
1. **Planificación:** Definir los requerimientos del programa.
2. **Generación de Código:** El Agente QBasic genera el archivo `.bas`.
3. **Compilación/Ejecución:** Se usa el script `run.ps1` para lanzar el programa.
4. **Depuración:** El Agente asiste en la lectura de errores y corrección de sintaxis.
