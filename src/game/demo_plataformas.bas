'$INCLUDE: '../engine/engine.bi'

DECLARE SUB InitGame ()

' Variables del juego (no del engine core)
DIM SHARED imgIdle(100) AS INTEGER
DIM SHARED imgRun1(100) AS INTEGER
DIM SHARED imgRun2(100) AS INTEGER

' Iniciar modo gráfico
SCREEN 7, 0, 1, 0

InitEngine
InitGame

' ==========================================
' CARGA DE SPRITES DESDE STRINGS DE TEXTO
' ==========================================
RESTORE SpriteIdle
DrawSpriteFromData imgIdle(), 8, 6

RESTORE SpriteRun1
DrawSpriteFromData imgRun1(), 8, 6

RESTORE SpriteRun2
DrawSpriteFromData imgRun2(), 8, 6

DIM k AS STRING
DIM gameOver AS INTEGER
DIM i AS INTEGER, j AS INTEGER
DIM drawX AS INTEGER, drawY AS INTEGER

gameOver = 0

' ==========================================
' BUCLE PRINCIPAL (GAMELOOP)
' ==========================================
DO WHILE gameOver = 0
    k = INKEY$
    IF k = CHR$(27) THEN gameOver = 1 ' ESC
    
    ' --- 1. CONTROLES ---
    player.state = 0 ' Por defecto idle
    
    IF k = CHR$(0) + "K" OR UCASE$(k) = "A" THEN
        player.vx = player.vx - 2
        IF player.vx < -4 THEN player.vx = -4
        player.dir = -1
    END IF
    IF k = CHR$(0) + "M" OR UCASE$(k) = "D" THEN
        player.vx = player.vx + 2
        IF player.vx > 4 THEN player.vx = 4
        player.dir = 1
    END IF
    
    ' Estado de correr si tiene velocidad y esta en el suelo
    IF ABS(player.vx) > 0.5 AND player.isGrounded = 1 THEN player.state = 1
    
    ' Salto
    IF (k = " " OR UCASE$(k) = "W" OR k = CHR$(0) + "H") AND player.isGrounded = 1 THEN
        player.vy = jumpForce
        player.isGrounded = 0
        SOUND 800, 0.5
    END IF

    ' Disparo (Enter)
    IF k = CHR$(13) THEN
        FOR i = 1 TO 10
            IF bullets(i).active = 0 THEN
                bullets(i).active = 1
                bullets(i).x = player.x + player.w / 2
                bullets(i).y = player.y + player.h / 2 - 2
                bullets(i).vx = player.dir * 8
                bullets(i).vy = 0
                bullets(i).life = 40
                SOUND 1500, 0.2
                EXIT FOR
            END IF
        NEXT i
    END IF

    ' --- 2. FÍSICA Y COLISIONES ---
    player.vy = player.vy + gravity
    
    player.vx = player.vx * friction
    IF ABS(player.vx) < 0.1 THEN player.vx = 0
    
    IF player.isGrounded = 0 THEN player.state = 2
    
    ' Mover X
    player.x = player.x + player.vx
    FOR i = 1 TO numPlatforms
        IF CheckCollision(player.x, player.y, player.w, player.h, platforms(i).x, platforms(i).y, platforms(i).w, platforms(i).h) = 1 THEN
            IF player.vx > 0 THEN player.x = platforms(i).x - player.w
            IF player.vx < 0 THEN player.x = platforms(i).x + platforms(i).w
            player.vx = 0
        END IF
    NEXT i
    
    ' Límites del nivel (ancho 1200)
    IF player.x < 0 THEN player.x = 0
    IF player.x + player.w > 1200 THEN player.x = 1200 - player.w
    
    ' Mover Y
    player.y = player.y + player.vy
    player.isGrounded = 0
    
    ' Muerte por caída al abismo
    IF player.y > 300 THEN
        player.y = 50
        player.x = 50
        player.vy = 0
        SOUND 100, 1
    END IF

    FOR i = 1 TO numPlatforms
        IF CheckCollision(player.x, player.y, player.w, player.h, platforms(i).x, platforms(i).y, platforms(i).w, platforms(i).h) = 1 THEN
            IF player.vy > 0 THEN 
                player.y = platforms(i).y - player.h
                player.isGrounded = 1
            ELSEIF player.vy < 0 THEN 
                player.y = platforms(i).y + platforms(i).h
            END IF
            player.vy = 0
        END IF
    NEXT i
    
    ' Actualizar Proyectiles
    FOR i = 1 TO 10
        IF bullets(i).active = 1 THEN
            bullets(i).x = bullets(i).x + bullets(i).vx
            bullets(i).life = bullets(i).life - 1
            IF bullets(i).life <= 0 THEN bullets(i).active = 0
            
            FOR j = 1 TO numPlatforms
                IF CheckCollision(bullets(i).x, bullets(i).y, 4, 4, platforms(j).x, platforms(j).y, platforms(j).w, platforms(j).h) = 1 THEN
                    bullets(i).active = 0
                END IF
            NEXT j
        END IF
    NEXT i

    ' --- 3. ANIMACIONES ---
    IF ABS(player.vx) > 0.5 THEN player.animTimer = player.animTimer + 1
    
    IF player.state = 0 THEN
        player.frame = 0 ' Idle
    ELSEIF player.state = 1 THEN
        IF player.animTimer > 4 THEN
            player.animTimer = 0
            IF player.frame = 1 THEN player.frame = 2 ELSE player.frame = 1
        END IF
    ELSEIF player.state = 2 THEN
        player.frame = 2 ' Jump usa frame 2
    END IF

    ' --- 4. CÁMARA (SCROLLING) ---
    camX = camX + (player.x - 160 + player.w / 2 - camX) * 0.1
    IF camX < 0 THEN camX = 0
    IF camX > 1200 - 320 THEN camX = 1200 - 320

    ' --- 5. DIBUJAR (RENDER) ---
    CLS
    
    ' Dibujar Plataformas
    FOR i = 1 TO numPlatforms
        drawX = INT(platforms(i).x - camX)
        drawY = INT(platforms(i).y - camY)
        IF drawX + platforms(i).w > 0 AND drawX < 320 THEN
            LINE (drawX, drawY)-(drawX + platforms(i).w - 1, drawY + platforms(i).h - 1), 2, BF
        END IF
    NEXT i
    
    ' Dibujar Proyectiles
    FOR i = 1 TO 10
        IF bullets(i).active = 1 THEN
            drawX = INT(bullets(i).x - camX)
            drawY = INT(bullets(i).y - camY)
            IF drawX > 0 AND drawX < 320 THEN
                LINE (drawX, drawY)-(drawX + 3, drawY + 3), 14, BF
            END IF
        END IF
    NEXT i
    
    ' Dibujar Jugador
    drawX = INT(player.x - camX)
    drawY = INT(player.y - camY)
    
    IF drawX >= 0 AND drawX <= 303 AND drawY >= 0 AND drawY <= 187 THEN
        IF player.frame = 0 THEN
            PUT (drawX, drawY), imgIdle, PSET
        ELSEIF player.frame = 1 THEN
            PUT (drawX, drawY), imgRun1, PSET
        ELSEIF player.frame = 2 THEN
            PUT (drawX, drawY), imgRun2, PSET
        END IF
    END IF
    
    ' UI
    COLOR 15
    LOCATE 1, 2: PRINT "JUEGO SEPARADO DEL MOTOR (MODULAR)"
    LOCATE 2, 2: PRINT "A/D: Mover | ESPACIO: Saltar | ENTER: Disparo"
    
    PCOPY 1, 0
    _DELAY 0.03
LOOP

END

' ==========================================
' DATOS DE SPRITES (Animaciones)
' ==========================================
SpriteIdle:
DATA "10011001"
DATA "10011001"
DATA "11111111"
DATA "00444400"
DATA "04000400"
DATA "F000000F"

SpriteRun1:
DATA "10011001"
DATA "10011001"
DATA "11111111"
DATA "00444400"
DATA "04000040"
DATA "0F00000F"

SpriteRun2:
DATA "10011001"
DATA "10011001"
DATA "11111111"
DATA "00444400"
DATA "00400400"
DATA "000F000F"

' ==========================================
' LÓGICA DEL JUEGO
' ==========================================
SUB InitGame ()
    player.x = 50
    player.y = 50
    player.vx = 0
    player.vy = 0
    player.w = 16  
    player.h = 12
    player.dir = 1
    
    ' Crear nivel (plataformas)
    numPlatforms = 7
    
    ' Suelo principal
    platforms(1).x = 0: platforms(1).y = 170: platforms(1).w = 400: platforms(1).h = 30
    ' Hueco / abismo
    platforms(2).x = 450: platforms(2).y = 170: platforms(2).w = 750: platforms(2).h = 30
    
    ' Plataformas flotantes
    platforms(3).x = 200: platforms(3).y = 130: platforms(3).w = 60: platforms(3).h = 10
    platforms(4).x = 320: platforms(4).y = 90: platforms(4).w = 60: platforms(4).h = 10
    platforms(5).x = 450: platforms(5).y = 120: platforms(5).w = 50: platforms(5).h = 10
    platforms(6).x = 600: platforms(6).y = 140: platforms(6).w = 80: platforms(6).h = 10
    
    ' Muro
    platforms(7).x = 800: platforms(7).y = 100: platforms(7).w = 20: platforms(7).h = 70
    
    FOR i = 1 TO 10
        bullets(i).active = 0
    NEXT i
END SUB

'$INCLUDE: '../engine/engine.bas'
