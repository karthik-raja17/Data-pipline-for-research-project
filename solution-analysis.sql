DROP INDEX IF EXISTS ind_1;
DROP INDEX IF EXISTS ind_2;
DROP INDEX IF EXISTS ind_3;
DROP INDEX IF EXISTS ind_4;
DROP INDEX IF EXISTS ind_5;
DROP INDEX IF EXISTS ind_6;
DROP INDEX IF EXISTS ind_7;
DROP INDEX IF EXISTS ind_8;
DROP INDEX IF EXISTS ind_9;
CREATE INDEX ind_1
ON Author(id);
CREATE INDEX ind_2
ON Author(name);
CREATE INDEX ind_3
ON Author(homepage);
CREATE INDEX ind_4
ON Authored(id);
CREATE INDEX ind_5
ON Authored(pubid);
CREATE INDEX ind_6
ON Publication(pubid);
CREATE INDEX ind_7
ON Publication(pubkey);
CREATE INDEX ind_8
ON Publication(title);
CREATE INDEX ind_9
ON Publication(year);

/* 1 */
SELECT a.name,COUNT(p.pubid)
FROM Author a, Authored b, Publication p
WHERE a.id=b.id AND b.pubid=p.pubid AND p.year>='2010'
GROUP BY a.name
ORDER BY COUNT(p.pubid) DESC LIMIT 20;
/*
         name         | count
----------------------+-------
 H. Vincent Poor      |  2099
 Yang Liu             |  1982
 Mohamed-Slim Alouini |  1739
 Dacheng Tao          |  1680
 Yu Zhang             |  1673
 Wei Zhang            |  1610
 Wei Wang             |  1606
 Zhu Han 0001         |  1581
 Lei Wang             |  1434
 Philip S. Yu         |  1413
 Hao Wang             |  1342
 Xin Wang             |  1336
 Wei Liu              |  1314
 Jing Wang            |  1291
 Wei Li               |  1288
 Lajos Hanzo          |  1285
 Yi Zhang             |  1268
 Mohsen Guizani       |  1229
 Lei Zhang            |  1218
 Victor C. M. Leung   |  1193
(20 rows)
*/

/* 2 */
SELECT a.name,COUNT(p.pubid)
FROM Author a, Authored b, Publication p, Inproceedings i
WHERE a.id=b.id AND b.pubid=p.pubid AND b.pubid=i.pubid
GROUP BY a.name
ORDER BY COUNT(p.pubid) DESC LIMIT 20;
/*
         name         | count
----------------------+-------
 Philip S. Yu         |  1018
 Yang Liu             |   956
 Leonard Barolli      |   949
 Hai Jin 0001         |   893
 Wei Wang             |   885
 Wen Gao 0001         |   877
 Luca Benini          |   854
 Wei Zhang            |   851
 Yu Zhang             |   848
 Makoto Takizawa 0001 |   839
 Luc Van Gool         |   833
 H. Vincent Poor      |   810
 Jiawei Han 0001      |   764
 Nassir Navab         |   749
 Thomas S. Huang      |   740
 Lei Zhang            |   739
 Lei Wang             |   729
 Xin Wang             |   722
 Hermann Ney          |   720
 Rolf Drechsler       |   707
(20 rows)
*/

/* 3 */
SELECT a.name,COUNT(p.pubid)
FROM Author a, Authored b, Publication p
WHERE a.id = b.id AND b.pubid = p.pubid AND
      p.pubkey LIKE '%/sigmod/%'
GROUP BY a.name
ORDER BY COUNT(p.pubid) DESC LIMIT 20;
/*
         name          | count
-----------------------+-------
 Marianne Winslett     |   103
 Michael Stonebraker   |    83
 Surajit Chaudhuri     |    70
 H. V. Jagadish        |    69
 Michael J. Franklin   |    69
 Divesh Srivastava     |    66
 Jeffrey F. Naughton   |    62
 Dan Suciu             |    61
 Beng Chin Ooi         |    60
 Michael J. Carey 0001 |    59
 David J. DeWitt       |    59
 Richard T. Snodgrass  |    58
 Tim Kraska            |    53
 Samuel Madden 0001    |    52
 Johannes Gehrke       |    51
 Donald Kossmann       |    50
 Hector Garcia-Molina  |    50
 Joseph M. Hellerstein |    50
 Raghu Ramakrishnan    |    45
 Jiawei Han 0001       |    45
(20 rows)
*/
SELECT a.name,COUNT(p.pubid)
FROM Author a, Authored b, Publication p
WHERE a.id = b.id AND b.pubid = p.pubid AND
      p.pubkey LIKE '%/stoc/%'
GROUP BY a.name
ORDER BY COUNT(p.pubid) DESC LIMIT 20;
/*
           name            | count
---------------------------+-------
 Avi Wigderson             |    59
 Robert Endre Tarjan       |    33
 Ran Raz                   |    32
 Venkatesan Guruswami      |    31
 Moni Naor                 |    29
 Noam Nisan                |    29
 Uriel Feige               |    28
 Santosh S. Vempala        |    28
 Rafail Ostrovsky          |    27
 Mihalis Yannakakis        |    27
 Mikkel Thorup             |    25
 Yin Tat Lee               |    25
 Oded Goldreich 0001       |    25
 Frank Thomson Leighton    |    25
 Moses Charikar            |    24
 Prabhakar Raghavan        |    24
 Christos H. Papadimitriou |    24
 Madhu Sudan 0001          |    23
 Eyal Kushilevitz          |    23
 Ryan O'Donnell            |    22
(20 rows)
*/

/* 4 */
/* (a) */
SELECT a.name
FROM Author a, Authored b, Publication p
WHERE a.id = b.id AND b.pubid = p.pubid AND
      p.pubkey LIKE '%/sigmod/%'
GROUP BY a.name
HAVING COUNT(p.pubid) >= 12
EXCEPT
SELECT a.name
FROM Author a, Authored b, Publication p
WHERE a.id = b.id AND b.pubid = p.pubid AND
      p.pubkey LIKE '%/pods/%'
GROUP BY a.name
HAVING COUNT(p.pubid) > 0;
/*
           name
---------------------------
 Themis Palpanas
 Patrick Valduriez
 Michael Stonebraker
 Jiawei Han 0001
 Philippe Bonnet
 Sudipto Das
 Sanjay Krishnan
 Felix Naumann
 Ihab F. Ilyas
 Martin L. Kersten
 Jian Pei
 Jeffrey Xu Yu
 Jianhua Feng
 Clement T. Yu
 E. F. Codd
 Yuanyuan Tian
 Chengkai Li
 Lei Chen 0002
 Bruce G. Lindsay 0001
 Yinghui Wu
 Xiaofang Zhou 0001
 Alvin Cheung
 Jim Gray 0001
 Gautam Das 0001
 Ryan Marcus
 Eric Lo 0001
 Stefano Ceri
 Ben Kao
 Vasilis Vassalos
 Donald Kossmann
 Arnon Rosenthal
 Jingren Zhou
 Manos Athanassoulis
 Jun Yang 0001
 Jayant Madhavan
 Karl Aberer
 Peter A. Boncz
 Ashraf Aboulnaga
 Stanley B. Zdonik
 Le Gruenwald
 Nan Tang 0001
 Jayavel Shanmugasundaram
 Boon Thau Loo
 Nicolas Bruno
 Nan Zhang 0004
 Eric N. Hanson
 Meihui Zhang 0001
 Peter Bailis
 José A. Blakeley
 Suman Nath
 Mourad Ouzzani
 Wei Wang 0011
 Betty Salzberg
 Volker Markl
 Aaron J. Elmore
 Sourav S. Bhowmick
 Ahmed K. Elmagarmid
 Michael J. Cafarella
 Sebastian Schelter
 Andrew Pavlo
 Stratos Idreos
 Alexandros Labrinidis
 Feifei Li 0001
 Ce Zhang 0001
 Chi Wang 0001
 Jignesh M. Patel
 Sihem Amer-Yahia
 Carlo Curino
 Zhen Hua Liu
 Arie Segev
 M. Tamer Özsu
 Sainyam Galhotra
 Senjuti Basu Roy
 Jim Melton
 Jorge-Arnulfo Quiané-Ruiz
 Andrew Eisenberg
 Rajasekar Krishnamurthy
 Krithi Ramamritham
 Kaushik Chakrabarti
 Hongjun Lu
 Jiannan Wang
 Gang Chen 0001
 Viktor Leis
 Immanuel Trummer
 Gao Cong
 Jens Teubner
 Alfons Kemper
 Dirk Habich
 Ion Stoica
 Bingsheng He
 Anisoara Nica
 Reynold Cheng
 Elke A. Rundensteiner
 Bolin Ding
 Fatma Özcan
 C. J. Date 0001
 Nesime Tatbul
 Anthony K. H. Tung
 Luis Gravano
 Torsten Grust
 James Cheng
 Xu Chu
 Theodoros Rekatsinas
 Aditya G. Parameswaran
 Arash Termehchy
 Hans-Arno Jacobsen
 Barzan Mozafari
 Kevin S. Beyer
 Asuman Dogac
 Lijun Chang
 Ling Liu 0001
 Guy M. Lohman
 Carsten Binnig
 Daniel J. Abadi
 Samuel Madden 0001
 Badrish Chandramouli
 Edgar H. Sibley
 Lu Qin 0001
 Christian S. Jensen
 Vanessa Braganholo
 Bin Cui 0001
 Laura M. Haas
 Amit P. Sheth
 Babak Salimi
 Raymond Chi-Wing Wong
 Xiaokui Xiao
 Anastasia Ailamaki
 Georgia Koutrika
 Ugur Çetintemel
 Ioana Manolescu
 Boris Glavic
 AnHai Doan
 Carlos Ordonez 0001
 Cong Yu 0001
 Zhifeng Bao
 Xifeng Yan
 Nick Roussopoulos
 Tilmann Rabl
 Erhard Rahm
 Matei Zaharia
 Arun Kumar 0001
 Louiqa Raschid
 Lawrence A. Rowe
 Mohamed F. Mokbel
 Jianliang Xu
 Kevin Chen-Chuan Chang
 Eugene Wu 0002
 James P. Fry
 Abolfazl Asudeh
 Alekh Jindal
 Goetz Graefe
 Xin Luna Dong
 Sailesh Krishnamurthy
 Byron Choi
 Qiong Luo 0001
 Guoliang Li 0001
 Tim Kraska
 David B. Lomet
(158 rows)
*/
/* (b) */
SELECT a.name
FROM Author a, Authored b, Publication p
WHERE a.id = b.id AND b.pubid = p.pubid AND
      p.pubkey LIKE '%/pods/%'
GROUP BY a.name
HAVING COUNT(p.pubid) >= 6
EXCEPT
SELECT a.name
FROM Author a, Authored b, Publication p
WHERE a.id = b.id AND b.pubid = p.pubid AND
      p.pubkey LIKE '%/sigmod/%'
GROUP BY a.name
HAVING COUNT(p.pubid) > 0;
/*
          name
-------------------------
 Marco Console
 Kobbi Nissim
 Diego Figueira
 Nofar Carmeli
 Marco Calautti
 Stavros S. Cosmadakis
 Eljas Soisalon-Soininen
(7 rows)
*/

/* Extra */
DROP TABLE IF EXISTS AuthorDecadePub;
CREATE TABLE AuthorDecadePub AS (
SELECT 
    A.id as author_id,
    CAST(P.year AS INTEGER) - CAST(P.year AS INTEGER) % 10 as decade_start,
    COUNT(*) as publication_count
FROM 
    Authored A
JOIN 
    Publication P
ON 
    A.pubid = P.pubid
WHERE 
    CAST(P.year AS INTEGER) % 10 = 0
GROUP BY 
    author_id, 
    decade_start
);

SELECT 
    ADP.decade_start,
    Auth.name as author_name,
    ADP.publication_count
FROM 
    AuthorDecadePub ADP
JOIN 
    Author Auth
ON 
    ADP.author_id = Auth.id
JOIN 
    (SELECT 
        decade_start,
        MAX(publication_count) as max_publication_count
    FROM 
        AuthorDecadePub
    GROUP BY 
        decade_start) AS MaxADP
ON 
    ADP.decade_start = MaxADP.decade_start AND 
    ADP.publication_count = MaxADP.max_publication_count
ORDER BY ADP.decade_start;

DROP TABLE IF EXISTS AuthorDecadePub;
/*
 decade_start |     author_name      | publication_count
--------------+----------------------+-------------------
         1940 | J. C. C. McKinsey    |                 3
         1950 | Hao Wang 0001        |                 4
         1960 | Harry D. Huskey      |                 4
         1960 | G. M. Galler         |                 4
         1960 | Henry C. Thacher Jr. |                 4
         1960 | Boleslaw Sobocinski  |                 4
         1960 | Robert W. Bemer      |                 4
         1960 | Arthur Gill          |                 4
         1970 | Stephen D. Crocker   |                18
         1980 | Grzegorz Rozenberg   |                21
         1990 | Tony Owen            |                27
         2000 | Bill Hancock         |               139
         2010 | Ajith Abraham        |                78
         2020 | H. Vincent Poor      |               261
(14 rows)
*/
