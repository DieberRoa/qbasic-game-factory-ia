DECLARE SUB LoadSprites ()
DECLARE SUB InitGame ()
DECLARE SUB UpdateShields ()

' Arrays para almacenar las imágenes (Sprites)
DIM SHARED imgPlayer(100) AS INTEGER
DIM SHARED imgEnemy(100) AS INTEGER
DIM SHARED imgBullet(20) AS INTEGER
DIM SHARED imgEBullet(20) AS INTEGER

DIM SHARED playerX AS INTEGER
DIM SHARED playerY AS INTEGER
DIM SHARED bulletX AS INTEGER
DIM SHARED bulletY AS INTEGER
DIM SHARED bulletActive AS INTEGER

' Enemigos
DIM SHARED enemyRows AS INTEGER
DIM SHARED enemyCols AS INTEGER
enemyRows = 3
enemyCols = 8

DIM SHARED enemies(8, 3) AS INTEGER
DIM SHARED enemyStartX AS INTEGER
DIM SHARED enemyStartY AS INTEGER
DIM SHARED enemyDir AS INTEGER
DIM SHARED enemySpeed AS INTEGER
DIM SHARED enemyTimer AS INTEGER

' Balas de enemigos
DIM SHARED eBulletX(3) AS INTEGER
DIM SHARED eBulletY(3) AS INTEGER
DIM SHARED eBulletActive(3) AS INTEGER

' Escudos (4 escudos, grid de 3 filas y 4 columnas cada uno)
DIM SHARED shieldHealth(4, 3, 4) AS INTEGER

DIM SHARED score AS INTEGER
DIM SHARED gameOver AS INTEGER
DIM SHARED victory AS INTEGER

' Iniciar modo gráfico con doble búfer
SCREEN 7, 0, 1, 0

LoadSprites
InitGame

' Pantalla de inicio
CLS
COLOR 15
LOCATE 10, 14: PRINT "SPACE INVADERS"
LOCATE 12, 5: PRINT "Presiona cualquier tecla para empezar..."
PCOPY 1, 0
WHILE INKEY$ <> "": WEND
DO WHILE INKEY$ = ""
LOOP

DIM k AS STRING
DIM ex AS INTEGER, ey AS INTEGER
DIM hit AS INTEGER, s AS INTEGER, row AS INTEGER, col AS INTEGER

' === BUCLE PRINCIPAL DEL JUEGO ===
DO WHILE gameOver = 0 AND victory = 0

    k = INKEY$
    IF k <> "" THEN
        IF k = CHR$(27) THEN gameOver = 1 ' ESC
        
        IF k = CHR$(0) + "K" OR UCASE$(k) = "A" THEN
            playerX = playerX - 5
            IF playerX < 5 THEN playerX = 5
        END IF
        
        IF k = CHR$(0) + "M" OR UCASE$(k) = "D" THEN
            playerX = playerX + 5
            IF playerX > 299 THEN playerX = 299
        END IF
        
        IF k = " " AND bulletActive = 0 THEN
            bulletActive = 1
            bulletX = playerX + 7
            bulletY = playerY - 8
            SOUND 1200, 0.5 ' Sonido de disparo jugador
        END IF
    END IF
    
    ' 1. Actualizar Bala del Jugador
    IF bulletActive = 1 THEN
        bulletY = bulletY - 5
        IF bulletY < 5 THEN
            bulletActive = 0
        ELSE
            ' Colisión con Escudos
            IF bulletY >= 145 AND bulletY <= 160 THEN
                FOR s = 1 TO 4
                    DIM sx AS INTEGER
                    sx = 40 + (s - 1) * 65
                    IF bulletX + 1 >= sx AND bulletX <= sx + 24 THEN
                        col = INT((bulletX + 1 - sx) / 6) + 1
                        row = INT((bulletY - 145) / 5) + 1
                        IF col >= 1 AND col <= 4 AND row >= 1 AND row <= 3 THEN
                            IF shieldHealth(s, row, col) = 1 THEN
                                shieldHealth(s, row, col) = 0
                                bulletActive = 0
                                SOUND 300, 0.5 ' Sonido de golpe a escudo
                                EXIT FOR
                            END IF
                        END IF
                    END IF
                NEXT s
            END IF
            
            ' Colisión con Enemigos
            IF bulletActive = 1 THEN
                hit = 0
                FOR r = 1 TO enemyRows
                    FOR c = 1 TO enemyCols
                        IF enemies(c, r) = 1 THEN
                            ex = enemyStartX + (c - 1) * 24
                            ey = enemyStartY + (r - 1) * 20
                            IF bulletY <= ey + 16 AND bulletY + 8 >= ey THEN
                                IF bulletX + 2 >= ex AND bulletX <= ex + 16 THEN
                                    enemies(c, r) = 0
                                    hit = 1
                                    score = score + 10
                                    SOUND 100, 1 ' Sonido explosión enemigo
                                    EXIT FOR
                                END IF
                            END IF
                        END IF
                    NEXT c
                    IF hit = 1 THEN EXIT FOR
                NEXT r
                
                IF hit = 1 THEN
                    bulletActive = 0
                    DIM remaining AS INTEGER
                    remaining = 0
                    FOR r = 1 TO enemyRows
                        FOR c = 1 TO enemyCols
                            IF enemies(c, r) = 1 THEN remaining = remaining + 1
                        NEXT c
                    NEXT r
                    IF remaining = 0 THEN victory = 1
                END IF
            END IF
        END IF
    END IF
    
    ' 2. Actualizar Enemigos
    enemyTimer = enemyTimer + 1
    IF enemyTimer > enemySpeed THEN
        enemyTimer = 0
        
        DIM hitEdge AS INTEGER
        hitEdge = 0
        FOR r = 1 TO enemyRows
            FOR c = 1 TO enemyCols
                IF enemies(c, r) = 1 THEN
                    ex = enemyStartX + (c - 1) * 24
                    IF enemyDir > 0 AND ex + 16 >= 310 THEN hitEdge = 1
                    IF enemyDir < 0 AND ex <= 10 THEN hitEdge = 1
                END IF
            NEXT c
        NEXT r
        
        IF hitEdge = 1 THEN
            enemyDir = -enemyDir
            enemyStartY = enemyStartY + 8
            enemySpeed = enemySpeed - 1
            IF enemySpeed < 1 THEN enemySpeed = 1
            
            FOR r = 1 TO enemyRows
                FOR c = 1 TO enemyCols
                    IF enemies(c, r) = 1 THEN
                        ey = enemyStartY + (r - 1) * 20
                        IF ey + 16 >= playerY THEN gameOver = 1
                    END IF
                NEXT c
            NEXT r
        ELSE
            enemyStartX = enemyStartX + enemyDir
        END IF
        
        ' 3. Probabilidad de que los enemigos disparen
        RANDOMIZE TIMER
        IF INT(RND * 100) < 15 THEN
            FOR b = 1 TO 3
                IF eBulletActive(b) = 0 THEN
                    c = INT(RND * enemyCols) + 1
                    DIM lowestR AS INTEGER
                    lowestR = 0
                    FOR r = enemyRows TO 1 STEP -1
                        IF enemies(c, r) = 1 THEN
                            lowestR = r
                            EXIT FOR
                        END IF
                    NEXT r
                    
                    IF lowestR > 0 THEN
                        ex = enemyStartX + (c - 1) * 24
                        ey = enemyStartY + (lowestR - 1) * 20
                        eBulletActive(b) = 1
                        eBulletX(b) = ex + 7
                        eBulletY(b) = ey + 16
                        SOUND 600, 0.5 ' Sonido de disparo enemigo
                        EXIT FOR
                    END IF
                END IF
            NEXT b
        END IF
    END IF
    
    ' 4. Actualizar Balas Enemigas
    FOR b = 1 TO 3
        IF eBulletActive(b) = 1 THEN
            eBulletY(b) = eBulletY(b) + 3
            IF eBulletY(b) > 190 THEN
                eBulletActive(b) = 0
            ELSE
                ' Colisión con Escudos
                IF eBulletY(b) + 8 >= 145 AND eBulletY(b) <= 160 THEN
                    FOR s = 1 TO 4
                        sx = 40 + (s - 1) * 65
                        IF eBulletX(b) + 1 >= sx AND eBulletX(b) <= sx + 24 THEN
                            col = INT((eBulletX(b) + 1 - sx) / 6) + 1
                            row = INT((eBulletY(b) + 8 - 145) / 5) + 1
                            IF col >= 1 AND col <= 4 AND row >= 1 AND row <= 3 THEN
                                IF shieldHealth(s, row, col) = 1 THEN
                                    shieldHealth(s, row, col) = 0
                                    eBulletActive(b) = 0
                                    SOUND 300, 0.5 ' Sonido de escudo roto
                                    EXIT FOR
                                END IF
                            END IF
                        END IF
                    NEXT s
                END IF
                
                ' Colisión con el Jugador
                IF eBulletActive(b) = 1 THEN
                    IF eBulletY(b) + 8 >= playerY AND eBulletY(b) <= playerY + 16 THEN
                        IF eBulletX(b) + 2 >= playerX AND eBulletX(b) <= playerX + 16 THEN
                            gameOver = 1
                            SOUND 50, 5 ' Sonido grave de muerte
                        END IF
                    END IF
                END IF
            END IF
        END IF
    NEXT b
    
    ' --- DIBUJAR TODO ---
    CLS
    
    ' Jugador
    PUT (playerX, playerY), imgPlayer, PSET
    
    ' Bala del jugador
    IF bulletActive = 1 THEN
        PUT (bulletX, bulletY), imgBullet, PSET
    END IF
    
    ' Balas enemigas
    FOR b = 1 TO 3
        IF eBulletActive(b) = 1 THEN
            PUT (eBulletX(b), eBulletY(b)), imgEBullet, PSET
        END IF
    NEXT b
    
    ' Enemigos
    FOR r = 1 TO enemyRows
        FOR c = 1 TO enemyCols
            IF enemies(c, r) = 1 THEN
                ex = enemyStartX + (c - 1) * 24
                ey = enemyStartY + (r - 1) * 20
                PUT (ex, ey), imgEnemy, PSET
            END IF
        NEXT c
    NEXT r
    
    ' Escudos
    FOR s = 1 TO 4
        sx = 40 + (s - 1) * 65
        sy = 145
        FOR row = 1 TO 3
            FOR col = 1 TO 4
                IF shieldHealth(s, row, col) = 1 THEN
                    LINE (sx + (col - 1) * 6, sy + (row - 1) * 5) - (sx + (col - 1) * 6 + 5, sy + (row - 1) * 5 + 4), 2, BF
                END IF
            NEXT col
        NEXT row
    NEXT s
    
    ' Interfaz
    COLOR 15
    LOCATE 1, 2: PRINT "PUNTAJE: "; score
    
    PCOPY 1, 0
    _DELAY 0.03
LOOP

' Pantalla Final
CLS
COLOR 15
IF victory = 1 THEN
    LOCATE 10, 16: PRINT "¡VICTORIA!"
    PLAY "T180 O3 C4 E4 G4 O4 C2" ' Melodia de victoria
ELSE
    LOCATE 10, 14: PRINT "FIN DEL JUEGO"
    PLAY "T180 O2 C4 G8 E8 C2" ' Melodia de derrota
END IF
LOCATE 12, 12: PRINT "PUNTAJE FINAL: "; score
LOCATE 14, 5: PRINT "Presiona cualquier tecla para salir..."
PCOPY 1, 0

WHILE INKEY$ <> "": WEND
DO WHILE INKEY$ = ""
LOOP
END


SUB InitGame ()
    playerX = 150
    playerY = 175
    bulletActive = 0
    
    enemyStartX = 20
    enemyStartY = 15
    enemyDir = 2
    enemySpeed = 10
    enemyTimer = 0
    score = 0
    gameOver = 0
    victory = 0
    
    DIM r AS INTEGER, c AS INTEGER, s AS INTEGER, b AS INTEGER
    
    FOR r = 1 TO enemyRows
        FOR c = 1 TO enemyCols
            enemies(c, r) = 1
        NEXT c
    NEXT r
    
    FOR b = 1 TO 3
        eBulletActive(b) = 0
    NEXT b
    
    FOR s = 1 TO 4
        FOR r = 1 TO 3
            FOR c = 1 TO 4
                shieldHealth(s, r, c) = 1
            NEXT c
        NEXT r
        ' Remueve las esquinas superiores para darles forma curva clásica
        shieldHealth(s, 1, 1) = 0
        shieldHealth(s, 1, 4) = 0
    NEXT s
END SUB


SUB LoadSprites ()
    CLS
    
    LINE (7, 0)-(8, 4), 10, BF
    LINE (5, 5)-(10, 9), 10, BF
    LINE (1, 10)-(14, 15), 10, BF
    LINE (0, 15)-(1, 15), 10, B
    LINE (14, 15)-(15, 15), 10, B
    GET (0, 0)-(15, 15), imgPlayer
    
    CLS
    LINE (2, 0)-(13, 11), 12, BF
    LINE (4, 2)-(6, 4), 0, BF
    LINE (9, 2)-(11, 4), 0, BF
    LINE (1, 12)-(3, 15), 12, BF
    LINE (12, 12)-(14, 15), 12, BF
    LINE (6, 12)-(9, 15), 12, BF
    GET (0, 0)-(15, 15), imgEnemy
    
    CLS
    LINE (0, 0)-(1, 7), 14, BF
    GET (0, 0)-(1, 7), imgBullet
    
    CLS
    LINE (0, 0)-(1, 7), 12, BF ' Bala enemiga es roja
    GET (0, 0)-(1, 7), imgEBullet
    
    CLS
END SUB
