/****************************************************

Studijų programa ir kursas: Programų sistemos, 2 kursas

Grupė: 5

Vardas Pavardė: Justas Gasparaitis

Naudotojo vardas: juga7730

Užduoties numeris ir tekstas:
4. Pavadinimai ir ISBN knygų, kurių autorių skaičius yra didesnis už visų knygų autorių skaičių vidurkį.

*****************************************************/
WITH AutoriuSkaicius(pavadinimas, isbn, skaicius) AS
  (SELECT stud.knyga.pavadinimas,
          stud.knyga.isbn,
          COUNT(stud.autorius.isbn) AS "skaicius"
   FROM stud.autorius,
        stud.knyga
   WHERE stud.autorius.isbn = stud.knyga.isbn
   GROUP BY stud.knyga.pavadinimas,
            stud.knyga.isbn),
     VisuAutoriuSkaiciuVidurkis(vidurkis) AS
  (SELECT AVG(AutoriuSkaicius.skaicius)
   FROM AutoriuSkaicius)
SELECT AutoriuSkaicius.pavadinimas,
       AutoriuSkaicius.isbn,
       AutoriuSkaicius.skaicius,
       VisuAutoriuSkaiciuVidurkis.vidurkis,
FROM AutoriuSkaicius,
     VisuAutoriuSkaiciuVidurkis
WHERE AutoriuSkaicius.skaicius > VisuAutoriuSkaiciuVidurkis.vidurkis;

WITH AutoriuSkaicius(pavadinimas, isbn, skaicius) AS
  (SELECT stud.knyga.pavadinimas,
          stud.knyga.isbn,
          COUNT(stud.autorius.isbn) AS "skaicius"
   FROM stud.autorius,
        stud.knyga
   WHERE stud.autorius.isbn = stud.knyga.isbn
   GROUP BY stud.knyga.pavadinimas,
            stud.knyga.isbn),
     VisuAutoriuSkaiciuDidziausiasKiekis(kiekis) AS
  (SELECT MAX(AutoriuSkaicius.skaicius)
   FROM AutoriuSkaicius)
SELECT COUNT(*),
       VisuAutoriuSkaiciuDidziausiasKiekis.kiekis
FROM AutoriuSkaicius,
     VisuAutoriuSkaiciuDidziausiasKiekis
WHERE AutoriuSkaicius.skaicius = VisuAutoriuSkaiciuDidziausiasKiekis.kiekis
GROUP BY VisuAutoriuSkaiciuDidziausiasKiekis.kiekis;

SELECT stud.knyga.pavadinimas,
       stud.knyga.isbn,
       COUNT(stud.autorius.isbn) AS "skaicius"
FROM stud.autorius,
     stud.knyga
WHERE stud.autorius.isbn = stud.knyga.isbn
GROUP BY stud.knyga.pavadinimas,
         stud.knyga.isbn;




