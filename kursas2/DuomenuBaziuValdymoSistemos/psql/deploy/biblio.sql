INSERT INTO Stud.Knyga VALUES('9998-01-101-9','Duomenu bazes',           'Baltoji',   2015, 212, NULL ) ;
INSERT INTO Stud.Knyga VALUES('9998-01-102-7','Programavimo kalbos',     'Baltoji',   2016, 401, 22.50) ;
INSERT INTO Stud.Knyga VALUES('9999-02-202-2','Operacines sistemos',     'Juodoji',   2016, 356, 19.90) ;
INSERT INTO Stud.Knyga VALUES('9999-02-203-0','Transliavimo metodai',    'Juodoji',   2017, 495, 30.00) ;
INSERT INTO Stud.Knyga VALUES('9998-01-103-5','Objektinis programavimas','Baltoji',   2006, 356, 19.90) ;
INSERT INTO Stud.Knyga VALUES('9997-03-303-5','Informacines sistemos',   'Raudonoji', 2006, 254, 15.50) ;
INSERT INTO Stud.Knyga VALUES('9998-01-104-3','Kompiuteriu tinklai',     'Baltoji',   2007, 455, 35.20) ;

INSERT INTO Stud.Autorius VALUES('9998-01-101-9', 'Jonas',   'Jonaitis'  ) ;
INSERT INTO Stud.Autorius VALUES('9998-01-101-9', 'Petras',  'Petraitis' ) ;
INSERT INTO Stud.Autorius VALUES('9998-01-102-7', 'Pijus',   'Jonaitis'  ) ;
INSERT INTO Stud.Autorius VALUES('9999-02-202-2', 'Pijus',   'Jonaitis'  ) ;
INSERT INTO Stud.Autorius VALUES('9999-02-202-2', 'Onute',   'Jonaityte' ) ;
INSERT INTO Stud.Autorius VALUES('9999-02-202-2', 'Jonas',   'Petraitis' ) ;
INSERT INTO Stud.Autorius VALUES('9999-02-202-2', 'Jonas',   'Jonaitis'  ) ;
INSERT INTO Stud.Autorius VALUES('9999-02-203-0', 'Juozas',  'Juodakis'  ) ;
INSERT INTO Stud.Autorius VALUES('9999-02-203-0', 'Antanas', 'Antanaitis') ;
INSERT INTO Stud.Autorius VALUES('9998-01-103-5', 'Maryte',  'Grazulyte' ) ;
INSERT INTO Stud.Autorius VALUES('9998-01-103-5', 'Janina',  'Jonaityte' ) ;
INSERT INTO Stud.Autorius VALUES('9997-03-303-5', 'Simas',   'Simaitis'  ) ;
INSERT INTO Stud.Autorius VALUES('9997-03-303-5', 'Petras',  'Petraitis' ) ;
INSERT INTO Stud.Autorius VALUES('9997-03-303-5', 'Simas',   'Baltakis'  ) ;
INSERT INTO Stud.Autorius VALUES('9998-01-104-3', 'Jonas',   'Petraitis' ) ;

INSERT INTO Stud.Skaitytojas VALUES(1000, '50101010222', 'Jonas',   'Petraitis', '2001-01-01', 'Tiesioji 1-10' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1001, '50202280102', 'Jonas',   'Onaitis',   '2002-02-28', 'Lenktoji 20' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1010, '60203021111', 'Milda',   'Onaityte',  '2002-03-02', 'Didzioji 21-5' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1015, '60206301011', 'Onute',   'Petraityte','2002-06-30', 'Didzioji 21-5' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1021, '50205301031', 'Petras',  'Jonaitis',  '2002-05-30', 'Mazoji 1' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1032, '50212310031', 'Tadas',   'Onaitis',   '2002-12-31', 'Tiesioji 12' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1033, '60211300131', 'Grazina', 'Petraityte','2002-11-30', 'Tiesioji 1-10' ) ;
INSERT INTO Stud.Skaitytojas VALUES(1011, '50111010055', 'Jonas', 'Adomaitis','2001-11-01', 'Mazoji 1' ) ;

INSERT INTO Stud.Egzempliorius VALUES(32101, '9998-01-101-9', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32102, '9998-01-101-9', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32103, '9998-01-101-9', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32104, '9998-01-101-9', 1000, '2021-10-02', '2021-10-15' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32105, '9998-01-101-9', 1010, '2021-09-04', '2021-10-04' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32106, '9998-01-101-9', 1021, '2021-09-14', '2021-10-04' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32107, '9998-01-101-9', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32108, '9998-01-101-9', 1001, '2021-10-02', '2021-10-14' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32109, '9998-01-101-9', 1032, '2021-09-20', '2021-10-05' ) ;

INSERT INTO Stud.Egzempliorius VALUES(32200, '9998-01-102-7', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32201, '9998-01-102-7', 1021, '2021-10-02', '2021-11-04' ) ;

INSERT INTO Stud.Egzempliorius VALUES(32301, '9999-02-202-2', 1000, '2021-10-02', '2021-10-15' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32302, '9999-02-202-2', 1021, '2021-09-14', '2021-10-04' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32303, '9999-02-202-2', NULL, NULL, NULL ) ;

INSERT INTO Stud.Egzempliorius VALUES(32330, '9999-02-203-0', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32331, '9999-02-203-0', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32332, '9999-02-203-0', 1010, '2021-09-14', '2021-10-05' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32333, '9999-02-203-0', 1015, '2021-10-14', '2021-11-05' ) ;

INSERT INTO Stud.Egzempliorius VALUES(32401, '9998-01-103-5', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32402, '9998-01-103-5', 1032, '2021-09-20', '2021-10-05' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32403, '9998-01-103-5', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32404, '9998-01-103-5', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32405, '9998-01-103-5', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32406, '9998-01-103-5', 1010, '2021-09-14', '2021-10-04' ) ;

INSERT INTO Stud.Egzempliorius VALUES(32501, '9997-03-303-5', 1010, '2021-10-14', '2021-11-04' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32502, '9997-03-303-5', 1032, '2021-09-20', '2021-10-04' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32503, '9997-03-303-5', 1015, '2021-09-20', '2021-10-05' ) ;
INSERT INTO Stud.Egzempliorius VALUES(32504, '9997-03-303-5', 1001, '2021-10-06', '2021-11-05' ) ;

INSERT INTO Stud.Egzempliorius VALUES(32601, '9998-01-104-3', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32602, '9998-01-104-3', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32603, '9998-01-104-3', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32604, '9998-01-104-3', NULL, NULL, NULL ) ;
INSERT INTO Stud.Egzempliorius VALUES(32605, '9998-01-104-3', NULL, NULL, NULL ) ;
