' engine.bas - Implementación del motor

' ==========================================
' RUTINA DE COLISIÓN (AABB)
' ==========================================
FUNCTION CheckCollision (x1 AS SINGLE, y1 AS SINGLE, w1 AS INTEGER, h1 AS INTEGER, x2 AS SINGLE, y2 AS SINGLE, w2 AS INTEGER, h2 AS INTEGER)
    IF x1 < x2 + w2 AND x1 + w1 > x2 AND y1 < y2 + h2 AND y1 + h1 > y2 THEN
        CheckCollision = 1
    ELSE
        CheckCollision = 0
    END IF
END FUNCTION

' ==========================================
' INICIALIZACIÓN FÍSICA
' ==========================================
SUB InitEngine ()
    gravity = 0.5
    friction = 0.8
    jumpForce = -7.5
    camX = 0
    camY = 0
END SUB

' ==========================================
' MODELADOR DE SPRITES
' ==========================================
SUB DrawSpriteFromData (spriteArray() AS INTEGER, w AS INTEGER, h AS INTEGER)
    CLS
    DIM rowData AS STRING
    DIM col AS INTEGER, row AS INTEGER
    DIM pxColor AS INTEGER
    DIM scale AS INTEGER
    
    scale = 2 
    
    FOR row = 1 TO h
        READ rowData$
        FOR col = 1 TO w
            DIM c$
            c$ = MID$(rowData$, col, 1)
            
            IF c$ >= "0" AND c$ <= "9" THEN
                pxColor = VAL(c$)
            ELSEIF UCASE$(c$) >= "A" AND UCASE$(c$) <= "F" THEN
                pxColor = ASC(UCASE$(c$)) - ASC("A") + 10
            END IF
            
            IF pxColor > 0 THEN
                LINE ((col - 1) * scale, (row - 1) * scale)-((col * scale) - 1, (row * scale) - 1), pxColor, BF
            END IF
        NEXT col
    NEXT row
    
    GET (0, 0)-((w * scale) - 1, (h * scale) - 1), spriteArray
    CLS
END SUB
