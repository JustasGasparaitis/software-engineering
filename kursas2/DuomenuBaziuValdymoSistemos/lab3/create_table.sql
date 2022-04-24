/* Lenteliu sukurimas */
CREATE TYPE MaistoTipas AS ENUM ('pagrindinis', 'uzkandis', 'desertas', 'gerimas');
CREATE TABLE Valgis  (ValgioNr INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                      Pavadinimas CHARACTER(100) NOT NULL,
                      Kaina REAL NOT NULL CHECK (Kaina >= 0),
                      Tipas MaistoTipas NOT NULL);
CREATE UNIQUE INDEX IN_Pavadinimas ON Valgis (Pavadinimas);

CREATE TABLE Stalas (StaloNr INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                     Data DATE NOT NULL,
                     ZmoniuSkaicius INT NOT NULL CHECK (ZmoniuSkaicius >= 0),
                     Arbatpinigiai REAL NOT NULL CHECK (Arbatpinigiai >= 0));
CREATE INDEX IN_Data ON Stalas (Data);

CREATE TABLE Produktas (ProduktoNr INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                        Pavadinimas CHARACTER(100) NOT NULL,
                        Kaina REAL NOT NULL CHECK (Kaina >= 0));

CREATE TABLE Patiekalas (PatiekaloNr INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
                         ValgioNr INT NOT NULL CHECK (ValgioNr > 0),
                         Ivertinimas INT NOT NULL CHECK (Ivertinimas >= 0) DEFAULT 0,
                         Komentaras CHARACTER(100) NOT NULL DEFAULT 'Komentaro nera',
                         CONSTRAINT FK_ValgioNr
                            FOREIGN KEY(ValgioNr) 
                            REFERENCES Valgis(ValgioNr));

CREATE TABLE ValgioProduktas (ValgioNr INT NOT NULL CHECK (ValgioNr > 0),
                        		ProduktoNr INT NOT NULL CHECK (ProduktoNr > 0),
                        		PRIMARY KEY (ValgioNr, ProduktoNr),
		                  		CONSTRAINT FK_ValgioNr
			                     FOREIGN KEY(ValgioNr) 
			                     REFERENCES Valgis(ValgioNr),
			                   CONSTRAINT FK_ProduktoNr
			                     FOREIGN KEY(ProduktoNr)
			                     REFERENCES Produktas(ProduktoNr));

CREATE TABLE StaloPatiekalas (StaloNr INT NOT NULL CHECK (StaloNr > 0),
                        		PatiekaloNr INT NOT NULL CHECK (PatiekaloNr > 0),
                        		PRIMARY KEY (StaloNr, PatiekaloNr),
		                  			CONSTRAINT FK_StaloNr
							               FOREIGN KEY(StaloNr) 
							               REFERENCES Stalas(StaloNr),
					                  CONSTRAINT FK_PatiekaloNr
							               FOREIGN KEY(PatiekaloNr)
							               REFERENCES Patiekalas(PatiekaloNr));

/* Testiniai duomenys */
INSERT INTO Valgis (ValgioNr, Pavadinimas, Kaina, Tipas) VALUES (1, 'Darzoviu sriuba', 2.00, 'pagrindinis');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Darzoviu sriuba', 2.00, 'pagrindinis');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Kijevo kotletas', 7.00, 'pagrindinis');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Kiaulienos karbonadas', 7.00, 'pagrindinis');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Lietiniai su varske', 5.00, 'desertas');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Obuoliu pyragas', 4.00, 'desertas');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Stalo vanduo', 1.00, 'gerimas');
INSERT INTO Valgis (Pavadinimas, Kaina, Tipas) VALUES ('Arbata', 1.50, 'gerimas');

INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Bulve', 0.20);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Morka', 0.15);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Svogunas', 0.20);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Sultinys', 0.30);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Vistiena', 1.50);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Sviestas', 1.20);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Kiausinis', 0.50);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Dziuveseliai', 1.00);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Kiauliena', 1.80);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Kvietiniai miltai', 1.00);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Pienas', 0.80);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Cukrus', 0.20);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Varske', 1.00);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Obuolys', 0.15);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Arbata', 0.12);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Vanduo', 0.01);
INSERT INTO Produktas (Pavadinimas, Kaina) VALUES ('Citrina', 0.20);

INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (1, 1);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (1, 2);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (1, 3);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (1, 4);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (2, 5);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (2, 6);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (2, 7);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (2, 8);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (3, 7);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (3, 8);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (3, 9);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (4, 10);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (4, 11);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (4, 12);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (4, 13);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (5, 10);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (5, 11);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (5, 12);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (5, 14);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (6, 16);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (6, 17);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (7, 15);
INSERT INTO ValgioProduktas (ValgioNr, ProduktoNr) VALUES (7, 16);

INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-06', 1, 2);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-06', 3, 15);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-06', 6, 0);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-07', 2, 10);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-07', 1, 20);

INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (4, 9, 'Patiko');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (7, 9, 'Skani arbata');

INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (3, 10, 'Labai skanu');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (3, 5, 'Kazko truko');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (2, 10, 'Labai skanu');

INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (1, 7, 'Neblogai');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (1, 6, 'Nelabai patiko');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (2, 8, 'Skanu');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (2, 1, 'Labai neskanu');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (2, 9, 'Siek tiek atveses patiekalas');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (3, 1, 'Blogiau nebuna');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (3, 1, 'Gyvenime cia negrisiu');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (3, 7, 'Nesamone');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (6, 10, 'Vanduo kaip vanduo');

INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (4, 10, 'Skanu');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (4, 10, 'Skanu');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (5, 10, 'Skanu');

INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (6, 10, 'Skaniausias vanduo pasaulyje');

INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (1, 1);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (1, 2);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (2, 3);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (2, 4);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (2, 5);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 6);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 7);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 8);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 9);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 10);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 11);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 12);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 13);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (3, 14);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (4, 15);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (4, 16);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (4, 17);
INSERT INTO StaloPatiekalas (StaloNr, PatiekaloNr) VALUES (5, 18);


/* T1 */
CREATE FUNCTION MaxStaluSkaicius()
RETURNS TRIGGER AS $$
BEGIN
IF
	(SELECT COUNT(*) FROM Stalas) >= 50
THEN
	RAISE EXCEPTION 'Virsytas stalu skaicius';
END IF;
RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE TRIGGER MaxStaluSkaicius
BEFORE INSERT ON Stalas
FOR EACH ROW
EXECUTE PROCEDURE MaxStaluSkaicius();



/* T2 */
CREATE FUNCTION MaxArbatosSkaicius()
RETURNS TRIGGER AS $$
BEGIN
IF
	(SELECT COUNT(*)
	 FROM Valgis, Patiekalas
	 WHERE Valgis.ValgioNr = Patiekalas.ValgioNr
	 AND   Pavadinimas = 'Arbata') >= 15
THEN
	RAISE EXCEPTION 'Nebera arbatos :(';
END IF;
RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE TRIGGER MaxArbatosSkaicius
BEFORE INSERT ON Patiekalas
FOR EACH ROW
EXECUTE PROCEDURE MaxArbatosSkaicius();




/* VL1 */
CREATE VIEW VienisiStalai AS
SELECT *
FROM Stalas
WHERE ZmoniuSkaicius = 1;


/* VL2 */
CREATE VIEW GerimuSarasas AS
SELECT *
FROM Valgis
WHERE Tipas = 'gerimas';


/* MVL sukūrimas */
CREATE MATERIALIZED VIEW KiaulienosKarbonadoIvertinimai AS
SELECT Valgis.Pavadinimas, Patiekalas.Ivertinimas, Patiekalas.Komentaras
FROM Patiekalas, Valgis
WHERE Valgis.Pavadinimas = 'Kiaulienos karbonadas'
AND   Valgis.ValgioNr = Patiekalas.ValgioNr;

/* MVL atnaujinimas */
REFRESH MATERIALIZED VIEW KiaulienosKarbonadoIvertinimai;


/* Virtualiųjų lentelių ištrynimas */
DROP VIEW VienisiStalai, GerimuSarasas;
DROP MATERIALIZED VIEW KiaulienosKarbonadoIvertinimai;

/* Trigerių ir funkcijų ištrynimas */
DROP TRIGGER MaxStaluSkaicius ON Stalas;
DROP TRIGGER MaxArbatosSkaicius ON Patiekalas;
DROP FUNCTION MaxStaluSkaicius, MaxArbatosSkaicius;

/* Lentelių ištrynimas */
DROP TABLE Valgis, Stalas, Produktas, ValgioProduktas, Patiekalas, StaloPatiekalas;
DROP TYPE MaistoTipas;


/* Lenteliu spausdinimas */
SELECT * FROM Valgis;
SELECT * FROM Stalas;
SELECT * FROM Produktas;
SELECT * FROM Patiekalas;
SELECT * FROM ValgioProduktas;
SELECT * FROM StaloPatiekalas;
SELECT * FROM KiaulienosKarbonadoIvertinimai;
SELECT * FROM VienisiStalai;
SELECT * FROM GerimuSarasas;

/* T1 Testas */
SELECT COUNT(*) FROM Stalas;
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-06', 1, 2);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-06', 3, 15);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-06', 6, 0);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-07', 2, 10);
INSERT INTO Stalas (Data, ZmoniuSkaicius, Arbatpinigiai) VALUES ('2021-12-07', 1, 20);


/* T2 Testas */
SELECT COUNT(*) FROM Patiekalas WHERE ValgioNr = 7;
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (7, 9, 'Skani arbata');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (7, 9, 'Skani arbata');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (7, 9, 'Skani arbata');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (7, 9, 'Skani arbata');
INSERT INTO Patiekalas (ValgioNr, Ivertinimas, Komentaras) VALUES (7, 9, 'Skani arbata');


/* Transakcija */
BEGIN;

DELETE FROM Patiekalas WHERE ValgioNr = 5;
DELETE FROM Valgis WHERE ValgioNr = 5;
COMMIT;

/* Update */
UPDATE Valgis
SET Pavadinimas = 'barbekiu',
	Kaina       = 40.96
WHERE ValgioNr = 5;

/* Ivertinimai */
SELECT Pavadinimas
FROM Valgis, Patiekalas
WHERE Valgis.ValgioNr = Patiekalas.ValgioNr
AND Patiekalas.Ivertinimas = 10
GROUP BY Pavadinimas;

/* Paieska */
SELECT Pavadinimas
FROM Valgis
WHERE search(Pavadinimas, 'i');


CREATE FUNCTION MaxArbatosSkaicius()
RETURNS TRIGGER AS $$
BEGIN
IF
	(SELECT COUNT(*)
	 FROM Valgis, Patiekalas
	 WHERE Valgis.ValgioNr = Patiekalas.ValgioNr
	 AND   Pavadinimas = 'Arbata') >= 15
THEN
	RAISE EXCEPTION 'Nebera arbatos :(';
END IF;
RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE FUNCTION search(a character, b character) RETURNS BOOL AS $$
BEGIN
IF a ~* b THEN 
	RETURN TRUE;
ELSE
   RETURN FALSE;
END IF;
END; $$
LANGUAGE plpgsql;






