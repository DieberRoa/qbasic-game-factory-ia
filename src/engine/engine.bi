' engine.bi - Definiciones del motor
DECLARE SUB DrawSpriteFromData (spriteArray() AS INTEGER, w AS INTEGER, h AS INTEGER)
DECLARE SUB InitEngine ()
DECLARE FUNCTION CheckCollision (x1 AS SINGLE, y1 AS SINGLE, w1 AS INTEGER, h1 AS INTEGER, x2 AS SINGLE, y2 AS SINGLE, w2 AS INTEGER, h2 AS INTEGER)

TYPE GameObject
    x AS SINGLE
    y AS SINGLE
    vx AS SINGLE
    vy AS SINGLE
    w AS INTEGER
    h AS INTEGER
    isGrounded AS INTEGER
    state AS INTEGER     ' 0=Idle, 1=Run, 2=Jump
    frame AS INTEGER
    animTimer AS INTEGER
    dir AS INTEGER       ' 1=Right, -1=Left
END TYPE

TYPE Platform
    x AS SINGLE
    y AS SINGLE
    w AS INTEGER
    h AS INTEGER
END TYPE

TYPE Projectile
    active AS INTEGER
    x AS SINGLE
    y AS SINGLE
    vx AS SINGLE
    vy AS SINGLE
    life AS INTEGER
END TYPE

DIM SHARED player AS GameObject
DIM SHARED platforms(10) AS Platform
DIM SHARED numPlatforms AS INTEGER
DIM SHARED bullets(10) AS Projectile

DIM SHARED gravity AS SINGLE
DIM SHARED friction AS SINGLE
DIM SHARED jumpForce AS SINGLE

DIM SHARED camX AS SINGLE
DIM SHARED camY AS SINGLE
