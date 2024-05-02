\qecho Leonille Matunan
ALTER SEQUENCE Genre_id_seq
    RESTART WITH 12;

ALTER SEQUENCE customer_id_seq
    RESTART WITH 102;

ALTER SEQUENCE Libcard_id_seq
    RESTART WITH 113;

ALTER SEQUENCE bookCat_id_seq
    RESTART WITH 1350;

BEGIN;

/* #1 Perform a checkout on the book 0737494331 ('War of the Worlds)
to library Card 0028613547. Do not use a surrogate key in any of your statements 
or enter your own date */
-- #1 CheckQueries
\qecho #1
SELECT count (*) as "numCheckedOut"
FROM Corecord
WHERE corecord.libcardid = ( SELECT id FROM libcard WHEREbarcode =
'0028613547')
;

\qecho
\qecho Check #1
SELECT count (*) as "numCheckedOut"
FROM Corecord
WHERE corecord.libcardid = ( SELECT id FROM libcard WHEREbarcode =
'0028613547')
;
SELECT count (*) as "book count"
FROM book
WHERE book.barcode = '0737494331' AND book.liblocationid IS NULL;




ROLLBACK;

