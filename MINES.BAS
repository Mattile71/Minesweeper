DECLARE SUB tuplaklik (startx, starty, counter)
DECLARE SUB havio ()
DECLARE FUNCTION Onsisalla% (x!, y!)
DECLARE SUB voitto ()
DECLARE SUB tulosta (x!, y!)
DECLARE SUB luokartta (xkoko!, ykoko!)
DIM SHARED kartta(10, 10)
DIM SHARED maski(10, 10)
COMMON SHARED pommimaara, aika, curx, cury

COLOR 7
curx = 1: vanhax = 1
cury = 1: vanhay = 1
pommimaara = 10
aika = 0
CLS
luokartta 10, 10
ON TIMER(1) GOSUB ajastin
TIMER ON
WHILE a$ <> CHR$(27)
   LOCATE cury, curx * 2
   PRINT "h"
  
   DO
     a$ = INKEY$
   LOOP UNTIL a$ <> ""
   IF a$ = CHR$(0) + "M" AND curx < 10 THEN curx = curx + 1
   IF a$ = CHR$(0) + "H" AND cury > 1 THEN cury = cury - 1
   IF a$ = CHR$(0) + "K" AND curx > 1 THEN curx = curx - 1
   IF a$ = CHR$(0) + "P" AND cury < 10 THEN cury = cury + 1
   IF a$ = " " THEN
      maski(curx, cury) = 1: tulosta curx, cury
      IF kartta(curx, cury) = -1 THEN CALL havio
   END IF
   IF a$ = "d" THEN CALL tuplaklik(curx, cury, 2)

   IF a$ = "p" THEN
      IF kartta(curx, cury) = -1 AND maski(curx, cury) <> -1 THEN
         pommimaara = pommimaara - 1
         maski(curx, cury) = -1
         IF pommimaara = 0 THEN CALL voitto
      ELSEIF kartta(curx, cury) <> -1 THEN CALL havio
      END IF
   END IF


   IF curx <> vanhax OR cury <> vanhay THEN
      LOCATE vanhay, vanhax * 2
      tulosta vanhax, vanhay
      
      vanhax = curx
      vanhay = cury
   END IF
               
WEND

END

ajastin:
LOCATE 15, 1
aika = aika + 1
PRINT aika
RETURN

SUB havio
PRINT "h„visit !"
END
END SUB

SUB luokartta (xkoko, ykoko)
RANDOMIZE TIMER

FOR i = 1 TO 10
   x = INT(RND * xkoko) + 1
   y = INT(RND * ykoko) + 1
   IF kartta(x, y) = -1 THEN i = i - 1 ELSE kartta(x, y) = -1
NEXT i

FOR j = 1 TO 10
   FOR i = 1 TO 10

      pommilaskin = 0
      IF kartta(i, j) = 0 THEN
         FOR k = j - 1 TO j + 1
            FOR h = i - 1 TO i + 1
               IF Onsisalla%(h, k) THEN
                  IF kartta(h, k) = -1 THEN pommilaskin = pommilaskin + 1
               END IF
            NEXT h
         NEXT k
         kartta(i, j) = pommilaskin
      END IF

   NEXT i
NEXT j

FOR j = 1 TO 10
   FOR i = 1 TO 10
      REM IF kartta(i, j) = -1 THEN PRINT " p";  ELSE PRINT STR$(kartta(i, j));
      PRINT " *";
   NEXT i
   PRINT
NEXT j

END SUB

FUNCTION Onsisalla% (x, y)
IF x >= 1 AND x <= 10 AND y >= 1 AND y <= 10 THEN
   Onsisalla% = 1
ELSE
   Onsisalla% = 0
END IF
END FUNCTION

SUB tulosta (x, y)
   LOCATE y, x * 2
   IF maski(x, y) = 0 THEN PRINT "*": EXIT SUB
   IF maski(x, y) = -1 THEN COLOR 4: PRINT "p": COLOR 7: EXIT SUB

   SELECT CASE kartta(x, y)
      CASE 1: COLOR 9
      CASE 2: COLOR 10
      CASE 3: COLOR 12
      CASE 4: COLOR 1
   END SELECT

   PRINT LTRIM$(STR$(kartta(x, y)));
   COLOR 7
END SUB

SUB tuplaklik (startx, starty, counter)
IF counter = 0 THEN EXIT SUB
maski(startx, starty) = 1
IF kartta(startx, starty) = -1 THEN CALL havio
tulosta startx, starty
plaskuri = 0

FOR j = starty - 1 TO starty + 1
   FOR i = startx - 1 TO startx + 1
      IF Onsisalla(i, j) THEN
         IF maski(i, j) = -1 THEN plaskuri = plaskuri + 1
      END IF
   NEXT i
NEXT j
IF plaskuri <> kartta(startx, starty) THEN EXIT SUB


FOR j = starty - 1 TO starty + 1
   FOR i = startx - 1 TO startx + 1
      IF Onsisalla(i, j) AND NOT (i = startx AND j = starty) THEN
         IF maski(i, j) = 0 AND kartta(i, j) = 0 THEN CALL tuplaklik(i, j, counter - 1)
         IF kartta(i, j) = -1 AND maski(i, j) <> -1 THEN CALL havio
         IF kartta(i, j) >= 0 THEN
            IF maski(i, j) = 0 THEN maski(i, j) = 1: tulosta i, j
         END IF

      END IF
   NEXT i
NEXT j

END SUB

SUB voitto
CLS
TIMER OFF
PRINT "Voitit !!!"
PRINT "Ajalla:"; aika

OPEN "parhaat.txt" FOR INPUT AS #1
INPUT #1, nimi$
INPUT #1, arvo
CLOSE #1

IF arvo > aika THEN
   PRINT "P„„sit listoille !"
   OPEN "parhaat.txt" FOR OUTPUT AS #1
   INPUT "Mik„ on nimesi"; a$
   PRINT #1, a$
   PRINT #1, aika
   CLOSE #1
END IF


END
END SUB

