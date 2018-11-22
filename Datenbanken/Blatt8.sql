/* Aufgabe 8.1.a: Vorlesungstitel Kant */
SELECT vl.Titel 
FROM vorlesungen vl
JOIN professoren prof ON vl.gelesenVon = prof.PersNr 
WHERE prof.Name = "Kant";  

/* Aufgabe 8.1.b: Kant's Studenten */
SELECT DISTINCT stud.Name
FROM studenten stud 
NATURAL JOIN hoeren h 
NATURAL JOIN vorlesungen vl 
JOIN professoren prof ON vl.gelesenVon = prof.PersNr 
WHERE prof.Name = "Kant"; 

/* Aufgabe 8.1.c: Kant's gepruefte Studenten */
SELECT stud.Name, pr.Note 
FROM studenten stud 
NATURAL JOIN pruefen pr 
JOIN professoren prof ON pr.PersNr = prof.PersNr 
WHERE prof.Name = "Kant"; 

/* Aufgabe 8.1.d: Ueber Kant gepruefte Studenten */
SELECT stud.Name, pr.Note 
FROM studenten stud 
JOIN pruefen pr ON stud.MatrNr = pr.MatrNr 
JOIN hoeren h ON h.MatrNr = stud.MatrNr 
JOIN vorlesungen vl ON vl.VorlNr = h.VorlNr 
JOIN professoren prof ON vl.gelesenVon = prof.PersNr 
WHERE prof.Name = "Kant";

/* Aufgabe 8.2.a: Studentenarbeit */
SELECT stud.Name AS Student, SUM(vl.SWS) as Wochenarbeitsstunden
FROM studenten stud 
JOIN hoeren h ON h.MatrNr = stud.MatrNr 
JOIN vorlesungen vl ON vl.VorlNr = h.VorlNr 
GROUP BY stud.MatrNr, stud.Name;  

/* Aufgabe 8.2.c.a: Studentenarbeit */
SELECT stud.Name AS Student, IFNULL(SUM(vl.SWS),0) as Wochenarbeitsstunden
FROM studenten stud 
LEFT OUTER JOIN hoeren h ON h.MatrNr = stud.MatrNr 
LEFT OUTER JOIN vorlesungen vl ON vl.VorlNr = h.VorlNr 
GROUP BY stud.MatrNr, stud.Name;  

/* Aufgabe 8.2.b: Professorenarbeit */
SELECT prof.Name as Professor, COUNT(DISTINCT h.MatrNr) FROM professoren prof 
JOIN vorlesungen vl ON vl.gelesenVon = prof.PersNr
JOIN hoeren h ON h.VorlNr = vl.VorlNr 
GROUP BY prof.PersNr, prof.Name; 

/* Aufgabe 8.2.c.b: Professorenarbeit */
SELECT prof.Name as Professor, COUNT(DISTINCT h.MatrNr) FROM professoren prof 
LEFT OUTER JOIN vorlesungen vl ON vl.gelesenVon = prof.PersNr
LEFT OUTER JOIN hoeren h ON h.VorlNr = vl.VorlNr 
GROUP BY prof.PersNr, prof.Name; 

/* Aufgabe 8.3: NULL-Werte */
/* a: Die Professoren, die keine Vorlesung lesen. */ 
/* b: In der oberen Abfrage liefert die Subquery u.a. einen null-Wert, also prüft die Abfrage bei mind. einem NULL-Wert 
 *    WHERE PersNr NOT IN (null, ...) und das ist NOT (TRUE oder UNKNOWN) und das ist nur FALSE oder UNKNOWN. Das Ergebnis ist leer. 
/* c: Die obere, unkorrellierte Abfrage muss nur einmal das Subquery ausführen, die untere muss pro Professor einmal das Subquery ausführen. */ 

/* Aufgabe 8.4: Recursive */
WITH RECURSIVE maze AS (
  SELECT e.n1 AS x1, e.n2 AS x2, e.weight AS distance
  FROM edge e 
  JOIN node nod ON nod.nid = e.n2 
  WHERE nod.color = 'red'
	UNION ALL 
  SELECT e1.n1 AS x1, maze.x2 AS x2, (e1.weight + maze.distance) AS distance
  FROM edge e1 CROSS JOIN maze
  WHERE maze.x1 = e1.n2
)
SELECT DISTINCT y1.nid AS von, y2.nid AS nach --, maz.distance AS distanz
FROM maze maz 
JOIN node y1 ON y1.nid = maz.x1 
JOIN node y2 ON y2.nid = maz.x2
WHERE y1.color = 'red' 
ORDER BY von ASC;


/* Aufgabe 8.4.c */
WITH RECURSIVE maze AS (
  SELECT e.n1 AS x1, e.n2 AS x2, e.weight AS distance
  FROM edge e 
  JOIN node nod ON nod.nid = e.n1 
  WHERE nod.color = 'red'
	UNION ALL 
  SELECT maze.x1 AS x1, e1.n2 AS x2, (e1.weight + maze.distance) AS distance
  FROM maze 
  CROSS JOIN edge e1 
  WHERE maze.x2 = e1.n1
)
SELECT DISTINCT y1.nid AS von, y2.nid AS nach --, maz.distance AS distanz
FROM maze maz 
JOIN node y1 ON y1.nid = maz.x1 
JOIN node y2 ON y2.nid = maz.x2
WHERE y2.color = 'red' 
ORDER BY von ASC;

/* Aufgabe 8.4.d:  */
WITH RECURSIVE maze AS (
  SELECT e.n1 AS x1, e.n2 AS x2, e.weight AS distance
  FROM edge e 
  JOIN node nod ON nod.nid = e.n2 
  WHERE nod.color = 'red'
	UNION ALL 
  SELECT e1.n1 AS x1, maze.x2 AS x2, (e1.weight + maze.distance) AS distance
  FROM edge e1 CROSS JOIN maze
  WHERE maze.x1 = e1.n2
)
SELECT y1.nid AS von, y2.nid AS nach, MIN(maz.distance) AS min_distanz, MAX(maz.distance) AS max_distanz
FROM maze maz 
JOIN node y1 ON y1.nid = maz.x1 
JOIN node y2 ON y2.nid = maz.x2
WHERE y1.color = 'red' 
GROUP BY y1.nid, y2.nid 
ORDER BY y1.nid ASC, min_distanz DESC;

