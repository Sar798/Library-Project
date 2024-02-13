create database library;
use library;

create table publisher(
PublisherName varchar(255) primary key,
PublisherAddress varchar(255),
PublisherPhone varchar(255));

create table borrower(
CardNo int primary key auto_increment,
BorrowerName varchar(255),
BorrowerAddress varchar(255),
BorrowerPhone varchar(255)
)auto_increment = 100;

create table library_branch(
BranchID int primary key auto_increment,
BranchName varchar(255),
BranchAddress varchar(255)
)auto_increment = 1;

create table book(
BookID int primary key  auto_increment,
Title varchar(255) not null,
PublisherName varchar(255),
foreign key(PublisherName)
references publisher(PublisherName)
);


create table book_authors(
AuthorID int primary key auto_increment,
BookID int ,
AuthorName varchar(255),
foreign key(BookID) references book(BookID)
)auto_increment=1;

create table book_copies(
CopiesID int primary key auto_increment,
BookID int,
BranchID int,
NoOfCopies int not null,
foreign key(BookID)
references book(BookID),
foreign key(BranchID) references library_branch(BranchID)
);

create table book_loans(
LoansID int primary key auto_increment,
BookID int,
BranchID int,
CardNo int,
DateOut date,
DueDate date,
foreign key(BookID)
references book(BookID),
foreign key(BranchID) references library_branch(BranchID),
foreign key(CardNo) references borrower(CardNo)
);


select * from library_branch;
select * from book;
select * from publisher;
select * from borrower;
select * from book_authors;
select * from book_loans;
select * from book_copies;

-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select * from book_copies;
select title,NoOfCopies  as No_Of_Copies from book
join library_branch
join book_copies
using (bookid)
where title = 'The Lost Tribe' and branchname=  "Sharpstown"
group by title,NoOfCopies;

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT library_branch.BranchName, COUNT(book_copies.BookID) AS num_copies
FROM library_branch
JOIN book_copies ON library_branch.BranchID = book_copies.BranchID
JOIN book ON book_copies.BookID = book.BookID
WHERE book.title = 'The Lost Tribe'
GROUP BY library_branch.BranchName;

-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select * from borrower;
select BorrowerName from borrower as b
left join book_loans as l
using (CardNo)
where dateout is null;


/*SELECT 
    *
FROM
    book_loans;
select borrowername from book_loans
join borrower
using (cardno)
where dateout>duedate;
*/
-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

SELECT 
    b.title, b_r.BorrowerName, b_r.BorrowerAddress
FROM
    book AS b
        JOIN
    book_loans AS b_l ON b.BookID = b_l.BookID
        JOIN
    library_branch AS l_b ON b_l.BranchID = l_b.BranchID
        JOIN
    borrower AS b_r ON b_l.CardNo = b_r.CardNo
WHERE
    b_l.duedate = '2018-03-02'
        AND l_b.BranchName = 'sharpstown';


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select BranchName,count(*) as total_no_books from book
join book_loans
using (BookId)
join library_branch
using (BranchId)
group by BranchName
;


-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select BorrowerName , BorrowerAddress,count(BorrowerName) as no_of_books from borrower
join book_loans
using (CardNo)
join book
using (BookId)

group by BorrowerName , BorrowerAddress
having count(BorrowerName)>5
order by count(BorrowerName)
;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select Title,NoOfCopies from book as b
join book_authors as a
on b.BookID = a.BookID
join book_copies as bc
on b.BookID = bc.BookID
join library_branch as l
on bc.BranchID = l.BranchID
where a.AuthorName='stephen king' and l.BranchName = 'central'
;

