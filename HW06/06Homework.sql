\qecho Leonille Matunan
\c db03
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
-- Query below
\qecho #1
INSERT INTO corecord(libcardID, bookID, coDate, ciDueDate)
SELECT
    libcard.id,
    book.id,
    '2021-10-01',
    '2021-10-08'
FROM
    libcard,
    book
WHERE
    libcard.barcode = '0028613547'
    AND book.barcode = '0737494331';
-- Update
UPDATE
    book
SET
    liblocationid = NULL
WHERE
    book.barcode = '0737494331';
\qecho
\qecho Check #1
SELECT
    count(*) AS "numCheckedOut"
FROM
    Corecord
WHERE
    corecord.libcardid =(
        SELECT
            id
        FROM
            libcard
        WHERE
            barcode = '0028613547');
SELECT
    count(*) AS "book count"
FROM
    book
WHERE
    book.barcode = '0737494331'
    AND book.liblocationid IS NULL;

/* #2– Check in the book you checked out in #1 */
UPDATE
    corecord
SET
    cidate = CURRENT_DATE -- Set this to the actual check-in date
WHERE
    bookID =(
        SELECT
            id
        FROM
            book
        WHERE
            barcode = '0737494331')
    AND libcardID =(
        SELECT
            id
        FROM
            libcard
        WHERE
            barcode = '0028613547')
    AND cidate IS NULL;
UPDATE
    book
SET
    liblocationid =(
        SELECT
            id
        FROM
            liblocation
        WHERE
            name = 'In Checkin Cart') -- or set it to the default location if 'NULL' is not appropriate
WHERE
    barcode = '0737494331';
-- Ensures only records without a check-in date are updated
\qecho #2
-- Query below
\qecho 
\qecho Check #2
SELECT
    count(*) AS numincart
FROM
    book
WHERE
    book.liblocationid = 5;
SELECT
    count(*) AS numCheckedOut
FROM
    corecord
WHERE
    libcardid =(
        SELECT
            id
        FROM
            libcard
        WHERE
            barcode = '0028613547')
    AND cidate IS NOT NULL;

/* #3 add a new genre to the database
● The new type is “550 Fans”
● Return the ID ( surrogate key) for future calls in this question ( IE you may use the returned
auto-generated key in this question)
● Associate any book with the word ‘green’ in the description to this genre
● Ignore case for the match IE ‘GreEnish’ would match.
You may use the surrogate primary key returned from the insert in your commands.
Use a single command to add the associations for all of the books that include ‘green
 */
-- Query below
\qecho #3
WITH new_genre AS (
INSERT INTO genre(name)
        VALUES ('550 Fans')
    RETURNING
        id AS genre_id
), associated_books AS (
INSERT INTO bookcattogenre(bookcatid, genreid)
    SELECT
        bookcat.id,
        ng.genre_id
    FROM
        bookcat,
        new_genre ng
    WHERE
        lower(bookcat.description)
        LIKE '%green%'
    RETURNING
        bookcatid,
        genreid
)
SELECT
    genre_id
FROM
    new_genre;
\qecho
\qecho Check #3
SELECT
    *
FROM
    BookCatToGenre
WHERE
    BookCatToGenre.Genreid = 12
ORDER BY
    BookCatid;

/*#4 The library has decided that the SF Classic ‘Dune’ ( bookCat.ID = 576) promotes drug use. They want
to remove all mention of the book anywhere in the database ( bookCat, book, genre, etc)
You may use the Surrogate key for the book ( 576) in your commands.
Hint – think about what to remove first
 */
\qecho #4
-- Query below
DELETE FROM bookcattogenre
WHERE bookcatid = 576;
DELETE FROM booktoauthor
WHERE bookcatid = 576;
DELETE FROM book
WHERE bookcatid = 576;
DELETE FROM bookcat
WHERE id = 576;
\qecho Check #4
SELECT
    count(*) AS numcat
FROM
    bookCat
WHERE
    bookCat.id = 576;
SELECT
    count(*) AS numBook
FROM
    Book
WHERE
    bookcatid = 576;

/*
#5 We want to create a new customer and their library card
● Customer info
o firstName ‘George’
o lastName ‘Spelvin’
o email ‘Pseudonum@gmail.com’
o address ‘1234 Plain Street’
o City ‘Rochester’
o State ‘NY’
● Library Card
o BarCode ‘B123456789’
o Issue Date 1/15/2323
You may use the Surrogate PK of the created customer when you crate the library card record
Check Queries
 */
\qecho #5
-- Query below
WITH inserted_customer AS (
INSERT INTO customer(firstname, lastname, email, address1, city, stateid, postalcode)
        VALUES ('George', 'Spelvin', 'Pseudonum@gmail.com', '1234 Plain Street', 'Rochester', 'NY', NULL)
    RETURNING
        id AS customer_id)
    -- Insert library card using the customer_id from the inserted_customer CTE
    INSERT INTO libcard(customerid, barcode, issuedate, isactive)
    SELECT
        customer_id,
        'B123456789',
        '2323-01-15'::timestamp,
        TRUE
    FROM
        inserted_customer;
\qecho Check #5
SELECT
    *
FROM
    Customer
WHERE
    firstName = 'George'
    AND lastName = 'Spelvin';
SELECT
    *
FROM
    Libcard
WHERE
    libcard.customerid = 102;

/*
#6 Georgina Spelvin has lost her library card. Deactivate the lost card and give her a new one.
You may do a query to get the surrogate ID for Georginia Spelvin and use that ID in your subsequent
commands.
● Creation date for the new library card is 1/5/2023
● Barcode for new card is ‘X123456789
 */
-- Query below
\qecho #6
SELECT
    *
FROM
    customer
WHERE
    firstname = 'Georgina'
    AND lastname = 'Spelvin';
WITH lost_card AS (
    SELECT
        id
    FROM
        customer
    WHERE
        firstname = 'Georgina'
        AND lastname = 'Spelvin'
),
deactivate_card AS (
    UPDATE
        libcard
    SET
        isactive = FALSE
    WHERE
        customerid IN (
            SELECT
                id
            FROM
                lost_card)
        RETURNING
            id -- Returns IDs of deactivated cards
)
    INSERT INTO libcard(customerid, barcode, issuedate, isactive)
    SELECT
        id,
        'X123456789',
        '2023-01-05'::timestamp,
        TRUE
    FROM
        lost_card;
\qecho 
\qecho Check #6
SELECT
    count(*) AS numlibcards
FROM
    Libcard;
SELECT
    count(*) AS numactivecards
FROM
    Libcard
WHERE
    isactive = TRUE;
SELECT
    *
FROM
    Libcard
WHERE
    customerid = 50
    AND isactive;

/*
#7 Add a new bookCatalog entry to the system.
● Title ‘A Stich in Time’
● Description ‘One Second’
● Isbn ‘183456789’
● Ddnum 482.123
● Genres ‘Thriller’ and ‘Romance’
● No Author
You may return the surrogate ID for the new entry to use in setting up Genre records
You man NOT use the surrogate key for the Thriller and Romance genre in your code
 */
\qecho #7
-- Query below
WITH new_bookcat AS (
INSERT INTO bookcat(title, description, isbn, ddnum)
        VALUES ('A Stitch in Time', 'One Second', '183456789', 482.123)
    RETURNING
        id AS bookcat_id
), link_genres AS (
INSERT INTO bookcattogenre(bookcatid, genreid)
    SELECT
        new_bookcat.bookcat_id,
        genre.id
    FROM
        new_bookcat,
        genre
    WHERE
        genre.name IN ('Thriller', 'Romance')
    RETURNING
        genreid
)
SELECT
    bookcat_id
FROM
    new_bookcat;
-- Check Below
\qecho 
\qecho Check #7
SELECT
    count(*) AS "num Thriller"
FROM
    bookcatToGenre
    JOIN genre ON (genre.id = bookCatToGenre.genreid)
WHERE
    genre.name ILIKE 'Thriller';
SELECT
    count(*) AS "num Romance"
FROM
    bookcatToGenre
    JOIN genre ON (genre.id = bookCatToGenre.genreid)
WHERE
    genre.name ILIKE 'Romance';

/*
#8 For the bookCat you added in #7 – add three instances to the database of the book.
● Book barcodes are ‘C123456789', 'D123456789', 'E123456789'
● Location of books is in ‘Cart’
● You man NOT use the surrogate PK of the BookCat for this problem
 */
\qecho #8
--Query below
INSERT INTO book(bookcatid, barcode, liblocationid)
SELECT
    bookcat.id,
    unnest(ARRAY['C123456789', 'D123456789', 'E123456789']),
(
        SELECT
            id
        FROM
            liblocation
        WHERE
            name = 'Cart') -- Assuming 'Cart' is a valid location
FROM
    bookcat
WHERE
    bookcat.isbn = '183456789';
\qecho 
\qecho Check #8
SELECT
    count(*) AS numNewBooks
FROM
    book
    JOIN bookcat ON (book.bookcatid = bookcat.id)
WHERE
    bookcat.isbn = '183456789';

/*
#9 A water leak has damaged all of the books in the checkin cart. They have been moved to Repair.
Update the database to show that all books in the checking cart have been moved to repair. Use a
single update statement.
 */
\qecho #9
-- Query below
UPDATE
    book
SET
    liblocationid = 3
WHERE
    liblocationid =(
        SELECT
            id
        FROM
            liblocation
        WHERE
            name = 'In Checkin Cart');
\qecho Check #9
SELECT
    count(*) AS NumInRepair
FROM
    book
WHERE
    liblocationid = 3;

/*
#10 The repair department has determined that the following books ( identified by their bar code)
0214219368, 0366461513, 0661141665
Delete these books from the database in a single statement
 */
\qecho #10
-- Query below
DELETE FROM book
WHERE barcode IN ('0214219368', '0366461513', '0661141665');
\qecho 
\qecho Check #10
SELECT
    count(*) AS NumInRepair
FROM
    book
WHERE
    liblocationid = 3;
ROLLBACK;

