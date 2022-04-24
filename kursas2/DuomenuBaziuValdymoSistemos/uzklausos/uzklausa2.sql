/****************************************************

Studijų programa ir kursas: Programų sistemos, 2 kursas

Grupė: 5

Vardas Pavardė: Justas Gasparaitis

Naudotojo vardas: juga7730

Užduoties numeris ir tekstas:
2. Poros skaitytojų (jų vardai ir pavardės), kurių gimimo dienos yra tą patį mėnesį.

*****************************************************/
SELECT DISTINCT s1.vardas,
                s1.pavarde,
                e1.paimta,
                s2.vardas,
                s2.pavarde,
                e2.paimta
FROM stud.egzempliorius e1,
     stud.egzempliorius e2,
     stud.skaitytojas s1,
     stud.skaitytojas s2
WHERE EXTRACT(MONTH FROM e1.paimta) =
      EXTRACT(MONTH FROM e2.paimta)
AND s1.nr = e1.skaitytojas
AND s2.nr = e2.skaitytojas
AND e1.skaitytojas <> e2.skaitytojas;

SELECT stud.skaitytojas.vardas,
       stud.skaitytojas.pavarde,
       stud.egzempliorius.paimta,
       stud.egzempliorius.nr
FROM stud.skaitytojas,
     stud.egzempliorius
WHERE EXTRACT(MONTH FROM stud.egzempliorius.paimta) = 10
AND stud.egzempliorius.skaitytojas = stud.skaitytojas.nr
ORDER BY stud.skaitytojas.vardas,
         stud.skaitytojas.pavarde;









