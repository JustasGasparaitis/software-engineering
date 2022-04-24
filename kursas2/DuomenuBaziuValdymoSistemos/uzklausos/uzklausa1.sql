/****************************************************

Studijų programa ir kursas: Programų sistemos, 2 kursas

Grupė: 5

Vardas Pavardė: Justas Gasparaitis

Naudotojo vardas: juga7730

Užduoties numeris ir tekstas:
1. Visų autorių, parašiusių bent po vieną knygą, vardai ir pavardės.

*****************************************************/
SELECT DISTINCT vardas,
                pavarde
FROM stud.autorius
WHERE stud.autorius.isbn IS NOT NULL;

