DECLARE SUB DrawSpriteFromData (spriteArray() AS INTEGER, w AS INTEGER, h AS INTEGER)
DECLARE SUB InitEngine ()

' ==========================================
' MOTOR FÍSICO Y DEFINICIÓN DE ENTIDADES
' ==========================================
TYPE GameObject
    x AS SINGLE
    y AS SINGLE
    vx AS SINGLE
    vy AS SINGLE
    w AS INTEGER
    h AS INTEGER
    isGrounded AS INTEGER
END TYPE

DIM SHARED player AS GameObject
DIM SHARED gravity AS SINGLE
DIM SHARED friction AS SINGLE
DIM SHARED jumpForce AS SINGLE
DIM SHARED floorY AS SINGLE

' Array para el sprite del jugador
DIM SHARED imgPlayer(100) AS INTEGER

' Iniciar modo gráfico con doble búfer (320x200)
SCREEN 7, 0, 1, 0

InitEngine

' ==========================================
' CARGA DE SPRITES DESDE STRINGS DE TEXTO
' ==========================================
' Cargamos los datos visuales debajo de la etiqueta "SpritePersona"
RESTORE SpritePersona
' Le decimos que es un sprite de 8 de ancho por 6 de alto
DrawSpriteFromData imgPlayer(), 8, 6

DIM k AS STRING
DIM gameOver AS INTEGER
gameOver = 0

' ==========================================
' BUCLE PRINCIPAL (GAMELOOP)
' ==========================================
DO WHILE gameOver = 0
    k = INKEY$
    IF k = CHR$(27) THEN gameOver = 1 ' ESC
    
    ' --- 1. CONTROLES ---
    IF k = CHR$(0) + "K" OR UCASE$(k) = "A" THEN
        player.vx = -4
    END IF
    IF k = CHR$(0) + "M" OR UCASE$(k) = "D" THEN
        player.vx = 4
    END IF
    
    ' Salto (Solo si está tocando el suelo)
    IF (k = " " OR UCASE$(k) = "W") AND player.isGrounded = 1 THEN
        player.vy = jumpForce
        player.isGrounded = 0
        SOUND 800, 0.5
    END IF
    
    ' --- 2. FÍSICA ---
    ' A. Aplicar Gravedad (Acelerar hacia abajo)
    player.vy = player.vy + gravity
    
    ' B. Aplicar Fricción horizontal (Desacelerar al soltar teclas)
    player.vx = player.vx * friction
    
    ' C. Actualizar Posiciones
    player.x = player.x + player.vx
    player.y = player.y + player.vy
    
    ' D. Colisiones con Paredes (con rebote)
    IF player.x < 0 THEN 
        player.x = 0
        player.vx = -player.vx * 0.5 ' Pierde velocidad al rebotar
    END IF
    IF player.x + player.w > 319 THEN 
        player.x = 319 - player.w
        player.vx = -player.vx * 0.5
    END IF
    
    ' E. Colisión con el Suelo
    IF player.y + player.h >= floorY THEN
        player.y = floorY - player.h
        player.vy = 0
        player.isGrounded = 1
    ELSE
        player.isGrounded = 0
    END IF
    
    ' --- 3. DIBUJAR (RENDER) ---
    CLS
    
    ' Dibujar Suelo
    LINE (0, floorY)-(319, 199), 2, BF
    
    ' Dibujar Jugador
    PUT (player.x, player.y), imgPlayer, PSET
    
    ' Instrucciones en pantalla
    COLOR 15
    LOCATE 1, 2: PRINT "MOTOR FISICO: GRAVEDAD Y COLISIONES"
    LOCATE 3, 2: PRINT "A/D: Mover | ESPACIO: Saltar"
    LOCATE 4, 2: PRINT "ESC: Salir"
    
    ' Volcar a pantalla (evita parpadeo)
    PCOPY 1, 0
    _DELAY 0.03
LOOP
' ==========================================
' DATOS DE SPRITES (MAPA DE PÍXELES)
' ==========================================
' En lugar de usar comas para asignar el color, usamos el sistema Hexadecimal nativo de la paleta.
' 0 = Transparente (Negro)
' 1 = Azul
' 4 = Rojo
' F = Blanco (Equivalente al numero 15)
' De esta manera, dibujas VISUALMENTE el sprite con sus colores exactos usando 1s y 0s.
SpritePersona:
DATA "10011001"
DATA "10011001"
DATA "11111111"
DATA "00444400"
DATA "04000400"
DATA "F000000F"

END


' ==========================================
' CONFIGURACIÓN INICIAL
' ==========================================
SUB InitEngine ()
    gravity = 0.6       ' Fuerza de caida
    friction = 0.8      ' Resistencia del suelo
    jumpForce = -8.0    ' Potencia de salto (negativo es hacia arriba)
    floorY = 170        ' Altura del piso
    
    player.x = 150
    player.y = 50
    player.vx = 0
    player.vy = 0
    ' Al escalar el pixel art de 8x6 por 2x, el tamaño real es 16x12
    player.w = 16  
    player.h = 12
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
    
    scale = 2 ' Escalamos 2x para que no sea tan diminuto
    
    FOR row = 1 TO h
        READ rowData$
        FOR col = 1 TO w
            ' Extraer un digito Hexadecimal de la cadena
            DIM c$
            c$ = MID$(rowData$, col, 1)
            
            ' Convertir de caracter (0-F) al código de color de QBasic
            IF c$ >= "0" AND c$ <= "9" THEN
                pxColor = VAL(c$)
            ELSEIF UCASE$(c$) >= "A" AND UCASE$(c$) <= "F" THEN
                pxColor = ASC(UCASE$(c$)) - ASC("A") + 10
            END IF
            
            ' Si no es negro (0), dibujamos el bloque escalado
            IF pxColor > 0 THEN
                LINE ((col - 1) * scale, (row - 1) * scale)-((col * scale) - 1, (row * scale) - 1), pxColor, BF
            END IF
        NEXT col
    NEXT row
    
    ' Guardar imagen generada en el Array
    GET (0, 0)-((w * scale) - 1, (h * scale) - 1), spriteArray
    CLS
END SUB


