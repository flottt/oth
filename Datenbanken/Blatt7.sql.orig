/* Aufgabe 7.1.a: Studenten mit Ethikprüfung */
SELECT s.Name AS Student 
FROM vorlesungen v 
NATURAL JOIN pruefen p 
NATURAL JOIN studenten s 
WHERE v.Titel = 'Ethik' 
AND p.Note IS NOT NULL 
ORDER BY Student ASC; 


/* Aufgabe 7.1.b: Carnaps Pruefungen */
SELECT vl.Titel AS Vorlesung, p.Note AS Note 
FROM studenten s
NATURAL JOIN pruefen p 
NATURAL JOIN vorlesungen vl 
WHERE s.Name = 'Carnap'; 


/* Aufgabe 7.1.c: Profs mit 2 Vorlesungen */
SELECT prof.Name AS Professor 
FROM professoren prof 
WHERE prof.PersNr IN (
  SELECT v1.gelesenVon AS PersNr 
  FROM vorlesungen v1 
  JOIN vorlesungen v2 ON v1.gelesenVon = v2.gelesenVon
  WHERE v1.VorlNr <> v2.VorlNr    
); 


/* Aufgabe 7.1.d: Studenten besser als Jonas */
/* zum Testen Beispiele mit Ethikpruefungen */
INSERT INTO pruefen (MatrNr, VorlNr, PersNr, Note) VALUES 
(10020, 5041, 1001, 1.3), 
(10030, 5041, 1001, 3.0), 
(10040, 5041, 1001, NULL), 
(10050, 5041, 1001, 2.0), 
(28106, 5041, 2125, 5.0) 
ON DUPLICATE KEY UPDATE Note=Note; 

SELECT s.Name AS Student 
FROM studenten s 
WHERE s.MatrNr IN (
  SELECT pruef.MatrNr 
  FROM studenten studJonas
  JOIN pruefen pruefJonas ON studJonas.MatrNr = pruefJonas.MatrNr 
  JOIN vorlesungen vlEthik ON pruefJonas.VorlNr = vlEthik.VorlNr 
  JOIN pruefen pruef ON pruef.VorlNr = pruefJonas.VorlNr 
  WHERE pruef.Note <= pruefJonas.Note 
  AND pruef.MatrNr <> pruefJonas.MatrNr 
  AND studJonas.Name = 'Jonas' 
  AND vlEthik.Titel = 'Ethik' 
); 

/* Aufgabe 7.2.a: Anzahl Ethik Studenten */
SELECT COUNT(*) AS anzahlEthiker 
FROM pruefen p 
NATURAL JOIN vorlesungen vl 
WHERE vl.Titel = 'Ethik' 
AND p.Note IS NOT NULL; 


/* Aufgabe 7.2.b: Vorlesungs-AVG-Noten */
SELECT vl.Titel AS Vorlesung, AVG(p.Note) AS Durchschnittsnote 
FROM vorlesungen vl 
LEFT OUTER JOIN pruefen p ON vl.VorlNr = p.VorlNr 
GROUP BY vl.VorlNr 
ORDER BY Vorlesung ASC; 


/* Aufgabe 7.2.c: Professoren mit 2 VL */
SELECT prof.Name AS Professor 
FROM professoren prof 
JOIN vorlesungen vl ON prof.PersNr = vl.gelesenVon 
GROUP BY prof.PersNr 
HAVING COUNT(*) >= 2; 


/* Aufgabe 7.2.d: Professors Gesamtnote */
SELECT AVG(p.Note) AS Durchschnittsnote 
FROM professoren prof 
JOIN vorlesungen vl ON prof.PersNr = vl.gelesenVon 
JOIN pruefen p ON p.PersNr = prof.PersNr; 




/* Aufgabe 7.3: Median */
SELECT AVG(pp.Note)
FROM (
    SELECT p.Note, @x := @x + 1 as laufendeZahl
    FROM pruefen p, (SELECT @x := 0) as spam
    WHERE p.Note /*IS NOT NULL*/
    ORDER BY p.Note
) AS pp 
WHERE @x <= pp.laufendeZahl * 2 
AND pp.laufendeZahl * 2 <= @x + 1

/* or worse: */
SELECT ppp.Note 
FROM (
  SELECT pp.Note, @x := @x + pp.anzahlNote as anzahlKum  
  FROM (
    SELECT p.Note, COUNT(p.Note) as anzahlNote 
    FROM pruefen p
    GROUP BY p.Note
    ORDER BY p.Note
  ) AS pp, (SELECT @x := 0) as ppx
) AS ppp
WHERE ppp.anzahlKum >= @x/2 
LIMIT 1;


/* Aufgabe 7.4: Durchfaller mit Nullen */
/* In der Tabelle pruefen werden die Datensätze ausgewertet. 
 * Die ersten beiden Zeilen disqualifizieren sich: (NULL <= 4.0) ergibt UNKNOWN; Dann NOT (UNKNOWN) ergibt UNKNOWN und somit nicht TRUE. 
 * Die dritte Zeile disqualifiziert sich: (1.0 <= 4.0) ergibt TRUE; Dann NOT (TRUE) ergibt FALSE und somit nicht TRUE. 
 * Die vierte Zeile kommt ins Ergebnis: (5.0 <= 4.0) ergibt FALSE; Dann NOT (FALSE) ergibt TRUE und somit im Ergebnis. 
 * Die Duplikatentfernung "DISTINCT" verändert nichts mehr. */
SELECT DISTINCT p.MatrNr 
FROM pruefen p 
WHERE p.Note IS NULL 
OR p.Note > 4; 


/* Aufgabe 7.5.a: Studienprüfungsordnungen */
/* eventuell hatte die Spalte Semester NULL-Werte. 
 * Diese wurden in keiner der beiden Updates erfasst. 
 * Lösungsvorschläge: 
 * - default-Value beim ALTER TABLE setzen. 
 * - Spalte Semester als NOT NULL setzen. 
 * - kein WHERE im Update, sondern SET SPO = (CASE WHEN Semester >= 5 THEN 'alteSPO' ELSE 'neueSPO' END); */
 
 /* Aufgabe 7.5.b: Anteile */
SELECT stud.SPO AS spo, COUNT(stud.SPO) / gesamt.gesamt AS anteil   
FROM studentenneu stud 
CROSS JOIN (SELECT COUNT(SPO) AS gesamt FROM studentenneu) AS gesamt 
GROUP BY stud.SPO