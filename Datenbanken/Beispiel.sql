DROP DATABASE IF EXISTS oth_example_db;
CREATE DATABASE oth_example_db; 
USE oth_example_db; 

/*
DROP TABLE IF EXISTS pruefen; 
DROP TABLE IF EXISTS hoeren; 
DROP TABLE IF EXISTS voraussetzen; 
DROP TABLE IF EXISTS assistenten; 
DROP TABLE IF EXISTS vorlesungen;
DROP TABLE IF EXISTS professoren; 
DROP TABLE IF EXISTS studenten;  
*/

/* Entity Professoren */
CREATE TABLE professoren ( 
  PersNr INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(30) NOT NULL, 
  Rang VARCHAR(2) NOT NULL, 
  Raum INT NOT NULL 
);


INSERT INTO professoren (PersNr, Name, Rang, Raum) VALUES 
  (2125, 'Sokrates', 'C4', 226), 
  (2126, 'Russel', 'C4', 232), 
  (2127, 'Kopernikus', 'C3', 310), 
  (2133, 'Popper', 'C3', 52),
  (2134, 'Augustinus', 'C3', 309),
  (2136, 'Curie', 'C4', 36),
  (2137, 'Kant', 'C4', 7);
  
ALTER TABLE professoren AUTO_INCREMENT = 2138; 

/* Entity Studenten */
CREATE TABLE studenten ( 
  MatrNr INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  Name VARCHAR(30) NOT NULL, 
  Semester INT NOT NULL 
);

INSERT INTO studenten (MatrNr, Name, Semester) VALUES
  (24002, 'Xenokrates', 18), 
  (25403, 'Jonas', 12), 
  (26120, 'Fichte', 10), 
  (26830, 'Aristoxenos', 8), 
  (27550, 'Schopenhauer', 6), 
  (28106, 'Carnap', 3), 
  (29120, 'Theophrastos', 2), 
  (29555, 'Feuerbach', 2); 

ALTER TABLE studenten AUTO_INCREMENT = 29556;

/* Entity Vorlesungen */
CREATE TABLE vorlesungen (
  VorlNr INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  Titel VARCHAR(255) NOT NULL,  
  SWS int NOT NULL, 
  gelesenVon INT UNSIGNED NOT NULL, 
  CONSTRAINT fkVorlesungenGelesenVon FOREIGN KEY (gelesenVon) REFERENCES professoren(PersNr) 
    ON DELETE RESTRICT 
);   

INSERT INTO vorlesungen (VorlNr, Titel, SWS, gelesenVon) VALUES 
  (5001, 'Grundzuege', 4, 2137), 
  (5041, 'Ethik', 4, 2125), 
  (5043, 'Erkenntnistheorie', 3, 2126), 
  (5049, 'Maeeutik', 2, 2125), 
  (4052, 'Logik', 4, 2125), 
  (5052, 'Wissenschaftstheorie', 3, 2126), 
  (5216, 'Bioethik', 2, 2126), 
  (5259, 'Der Wiener Kreis', 2, 2133), 
  (5022, 'Glaube und Wissen', 2, 2134), 
  (4630, 'Die 3 Kritiken', 4, 2137); 

ALTER TABLE vorlesungen AUTO_INCREMENT = 5260; 

/* Relation-Entity voraussetzen */
CREATE TABLE voraussetzen (
  Vorgaenger INT UNSIGNED NOT NULL, 
  Nachfolger INT UNSIGNED NOT NULL, 
  PRIMARY KEY (Vorgaenger, Nachfolger), 
  CONSTRAINT fkvoraussetzenVorgaenger FOREIGN KEY (Vorgaenger) REFERENCES vorlesungen(VorlNr) 
    ON DELETE CASCADE, 
  CONSTRAINT fkvoraussetzenNachfolger FOREIGN KEY (Nachfolger) REFERENCES vorlesungen(VorlNr) 
    ON DELETE CASCADE
); 
  
INSERT INTO voraussetzen (Vorgaenger, Nachfolger) VALUES 
  (5001, 5041), 
  (5001, 5043), 
  (5001, 5049), 
  (5041, 5216), 
  (5043, 5052), 
  (5041, 5052), 
  (5052, 5259); 
  
/* there is no auto-increment in voraussetzen */

/* Relation-Entity hören */
CREATE TABLE hoeren (
  MatrNr INT UNSIGNED NOT NULL, 
  VorlNr INT UNSIGNED NOT NULL, 
  PRIMARY KEY (MatrNr, VorlNr), 
  CONSTRAINT fkhoerenMatrNr FOREIGN KEY (MatrNr) REFERENCES studenten(MatrNr) 
    ON DELETE CASCADE, 
  CONSTRAINT fkhoerenVorlNr FOREIGN KEY (VorlNr) REFERENCES vorlesungen(VorlNr) 
    ON DELETE CASCADE
); 

INSERT INTO hoeren(MatrNr, VorlNr) VALUES
  (26120, 5001), 
  (27550, 5001), 
  (27550, 4052), 
  (28106, 5041), 
  (28106, 5052), 
  (28106, 5216), 
  (28106, 5259), 
  (29120, 5001), 
  (29120, 5041), 
  (29120, 5049), 
  (29555, 5022), 
  (25403, 5022), 
  (29555, 5001); 

/* Entity Assistenten */
CREATE TABLE assistenten (
  PersNr INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  Name VARCHAR(255) NOT NULL, 
  Fachgebiet VARCHAR(255) NOT NULL, 
  Boss INT UNSIGNED DEFAULT NULL, 
  CONSTRAINT fkassistentenBoss FOREIGN KEY (Boss) REFERENCES professoren(PersNr) 
    ON DELETE SET NULL
);

INSERT INTO assistenten(PersNr, Name, Fachgebiet, Boss) VALUES 
  (3002, 'Platon', 'Ideenlehre', 2125), 
  (3003, 'Aristoteles', 'Syllogistik', 2125), 
  (3004, 'Wittgenstein', 'Sprachtheorie', 2126), 
  (3005, 'Rhetikus', 'Planetenbewegung', 2127), 
  (3006, 'Newton', 'Keplersche Gesetze', 2127), 
  (3007, 'Spinoza', 'Gott und Natur', 2134);

ALTER TABLE assistenten AUTO_INCREMENT = 3008; 
 
/* Relation-Entity prüfen */ 
CREATE TABLE pruefen (
  MatrNr INT UNSIGNED NOT NULL, 
  VorlNr INT UNSIGNED NOT NULL, 
  PersNr INT UNSIGNED NOT NULL,  
  Note DECIMAL(2,1) DEFAULT NULL, 
  PRIMARY KEY (MatrNr, VorlNr), 
  CONSTRAINT fkpruefenMatrNr FOREIGN KEY (MatrNr) REFERENCES studenten(MatrNr) 
    ON DELETE CASCADE,   
  CONSTRAINT fkpruefenVorlNr FOREIGN KEY (VorlNr) REFERENCES vorlesungen(VorlNr),   
  CONSTRAINT fkpruefenPersNr FOREIGN KEY (PersNr) REFERENCES professoren(PersNr) 
    ON DELETE RESTRICT  
);  
  
INSERT INTO pruefen (MatrNr, VorlNr, PersNr, Note) VALUES   
  (28106, 5001, 2126, 1), 
  (25403, 5041, 2125, 2), 
  (27550, 4630, 2137, 2); 

/* Umlaute in den Tabellen hören und prüfen erlauben */
CREATE VIEW IF NOT EXISTS hören AS SELECT * FROM hoeren; 
CREATE VIEW IF NOT EXISTS prüfen AS SELECT * FROM pruefen;  

/* Weitere Datensätze, um die Aufgaben auf Blatt 5 korrekt testen zu können. 
 * Professor Einstein hält eine vierteilige Vorlesung "Relativ", 
 * die von den Studenten Zwei- bis Funfstein wenig erfolgreich besucht wird. */
INSERT INTO professoren (PersNr, Name, Rang, Raum) VALUES 
(1001, 'Einstein', 'F17', 2);

INSERT INTO vorlesungen (VorlNr, Titel, SWS, gelesenVon) VALUES 
(1001, 'Relativ 1', 4, 1001), 
(1002, 'Relativ 2', 4, 1001),
(1003, 'Relativ 3', 4, 1001),
(1004, 'Relativ 4', 4, 1001); 

INSERT INTO voraussetzen (Vorgaenger, Nachfolger) VALUES 
(1001, 1002), 
(1002, 1003), 
(1003, 1004);

INSERT INTO assistenten (Name, Fachgebiet, Boss) VALUES 
('Elsa', 'Ehefrau', 1001);

INSERT INTO studenten (MatrNr, Name, Semester) VALUES 
(10020, 'Zweistein', 3), 
(10030, 'Dreistein', 3), 
(10040, 'Vierstein', 3), 
(10050, 'Funfstein', 3); 

INSERT INTO hoeren (MatrNr, VorlNr) VALUES 
(10020, 1003), 
(10030, 1002), 
(10030, 1003), 
(10040, 1003), 
(10050, 1003); 

INSERT INTO pruefen (MatrNr, VorlNr, PersNr, Note) VALUES 
(10020, 1001, 1001, 1), 
(10020, 1002, 1001, 2), 
(10030, 1003, 1001, NULL), 
(10030, 1002, 1001, 5), 
(10040, 1002, 1001, 5), 
(10040, 1001, 1001, 5), 
(10050, 1002, 1001, NULL), 
(10050, 1001, 1001, NULL); 

DROP TABLE IF EXISTS bierdepot; 
CREATE TABLE Bierdepot (
  Nr INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT, 
  Sorte VARCHAR(50) NOT NULL, 
  Hersteller VARCHAR(50) NOT NULL, 
  Einheit VARCHAR(20) NOT NULL, 
  Anzahl INTEGER UNSIGNED NOT NULL DEFAULT 0, 
  CONSTRAINT BierdepotUniqueSorteHersteller UNIQUE KEY(Sorte, Hersteller, Einheit)  
);

INSERT INTO Bierdepot (Nr, Sorte, Hersteller, Einheit, Anzahl) VALUES
(1, 'Export', 'Schultheiss', 'Kasten', 12),
(3, 'Roggen', 'Thurn und Taxis', 'Kasten', 10),
(4, 'Pils', 'Löwenbräu', 'Kasten', 22),
(8, 'Export', 'Löwenbräu', 'Fass', 6),
(11, 'Weissbier', 'Paulaner', 'Kasten', 7),
(16, 'Hell', 'Spaten', '6er Pack', 5),
(20, 'Hell', 'Spaten', 'Kasten', 12),
(23, 'Hell', 'EKU', 'Fass', 4),
(24, 'Starkbier', 'Paulaner', 'Kasten', 4),
(26, 'Dunkel', 'Kneitinger', 'Kasten', 8),
(28, 'Märzen', 'Hofbräu', 'Fass', 3),
(33, 'Pils', 'Jever', '6er Pack', 6),
(36, 'Alkoholfreies Pils', 'Löwenbräu', '6er Pack', 5),
(39, 'Weissbier', 'Erdinger', 'Kasten', 9),
(47, 'Alkoholfreies Pils', 'Clausthaler', 'Kasten', 1);

ALTER TABLE Bierdepot AUTO_INCREMENT = 48; 

INSERT INTO Bierdepot VALUES (18, 'Export', 'EKU', '6er Pack', 8);

UPDATE Bierdepot SET Anzahl = Anzahl + 2 WHERE Nr = 28 OR Nr = 47;

UPDATE Bierdepot 
SET Anzahl=(CASE WHEN Anzahl > 10 THEN Anzahl-10 ELSE 0 END) 
WHERE Hersteller LIKE 'L_wenbr%' 
AND Sorte='Pils'

