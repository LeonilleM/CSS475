\qecho Leonille Matunan
/* 
#1 List all author’s who are not being used with any book ( 5 points)
Column Names: firstname, lastname
Order by author.id
 */
\qecho #1
SELECT
    author.firstname,
    author.lastname
FROM
    author
    LEFT JOIN bookToAuthor ON author.id = bookToAuthor.authorID
WHERE
    bookToAuthor.authorID IS NULL
ORDER BY
    author.id;


/*
#2 List all books who do not have an author associated with them
Column names: id, title By id I mean the bookCat.id
Order By bookCat.id
 */
\qecho #2
SELECT
    bookCat.id,
    bookCat.title
FROM
    bookCat
    LEFT JOIN bookToAuthor ON bookCat.id = bookToAuthor.bookCatId
WHERE
    bookToAuthor.bookCatId IS NULL
ORDER BY
    bookCat.id;


/*
#3 Find the Author.id for all books that have a genre.name that includes the string ‘Science’ This will
not use an outer join, but should be useful in #4 . Note the number of rows in your output vs the
answer key ( 5 points)
Column Names: id
Order by author. id;
 */
\qecho #3
SELECT
    author.id
FROM
    author
    INNER JOIN bookToAuthor ON author.id = bookToAuthor.authorID
    INNER JOIN bookCat ON bookToAuthor.bookCatID = bookCat.id
    INNER JOIN bookCatToGenre ON bookCat.id = bookCatToGenre.bookCatID
    INNER JOIN genre ON bookCatToGenre.genreID = genre.id
WHERE
    genre.name LIKE '%Science%';


/*
#4 Find how many authors do not have a book with a genre.name that include the string ‘Science’ Use
an outer join for this query (Perhaps the one you developed in #3)
Column Names: numNonScienceAuthors
( 5 points)
HINT – To check your work, you might want to compare the total number of authors with the results of
#3 + #4. They should be the same value ( num authors with book genre of science + num authors with
no book genre of science = total number of authors. */
\qecho #4
SELECT
    COUNT(DISTINCT author.id) AS numNonScienceAuthors
FROM
    author
WHERE
    author.id NOT IN (
        SELECT
            booktoauthor.authorid
        FROM
            booktoauthor
            JOIN bookcat ON booktoauthor.bookcatid = bookcat.id
            JOIN bookcattogenre ON bookcat.id = bookcattogenre.bookcatid
            JOIN genre ON bookcattogenre.genreid = genre.id
        WHERE
            genre.name LIKE '%Science%');


/*
#5 Find customer.id, firstname, lastname for any customers who do not have an active library card ( 5
points)
Column Names id, firstname, lastname
Order by customer.id */
\qecho #5
SELECT
    customer.id,
    customer.firstname,
    customer.lastname
FROM
    customer
    LEFT JOIN libcard ON customer.id = libcard.customerid
        AND libcard.isActive = TRUE
WHERE
    libcard.id IS NULL
ORDER BY
    customer.id;


/*
#6 Find any genres that are not being used. ( 10 points)
Column names name
Order by genre.id
 */
\qecho #6
SELECT
    genre.name
FROM
    genre
    LEFT JOIN bookCatToGenre ON genre.id = bookCatToGenre.genreID
WHERE
    bookCatToGenre.genreID IS NULL
ORDER BY
    genre.id;


/*
#7 Find the count of the number of times each genre is referenced by a book title. ( 10 points)
Column names genrename, genretotal
Order by genretotal */
\qecho #7
SELECT
    genre.name AS genrename,
    COUNT(bookCatToGenre.genreID) AS genretotal
FROM
    genre
    LEFT JOIN bookCatToGenre ON genre.id = bookCatToGenre.genreID
GROUP BY
    genre.id
ORDER BY
    genretotal;


/*
#8 Each book is referenced by 0 or more genres. Provide a query that shows the total number of books
that are referred to by 0 genre, 1 genre, 2 genres, etc . ( 10 points)
Column names genre_count, numbooks
Order by genre_count; */
\qecho #8
SELECT
    genre_count,
    COUNT(*) AS numbooks
FROM (
    SELECT
        bookCat.id,
        COUNT(DISTINCT bookCatToGenre.genreID) AS genre_count
    FROM
        bookCat
    LEFT JOIN bookCatToGenre ON bookCat.id = bookCatToGenre.bookCatID
GROUP BY
    bookCat.id) AS genre_counts
GROUP BY
    genre_count
ORDER BY
    genre_count;


/*
#9 Find all phone numbers for all customers who do not have an active library card . ( 10 points)
Column names: customerid, firstname.,Lastname, phonetypeid, number
Order by customer.id, phone.number
 */
\qecho #9
SELECT
    customer.id AS customerid,
    customer.firstname,
    customer.lastname,
    phone.phonetypeid,
    phone.number
FROM
    CUSTOMER
    LEFT JOIN libcard ON customer.id = libcard.customerid
        AND libcard.isActive = TRUE
    LEFT JOIN phone ON customer.id = phone.customerid
WHERE
    libcard.id IS NULL
ORDER BY
    customer.id,
    phone.number;


/*
#10 Find all cell phones for all customers who do not have an active library card. Print ‘None’ is no cell
number. ( 10 points)
Column names: id, firstname.,Lastname, number
Order by customer.id */
\qecho #10
SELECT
    customer.id,
    customer.firstname,
    customer.lastname,
    COALESCE(phone.number, 'None') AS number
FROM
    customer
    LEFT JOIN libcard ON customer.id = libcard.customerid
        AND libcard.isActive = TRUE
    LEFT JOIN phone ON customer.id = phone.customerid
        AND phone.phonetypeid = 'C'
WHERE
    libcard.id IS NULL
ORDER BY
    customer.id;


/*
#11 Find the number of customer who have not checked out a book since 2022-02-01. Use an outer
join in the final query. To check your work I want you to print the results of three queries for this
problem ( 15 points 5 each query below)
● Print the number of customers
Column Name: numcustomers ( no outer join)
 */
\qecho #11A
SELECT
    COUNT(DISTINCT customer.id) AS numcustomers
FROM
    customer;


/* # 11B ● Print the customerid FOR EACH customer that HAS checked checked out a book since 2022 - 02 - 01(NO
 OUTER JOIN)
COLUMN Name: customerid
ORDER By: customerid */
\qecho #11B
SELECT DISTINCT
    customer.id AS customerid
FROM
    customer
    JOIN libcard ON customer.id = libcard.customerid
    LEFT JOIN CORecord ON libcard.id = CORecord.libcardid
WHERE
    CORecord.CODATE >= '2022-02-01'
ORDER BY
    customer.id;


/*
#11C
● Print the customerid for each customer that HAS NOT checked checked out a book since 2022-
02-01 (outer join)
Column Name: customerid
Order By: customerid
 */
\qecho #11C
SELECT
    customer.id AS customerid
FROM
    customer
    LEFT JOIN libcard ON customer.id = libcard.customerid
    LEFT JOIN CORecord ON libcard.id = CORecord.libcardid
GROUP BY
    customer.id
HAVING
    MAX(CORecord.CODATE) < '2022-02-01'
    OR MAX(CORecord.CODATE) IS NULL
ORDER BY
    customer.id;


/*
 # 12 What books IN category ‘Computer Science ’ have never been checked out ?(10 points)
COLUMN Names: id,
title */
\qecho #12
SELECT
    bookCat.id,
    bookCat.title
FROM
    bookCat
    JOIN bookCatToGenre ON bookCat.id = bookCatToGenre.bookCatID
    JOIN genre ON bookCatToGenre.genreID = genre.id
WHERE
    genre.name = 'Computer Science'
    AND NOT EXISTS (
        SELECT 1
        FROM book
        JOIN CORecord ON book.id = CORecord.bookID
        WHERE book.bookCatID = bookCat.id
    )
ORDER BY
    bookCat.id;


