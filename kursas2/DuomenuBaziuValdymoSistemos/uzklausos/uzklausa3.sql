/****************************************************

Studijų programa ir kursas: Programų sistemos, 2 kursas

Grupė: 5

Vardas Pavardė: Justas Gasparaitis

Naudotojo vardas: juga7730

Užduoties numeris ir tekstas:
3. Kiekvienam skaitytojui (vardas, pavardė) paimtų egzempliorių skaičius ir bendra jų vertė.
Jei knygos vertė nenurodyta, laikyti, kad ji lygi 10.

vardas, pavarde, egzemplioriu vertes, paemimo data

*****************************************************/
SELECT stud.skaitytojas.vardas,
       stud.skaitytojas.pavarde,
       COUNT(DISTINCT stud.egzempliorius.nr) AS "egz.",
       SUM(COALESCE(stud.knyga.verte, 10.00)) AS "verte"
FROM stud.skaitytojas,
     stud.knyga,
     stud.egzempliorius
WHERE stud.skaitytojas.nr = stud.egzempliorius.skaitytojas
  AND stud.egzempliorius.isbn = stud.knyga.isbn
GROUP BY stud.skaitytojas.vardas,
         stud.skaitytojas.pavarde
ORDER BY stud.skaitytojas.vardas,
         stud.skaitytojas.pavarde;



SELECT stud.skaitytojas.vardas,
       stud.skaitytojas.pavarde,
       stud.knyga.verte,
       stud.egzempliorius.paimta
FROM stud.skaitytojas,
     stud.knyga,
     stud.egzempliorius
WHERE stud.skaitytojas.nr = stud.egzempliorius.skaitytojas
  AND stud.egzempliorius.isbn = stud.knyga.isbn
ORDER BY stud.skaitytojas.vardas,
         stud.skaitytojas.pavarde;

