/* Aufgabe X-MAS 11: Alle Profs (Namen), die gelehrt haben. */ 
SELECT DISTINCT prof.Name AS Professor 
FROM professor prof 
JOIN transcript pr ON pr.pid = prof.pid;  

/* Aufgabe X-MAS 12: Alle Profs (Namen, Titel), die gelehrt haben. */ 
SELECT prof.Name AS Professor, vl.title AS Vorlesung 
FROM professor prof 
LEFT OUTER JOIN transcript pr ON pr.pid = prof.pid 
LEFT OUTER JOIN course vl ON vl.cid = pr.cid
ORDER BY Professor ASC; 

/* Aufgabe X-MAS 13: Alle Informatik-/Informationstechnik-Studenten (id). */ 
SELECT stud.sid AS MatrNr  
FROM student stud 
WHERE stud.major='IT' OR stud.major='CS' 
ORDER BY stud.name ASC; 

/* Aufgabe X-MAS 14: Alle Professoren (Namen) 2009-2010. */ 
SELECT DISTINCT prof.Name AS Professor 
FROM professor prof 
JOIN transcript pruef ON prof.pid = pruef.pid 
WHERE pruef.year BETWEEN 2009 AND 2010 
ORDER BY Professor ASC; 

/* Aufgabe X-MAS 15: Alle Professoren (Namen) 2009+2010. */ 
SELECT prof.Name AS Professor 
FROM professor prof 
JOIN transcript pruef ON prof.pid = pruef.pid 
GROUP BY prof.pid, prof.name 
HAVING SUM(pruef.year=2009) > 0 AND SUM(pruef.year=2010) > 0  -- using TRUE=1, FALSE=0
ORDER BY Professor ASC; 

/* Aufgabe X-MAS 16: Alle Professoren (Namen) Database+AdvancedDatabase, 2009. */ 
SELECT prof.Name AS Professor 
FROM professor prof 
JOIN transcript pruef ON prof.pid = pruef.pid 
JOIN course vl ON vl.cid = pruef.cid 
WHERE pruef.year = 2009
GROUP BY prof.pid, prof.name 
HAVING SUM(vl.title='Database') > 0 AND SUM(vl.title='Advanced Database') > 0  -- using TRUE=1, FALSE=0
ORDER BY Professor ASC; 

/* Aufgabe X-MAS 17: Alle Kurse (Titel) -204 */ 
SELECT vl.title as Kurs 
FROM transcript pruef 
RIGHT OUTER JOIN course vl ON vl.cid = pruef.cid 
GROUP BY vl.cid, vl.title 
HAVING SUM(pruef.pid=204) = 0 -- using TRUE=1, FALSE=0
ORDER BY Kurs ASC; 

/* Aufgabe X-MAS 18: Alle Professoren (Name) -IT */ 
SELECT prof.name as Professor 
FROM professor prof 
WHERE prof.pid NOT IN (
  SELECT DISTINCT t.pid 
  FROM transcript t 
  JOIN student stud ON stud.sid = t.sid 
  WHERE stud.major = 'IT'
)
ORDER BY Professor;

/* Aufgabe X-MAS 19: Alle -Kurse Herbst2009 */ 
SELECT vl.* 
FROM transcript t 
JOIN course vl ON vl.cid = t.cid 
GROUP BY vl.cid -- ggf. vl.* 
HAVING sum((t.semester = 'Fall') AND (t.year = 2009)) = 0  -- using TRUE=1 
ORDER BY vl.title ASC;

/* Aufgabe X-MAS 20: Professoren (id) +alle DB Kurse */ 
SELECT t.pid 
FROM transcript t 
JOIN course vl ON vl.cid = t.cid 
WHERE vl.title LIKE '%_atabase%' 
GROUP BY t.pid 
HAVING COUNT(DISTINCT t.cid) = (
    SELECT COUNT(*) 
    FROM course 
    WHERE title LIKE '%_atabase%'
)
ORDER BY t.pid ASC;

/* Aufgabe X-MAS 20: Professoren (id) +alle DB Kurse */ 
SELECT t.pid 
FROM transcript t 
JOIN course vl ON vl.cid = t.cid 
WHERE vl.title LIKE '%_atabase%' 
GROUP BY t.pid 
HAVING COUNT(DISTINCT t.cid) = (
    SELECT COUNT(*) 
    FROM course 
    WHERE title LIKE '%_atabase%'
)
ORDER BY t.pid ASC;

/* Aufgabe X-MAS 21: Studenten (Name) +alle INTRO */ 
-- assumption: there is at least one intro coure 
SELECT stud.name as Student 
FROM student stud 
JOIN transcript t ON stud.sid = t.sid
JOIN course vl ON vl.cid = t.cid 
WHERE vl.area = 'INTRO' 
GROUP BY t.sid 
HAVING COUNT(DISTINCT t.cid) = (
    SELECT COUNT(*) 
    FROM course 
    WHERE area = 'INTRO'
)
ORDER BY Student ASC; 

/* Aufgabe X-MAS 22: Alle Professoren (id) +alle Kurse */ 
-- assumption: there is at least one course 
SELECT t.pid  
FROM transcript t 
GROUP BY t.pid 
HAVING COUNT(DISTINCT t.cid) = (
    SELECT COUNT(*) 
    FROM course 
); 

/* Aufgabe X-MAS 23: Alle Professoren (id) +2 Kurse */ 
SELECT t.pid  
FROM transcript t 
GROUP BY t.pid 
HAVING COUNT(DISTINCT t.cid) > 1; 

/* Aufgabe X-MAS 24: Alle Professoren (id) +max 2 Kurse */ 
SELECT prof.pid  
FROM transcript t 
RIGHT OUTER JOIN professor prof ON prof.pid = t.pid 
GROUP BY prof.pid 
HAVING COUNT(DISTINCT t.cid) <= 2; 

/* Aufgabe X-MAS 25: Anzahl Kurse im Herbst 2009 */ 
SELECT COUNT(DISTINCT t.cid) 
FROM transcript t 
WHERE t.semester = 'Fall' 
AND t.year = 2009;  
-- answer is 4 

/* Aufgabe X-MAS 26: Anzahl Kurse pro Semester */ 
SELECT t.year, t.semester, COUNT(DISTINCT t.cid) AS Anzahl 
FROM transcript t 
GROUP BY t.year, t.semester 
ORDER BY t.year ASC, t.semester DESC; 

/* Aufgabe X-MAS 27: Credits of a student */ 
SELECT SUM(c.credits) AS Punkte 
FROM transcript t 
JOIN course c ON c.cid = t.cid 
WHERE t.sid = 101 
AND t.grade IN ('A', 'B', 'C', 'D');

/* Aufgabe X-MAS 28: Credits of a student */ 
SELECT stud.sid, stud.name, SUM(c.credits) AS Punkte 
FROM student stud 
JOIN transcript t ON stud.sid = t.sid 
JOIN course c ON c.cid = t.cid 
WHERE t.grade IN ('A', 'B', 'C', 'D') 
GROUP BY stud.sid, stud.name 
ORDER BY Punkte DESC; 

/* Aufgabe X-MAS 29: Max Credits */ 
-- random at a draw 
SELECT stud.sid, stud.name, SUM(c.credits) AS Punkte 
FROM student stud 
JOIN transcript t ON stud.sid = t.sid 
JOIN course c ON c.cid = t.cid 
WHERE t.grade IN ('A', 'B', 'C', 'D') 
GROUP BY stud.sid, stud.name 
ORDER BY Punkte DESC
LIMIT 1; 

-- all at a draw 


/* Aufgabe X-MAS 30: 2nd Max Credits */ 
-- random at a draw 
SELECT stud.sid, stud.name, SUM(c.credits) AS Punkte 
FROM student stud 
JOIN transcript t ON stud.sid = t.sid 
JOIN course c ON c.cid = t.cid 
WHERE t.grade IN ('A', 'B', 'C', 'D') 
GROUP BY stud.sid, stud.name 
ORDER BY Punkte DESC
LIMIT 1 OFFSET 2; 