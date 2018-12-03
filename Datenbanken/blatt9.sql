/*
Aufgabe 9.1.a: 
Die Studenten, die 4-SWS-Vorlesungen von Sokrates hören. 

Aufgabe 9.1.b: 
Die Vorlesungen, die gar niemand hört. 

Aufgabe 9.1.c: 
Die Studenten, die sich mind einmal Vorlesungsreferent und Vorlesungsprüfer getrennt haben. 

Aufgabe 9.1.d: 
Der Professor mit den meisten kumulierten Zuhörern, wobei gleiche Studenten in unterschiedlichen Vorlesungen mehrfach zählen. 

Aufgabe 9.1.e: 
Studenten, die sich über Vorlesungen prüfen lassen, die sie (hier) gar nicht gehört haben. 

Aufgabe 9.1.f: 
Studenten, die Vorlesungen hören, für die sie gar nicht die Voraussetzungen hören. 
*/

/* Augabe 9.2.a */
SELECT prof.Name AS Professor, SUM(vl.SWS) AS Vorlesungszeit
FROM Professoren prof
LEFT OUTER JOIN Vorlesungen vl ON prof.PersNr = vl.gelesenVon
GROUP BY prof.PersNr, prof.Name
ORDER BY Vorlesungszeit DESC NULLS LAST;

/* Aufgabe 9.2.b: schlechte Studenten */
/* Studenten OHNE Prüfung werden ignoriert. */
SELECT stud.Name AS Student, MIN(pr.Note) as BesteNote
FROM studenten stud 
NATURAL JOIN prüfen pr
GROUP BY stud.MatrNr, stud.Name 
HAVING BesteNote >= 3.0;

/* Aufgabe 9.2.c: Umfang Prüfungsstoff */
SELECT stud.Name AS Student, IFNULL(SUM(vl.SWS), 0) AS Stoffmenge  
FROM studenten stud 
LEFT OUTER JOIN prüfen pr ON stud.MatrNr = pr.MatrNr 
LEFT OUTER JOIN vorlesungen vl ON pr.VorlNr = vl.VorlNr
GROUP BY stud.MatrNr, stud.Name 
ORDER BY Stoffmenge DESC; 

/* Aufgabe 9.2.d: Durchfallquote */
/* unter Verwendung: (7=7)=1, 0/0=NULL */
SELECT vl.Titel AS Vorlesung, 1.0 * SUM(pr.Note = 5.0) / COUNT(pr.Note) AS Durchfallquote  
FROM vorlesungen vl
LEFT OUTER JOIN pruefen pr ON vl.VorlNr = pr.VorlNr 
GROUP BY vl.VorlNr, vl.Titel;

/* HYPER */
SELECT vl.Titel AS Vorlesung, (CASE 
      WHEN COUNT(pr.Note) = 0 
	  THEN NULL 
	  ELSE (1.0 * SUM(CASE 
	      WHEN pr.Note = 5.0 
		  THEN 1 
		  ELSE 0 
		  END
		  )) / COUNT(pr.Note) 
	  END
	  ) AS Durchfallquote  
FROM vorlesungen vl
LEFT OUTER JOIN pruefen pr ON vl.VorlNr = pr.VorlNr 
GROUP BY vl.VorlNr, vl.Titel;

/* Alternativ */
SELECT vl.Titel AS Vorlesung, SUM(pr.Fails) AS Fails, COUNT(pr.Note) AS Proben, 1.0 * SUM(pr.Fails) / COUNT(pr.Note) AS Durchfallquote 
FROM vorlesungen vl
LEFT OUTER JOIN (
    SELECT pp.VorlNr AS VorlNr, 
           pp.Note AS Note, 
           (CASE WHEN pp.Note = 5 THEN 1 ELSE 0 END) AS Fails
    FROM prüfen pp
    WHERE pp.Note IS NOT NULL
) AS pr ON pr.VorlNr = vl.VorlNr
GROUP BY vl.VorlNr, vl.Titel; 

/* Aufgabe 9.2.e: Durchfallquote */
SELECT prof.Name AS Professor, 1.0 * SUM(pr.Note = 5.0) / COUNT(pr.Note) AS Durchfallquote  
FROM professoren prof
LEFT OUTER JOIN pruefen pr ON prof.PersNr = pr.PersNr 
GROUP BY prof.PersNr, prof.Name; 

/* Aufgabe 9.2.f: Bekanntheitsgrad */
SELECT prof.Name AS Professor, COUNT(Besuche.MatrNr)  
FROM professoren prof
JOIN (
  SELECT h.MatrNr AS MatrNr, vl.gelesenVon AS PersNr  
  FROM hoeren h 
  NATURAL JOIN vorlesungen vl 
  UNION 
  SELECT pr.MatrNr AS MatrNr, pr.PersNr AS PersNr 
  FROM prüfen pr
) AS besuche ON besuche.PersNr = prof.PersNr
GROUP BY prof.PersNr; 

/* Aufgabe 9.3.a: Professoren mit VL */
SELECT prof.Name AS Professor 
FROM professoren prof 
WHERE prof.PersNr = ANY (SELECT vl.gelesenVon FROM vorlesungen vl); 

SELECT DISTINCT prof.Name AS Professor 
FROM professoren prof 
JOIN vorlesungen vl ON prof.PersNr = vl.gelesenVon; 

SELECT prof.Name AS Professor 
FROM professoren prof 
WHERE prof.PersNr IN (SELECT vl.gelesenVon FROM vorlesungen vl); 

/* Aufgabe 9.3.b: Längster Student */
SELECT stud.Name AS Student 
FROM studenten stud 
WHERE stud.Semester = (SELECT MAX(Semester) FROM studenten);

SELECT stud.Name AS Student 
FROM studenten stud 
WHERE stud.Semester = (SELECT Semester FROM studenten ORDER BY Semester DESC LIMIT 1);

/* Aufgabe 9.3.c: Alle 4h VL - mit WHERE NOT EXISTS */
SELECT stud.Name AS Student 
FROM studenten stud 
WHERE NOT EXISTS (
  SELECT vl.VorlNr 
  FROM vorlesungen vl 
  WHERE vl.SWS = 4 
  EXCEPT 
  SELECT vl.VorlNr 
  FROM vorlesungen vl 
  NATURAL JOIN hoeren h
  WHERE vl.SWS = 4 
  AND stud.MatrNr = h.MatrNr  
); 

/* Alternativ mit COUNT */
SELECT stud.Name AS Student  
FROM studenten stud 
LEFT OUTER JOIN hoeren h ON stud.MatrNr = h.MatrNr 
LEFT OUTER JOIN vorlesungen vl ON h.VorlNr = vl.VorlNr 
WHERE vl.SWS = 4 
GROUP BY stud.MatrNr, stud.Name
HAVING COUNT(DISTINCT h.VorlNr) >= (
    SELECT COUNT(vlAll.VorlNr) 
    FROM vorlesungen vlAll
    WHERE vlAll.SWS = 4
);    

/* Aufgabe 9.3.d: jede VL geprüft */ 
SELECT stud.Name AS Student 
FROM studenten stud 
WHERE NOT EXISTS (
    SELECT h.VorlNr 
    FROM hoeren h 
    WHERE h.MatrNr = stud.MatrNr 
    EXCEPT 
    SELECT pr.VorlNr 
    FROM pruefen pr 
    WHERE pr.MatrNr = stud.MatrNr    
); 

/* Aufgabe 9.3.e: hoeren gut? */ 
SELECT AVG(q1.Note) AS Durchschnittsnote, q1.gehoert, COUNT(*) AS AnzahlTestPersonen
FROM (
  SELECT pr.Note, IFNULL((h.MatrNr + 1 - h.MatrNr), 0) AS gehoert
  FROM pruefen pr 
  LEFT OUTER JOIN hoeren h ON h.VorlNr = pr.VorlNr AND h.MatrNr = pr.MatrNr 
  WHERE pr.Note IS NOT NULL 
) AS q1    
GROUP BY q1.gehoert;

/* Aufgabe 9.3.f: hoeren gut? */ 
INSERT INTO hoeren(MatrNr, VorlNr) 
  SELECT stud.MatrNr, vl.VorlNr
  FROM studenten stud
  CROSS JOIN vorlesungen vl 
  JOIN professoren prof ON prof.PersNr = vl.gelesenVon
  WHERE prof.Name = 'Sokrates'
  AND NOT EXISTS (
    SELECT * FROM hoeren hh WHERE hh.MatrNr = stud.MatrNr AND hh.VorlNr = vl.VorlNr   
  );
  
/* Aufgabe 9.4.a */
DROP VIEW IF EXISTS TNS; 
CREATE VIEW TNS AS 
SELECT film.title AS Title, kritiker.name AS Kritiker, wertung.stars AS Stars
FROM movie film
LEFT OUTER JOIN rating wertung ON film.mID = wertung.mID
LEFT OUTER JOIN reviewer kritiker ON kritiker.rID = wertung.rID; 

SELECT m.title AS Film, MAX(m.year) AS Erstausstrahlung
FROM TNS t
JOIN movie m ON m.title = t.Title 
WHERE t.Kritiker="Chris Jackson" 
GROUP BY m.title;  

/* Aufgabe 9.4.b */
DROP VIEW IF EXISTS RatingStats; 
CREATE VIEW RatingStats AS 
SELECT t.Title AS Title, COUNT(t.Stars) AS AnzahlWertungen, AVG(t.Stars) AS Rating
FROM TNS t
GROUP BY t.Title 
HAVING AnzahlWertungen > 0; 

SELECT * 
FROM RatingStats r 
WHERE r.AnzahlWertungen >= 3 
AND r.Rating = (SELECT MAX(Rating) FROM RatingStats WHERE AnzahlWertungen >= 3);   

/* Aufgabe 9.4.c: Favorites */
DROP VIEW IF EXISTS Favorites; 
CREATE VIEW Favorites AS 
SELECT DISTINCT w.rID, w.mID
FROM rating w 
JOIN rating wm ON w.rID = wm.rID 
GROUP BY w.rID, w.mID, w.stars 
HAVING w.stars = MAX(wm.stars);

SELECT r1.name AS Kritiker1, r2.name AS Kritiker2, mov.title AS FILM
FROM Favorites f1 
JOIN Favorites f2 ON f1.mID = f2.mID 
JOIN movie mov ON mov.mID = f2.mID 
JOIN reviewer r1 ON r1.rID = f1.rID 
JOIN reviewer r2 ON r2.rID = f2.rID 
WHERE f1.rID < f2.rID;

