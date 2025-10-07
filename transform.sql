CREATE INDEX idx_pub_k ON Pub(k);
CREATE INDEX idx_pub_p ON Pub(p);
CREATE INDEX idx_field_k ON Field(k);
CREATE INDEX idx_field_p ON Field(p);
CREATE INDEX idx_field_v ON Field(v);

DROP SEQUENCE IF EXISTS author_id;
CREATE SEQUENCE author_id;
DROP TABLE IF EXISTS temp_author1;
CREATE TABLE temp_author1 (
    id INTEGER,
    name TEXT
);
INSERT INTO temp_author1 (
    SELECT NEXTVAL('author_id'), y.v
    FROM Pub x, Field y
    WHERE x.k = y.k AND x.p = 'www' AND y.p = 'author'
    GROUP BY y.v
);
DROP TABLE IF EXISTS temp_author2;
CREATE TABLE temp_author2 (
    name TEXT,
    homepage TEXT
);
INSERT INTO temp_author2 (
    SELECT y.v, MIN(z.v)
    FROM Field y, Field z
    WHERE y.k = z.k AND y.p = 'author' AND z.p = 'url' AND z.v LIKE 'http%'
    GROUP BY y.v
);
INSERT INTO Author (
    SELECT x.id, x.name, y.homepage
    FROM temp_author1 x LEFT OUTER JOIN temp_author2 y
    ON x.name = y.name
);

DROP SEQUENCE IF EXISTS author_id;
DROP TABLE IF EXISTS temp_author1;
DROP TABLE IF EXISTS temp_author2;

DROP SEQUENCE IF EXISTS pub_id;
CREATE SEQUENCE pub_id;
DROP TABLE IF EXISTS temp_publication1;
CREATE TABLE temp_publication1 (
    pubid INTEGER,
    pubkey TEXT
);
INSERT INTO temp_publication1 (
    SELECT NEXTVAL('pub_id'), x.k
    FROM Field x
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_publication2;
CREATE TABLE temp_publication2 (
    pubkey TEXT,
    title TEXT
);
INSERT INTO temp_publication2 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y
    WHERE x.k = y.k AND y.p = 'title'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_publication3;
CREATE TABLE temp_publication3 (
    pubkey TEXT,
    year TEXT
);
INSERT INTO temp_publication3 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y
    WHERE x.k = y.k AND y.p = 'year'
    GROUP BY x.k
);
ALTER TABLE Publication
DROP CONSTRAINT altKey;
INSERT INTO Publication (
    SELECT x.pubid, x.pubkey, y.title, z.year
    FROM temp_publication1 x LEFT OUTER JOIN temp_publication2 y ON x.pubkey = y.pubkey
    LEFT OUTER JOIN temp_publication3 z ON x.pubkey = z.pubkey
);
ALTER TABLE Publication
ADD CONSTRAINT altKey UNIQUE (pubkey);
DROP SEQUENCE IF EXISTS pub_id;
DROP TABLE IF EXISTS temp_publication1;
DROP TABLE IF EXISTS temp_publication2;
DROP TABLE IF EXISTS temp_publication3;

DROP TABLE IF EXISTS temp_article1;
CREATE TABLE temp_article1 (
    pubkey TEXT,
    journal TEXT
);
INSERT INTO temp_article1 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'article' AND y.p = 'journal'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_article2;
CREATE TABLE temp_article2 (
    pubkey TEXT,
    month TEXT
);
INSERT INTO temp_article2 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'article' AND y.p = 'month'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_article3;
CREATE TABLE temp_article3 (
    pubkey TEXT,
    volume TEXT
);
INSERT INTO temp_article3 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'article' AND y.p = 'volume'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_article4;
CREATE TABLE temp_article4 (
    pubkey TEXT,
    number TEXT
);
INSERT INTO temp_article4 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'article' AND y.p = 'number'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_article5;
CREATE TABLE temp_article5 (
    pubkey TEXT,
    journal TEXT,
    month TEXT,
    volume TEXT,
    number TEXT
);
INSERT INTO temp_article5 (
    SELECT a.pubkey, a.journal, b.month, c.volume, d.number
    FROM temp_article1 a FULL OUTER JOIN temp_article2 b ON a.pubkey = b.pubkey
                         FULL OUTER JOIN temp_article3 c ON a.pubkey = c.pubkey
                         FULL OUTER JOIN temp_article4 d ON a.pubkey = d.pubkey
);
INSERT INTO Article (
    SELECT p.pubid, t.journal, t.month, t.volume, t.number
    FROM Publication p, temp_article5 t
    WHERE p.pubkey = t.pubkey
);
DROP TABLE IF EXISTS temp_article1;
DROP TABLE IF EXISTS temp_article2;
DROP TABLE IF EXISTS temp_article3;
DROP TABLE IF EXISTS temp_article4;
DROP TABLE IF EXISTS temp_article5;

DROP TABLE IF EXISTS temp_book1;
CREATE TABLE temp_book1 (
    pubkey TEXT,
    publisher TEXT
);
INSERT INTO temp_book1 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'book' AND y.p = 'publisher'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_book2;
CREATE TABLE temp_book2 (
    pubkey TEXT,
    isbn TEXT
);
INSERT INTO temp_book2 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'book' AND y.p = 'isbn'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_book3;
CREATE TABLE temp_book3 (
    pubkey TEXT,
    publisher TEXT,
    isbn TEXT
);
INSERT INTO temp_book3 (
    SELECT a.pubkey, a.publisher, b.isbn
    FROM temp_book1 a FULL OUTER JOIN temp_book2 b ON a.pubkey = b.pubkey
);
INSERT INTO Book (
    SELECT p.pubid, t.publisher, t.isbn
    FROM Publication p, temp_book3 t
    WHERE p.pubkey = t.pubkey
);
DROP TABLE IF EXISTS temp_book1;
DROP TABLE IF EXISTS temp_book2;
DROP TABLE IF EXISTS temp_book3;

DROP TABLE IF EXISTS temp_incollection1;
CREATE TABLE temp_incollection1 (
    pubkey TEXT,
    booktitle TEXT
);
INSERT INTO temp_incollection1 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'incollection' AND y.p = 'booktitle'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_incollection2;
CREATE TABLE temp_incollection2 (
    pubkey TEXT,
    publisher TEXT
);
INSERT INTO temp_incollection2 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'incollection' AND y.p = 'publisher'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_incollection3;
CREATE TABLE temp_incollection3 (
    pubkey TEXT,
    isbn TEXT
);
INSERT INTO temp_incollection3 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'incollection' AND y.p = 'isbn'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_incollection4;
CREATE TABLE temp_incollection4 (
    pubkey TEXT,
    booktitle TEXT,
    publisher TEXT,
    isbn TEXT
);
INSERT INTO temp_incollection4 (
    SELECT a.pubkey, a.booktitle, b.publisher, c.isbn
    FROM temp_incollection1 a FULL OUTER JOIN temp_incollection2 b ON a.pubkey = b.pubkey
                              FULL OUTER JOIN temp_incollection3 c on a.pubkey = c.pubkey
);
INSERT INTO Incollection (
    SELECT p.pubid, t.booktitle, t.publisher, t.isbn
    FROM Publication p, temp_incollection4 t
    WHERE p.pubkey = t.pubkey
);
DROP TABLE IF EXISTS temp_incollection1;
DROP TABLE IF EXISTS temp_incollection2;
DROP TABLE IF EXISTS temp_incollection3;
DROP TABLE IF EXISTS temp_incollection4;

DROP TABLE IF EXISTS temp_inproceedings1;
CREATE TABLE temp_inproceedings1 (
    pubkey TEXT,
    booktitle TEXT
);
INSERT INTO temp_inproceedings1 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'inproceedings' AND y.p = 'booktitle'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_inproceedings2;
CREATE TABLE temp_inproceedings2 (
    pubkey TEXT,
    editor TEXT
);
INSERT INTO temp_inproceedings2 (
    SELECT x.k, MIN(y.v)
    FROM Field x, Field y, Pub z
    WHERE x.k = y.k AND y.k = z.k AND
          z.p = 'inproceedings' AND y.p = 'editor'
    GROUP BY x.k
);
DROP TABLE IF EXISTS temp_inproceedings3;
CREATE TABLE temp_inproceedings3 (
    pubkey TEXT,
    booktitle TEXT,
    editor TEXT
);
INSERT INTO temp_inproceedings3 (
    SELECT a.pubkey, a.booktitle, b.editor
    FROM temp_inproceedings1 a FULL OUTER JOIN temp_inproceedings2 b ON a.pubkey = b.pubkey
);
INSERT INTO Inproceedings (
    SELECT p.pubid, t.booktitle, t.editor
    FROM Publication p, temp_inproceedings3 t
    WHERE p.pubkey = t.pubkey
);
DROP TABLE IF EXISTS temp_inproceedings1;
DROP TABLE IF EXISTS temp_inproceedings2;
DROP TABLE IF EXISTS temp_inproceedings3;

DROP TABLE IF EXISTS temp_authored1;
CREATE TABLE temp_authored1 (
    id INTEGER,
    pubkey TEXT
);
INSERT INTO temp_authored1 (
    SELECT a.id, x.k
    FROM Author a, Field x
    WHERE x.p = 'author' AND a.name = x.v
    GROUP BY a.id, x.k
);
INSERT INTO Authored (
    SELECT t.id, p.pubid
    FROM temp_authored1 t, Publication p
    WHERE t.pubkey = p.pubkey
);
DROP TABLE IF EXISTS temp_authored1;