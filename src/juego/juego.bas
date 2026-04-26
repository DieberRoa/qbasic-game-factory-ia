' =========================================================================
' Juego de Adivinar el Numero
' Refactorizado usando el framework de Desarrollo Experto en QBasic
' =========================================================================

DECLARE SUB MostrarTitulo ()
DECLARE SUB JugarPartida ()

' --- PROGRAMA PRINCIPAL ---
DIM jugarDeNuevo AS STRING

DO
    MostrarTitulo
    JugarPartida
    
    COLOR 14
    PRINT ""
    INPUT "Quieres jugar de nuevo? (S/N): ", jugarDeNuevo$
LOOP WHILE UCASE$(jugarDeNuevo$) = "S"

COLOR 7
PRINT ""
PRINT "Gracias por jugar! Hasta pronto."
END
' --- FIN DEL PROGRAMA ---

' =========================================================================
' SUBRUTINAS
' =========================================================================

SUB MostrarTitulo ()
    SCREEN 12
    CLS
    COLOR 14
    PRINT "==========================================="
    PRINT "   BIENVENIDO A NUESTRO PROYECTO QBASIC!   "
    PRINT "==========================================="
    COLOR 7
    PRINT ""
    PRINT "He pensado en un numero del 1 al 100..."
    PRINT ""
END SUB

SUB JugarPartida ()
    DIM numeroSecreto AS INTEGER
    DIM intentos AS INTEGER
    DIM intento AS INTEGER
    
    RANDOMIZE TIMER
    numeroSecreto = INT(RND * 100) + 1
    intentos = 0
    
    DO
        COLOR 7
        PRINT ""
        INPUT "Adivina el numero: ", intento
        intentos = intentos + 1
        
        IF intento < numeroSecreto THEN
            COLOR 11
            PRINT "Muy bajo! Intenta de nuevo."
        ELSEIF intento > numeroSecreto THEN
            COLOR 12
            PRINT "Muy alto! Intenta de nuevo."
        ELSE
            COLOR 10
            PRINT "==========================================="
            PRINT "CORRECTO! Lo adivinaste en "; intentos; " intentos."
            PRINT "==========================================="
        END IF
    LOOP UNTIL intento = numeroSecreto
END SUB
