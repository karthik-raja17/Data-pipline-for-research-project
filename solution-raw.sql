/* 1 */
SELECT p, COUNT(*)
FROM Pub
GROUP BY p;
/*
       p       |  count
---------------+---------
 article       | 3297635
 book          |   20198
 incollection  |   70191
 inproceedings | 3336684
 mastersthesis |      21
 phdthesis     |  119509
 proceedings   |   56291
 www           | 3353780
(8 rows)
*/

/* 2 */
SELECT DISTINCT p.p
FROM Pub p
JOIN Field f ON p.k = f.k
WHERE f.k LIKE '%conference%';
/*
       p
---------------
 inproceedings
 proceedings
(2 rows)
*/

/* 3 */
SELECT COUNT(DISTINCT p)
FROM Pub; /* This outputs the total number of publication types: 8 */
/*
 count
-------
     8
(1 row)
*/
SELECT DISTINCT Field.p
FROM Field, Pub
WHERE Field.k = Pub.k
GROUP BY Field.p
HAVING COUNT(DISTINCT Pub.p) = 8;
/*
   p
--------
 author
 ee
 note
 title
 year
(5 rows)
*/

/* 4 */
SELECT DISTINCT Field.p
FROM Field, Pub
WHERE Field.k = Pub.k
GROUP BY Field.p
HAVING COUNT(DISTINCT Pub.p) <= 1;
/*
    p
---------
 address
 chapter
(2 rows)
*/