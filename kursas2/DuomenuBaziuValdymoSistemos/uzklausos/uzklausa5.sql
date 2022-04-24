/****************************************************

Studijų programa ir kursas: Programų sistemos, 2 kursas

Grupė: 5

Vardas Pavardė: Justas Gasparaitis

Naudotojo vardas: juga7730

Užduoties numeris ir tekstas:
5. Kiekvienam duomenų tipui - domenų, sukurtų naudojant tą duomenų tipą, skaičius.

*****************************************************/
WITH DuomenuTipai (tipas) AS 
	(SELECT DISTINCT Data_Type
	 FROM Information_schema.Columns),
	  Domenai (tipas) AS
	 (SELECT data_type
	  FROM Information_schema.Domains
	  GROUP BY data_type)
SELECT DuomenuTipai.tipas,
	    COUNT (CASE WHEN DuomenuTipai.tipas = Domenai.tipas THEN 1 END) AS "skaicius"
FROM DuomenuTipai, Domenai
GROUP BY DuomenuTipai.tipas;

SELECT data_type,
       COUNT(data_type)
FROM Information_schema.Domains
GROUP BY data_type;




/* Domenu sarasas (186)
SELECT data_type, domain_name
FROM Information_schema.Domains
GROUP BY data_type, domain_name;

SELECT data_type, domain_name
FROM Information_schema.Domains
GROUP BY data_type, domain_name;

SELECT Data_Type, Table_Name
	 FROM Information_schema.Columns
	 GROUP BY Data_Type, Table_Name
	 ORDER BY Table_Name ASC


SELECT Data_Type, COUNT (Data_Type)
FROM DuomenuTipai
GROUP BY Data_Type;


SELECT Data_Type, Table_Name
FROM Information_schema.Columns
WHERE Table_Name = 'pg_views';

SELECT data_type, domain_name
FROM Information_schema.Domains
GROUP BY data_type, domain_name;
*/
