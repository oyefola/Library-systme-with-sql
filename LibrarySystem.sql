CREATE DATABASE Library;
USE Library;
CREATE TABLE Books (
    isbn INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL,
    PRIMARY KEY (isbn)
);
CREATE TABLE BookCopy (
    copy_number INT NOT NULL AUTO_INCREMENT,
    isbn INT NOT NULL,
    PRIMARY KEY (copy_id),
    status VARCHAR(100) NOT NULL,
    FOREIGN KEY (isbn) REFERENCES Books(isbn)
);
CREATE TABLE Borrower (
    card_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    PRIMARY KEY (card_id)
);
CREATE TABLE BookLoan (
    loan_id INT NOT NULL AUTO_INCREMENT,
    isbn INT NOT NULL,
    copy_number INT NOT NULL,
    card_id INT NOT NULL,
    date_out DATE NOT NULL,
    due_date DATE NOT NULL,
    date_in DATE,
    PRIMARY KEY (loan_id),
    FOREIGN KEY (isbn) REFERENCES Books(isbn),
    FOREIGN KEY (copy_number) REFERENCES BookCopy(copy_number),
    FOREIGN KEY (card_id) REFERENCES Borrower(card_id)
);
CREATE Table Librarians(
    librarian_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    PRIMARY KEY (librarian_id)
);
CREATE VIEW BooksOnLoan AS
SELECT Books.isbn, Books.title, Books.author, BookCopy.copy_number, BookCopy.status, BookLoan.card_id, BookLoan.date_out, BookLoan.due_date, BookLoan.date_in
FROM Books
INNER JOIN BookCopy ON Books.isbn = BookCopy.isbn
INNER JOIN BookLoan ON BookCopy.copy_number = BookLoan.copy_number;

DELIMITER //
CREATE PROCEDURE GetOverdueLoan(isbn INT)
BEGIN
    SELECT Books.isbn, Books.title, Books.author, BookCopy.copy_number, BookCopy.status, BookLoan.card_id, BookLoan.date_out, BookLoan.due_date, BookLoan.date_in
    FROM Books
    INNER JOIN BookCopy ON Books.isbn = BookCopy.isbn
    INNER JOIN BookLoan ON BookCopy.copy_number = BookLoan.copy_number
    WHERE Books.isbn = isbn AND BookLoan.due_date < CURDATE();
END //
-- Insert data into the Books table
INSERT INTO Books (isbn, title, author) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald'),
(2, 'To Kill a Mockingbird', 'Harper Lee'),
(3, '1984', 'George Orwell'),
(4, 'Pride and Prejudice', 'Jane Austen'),
(5, 'The Catcher in the Rye', 'J.D. Salinger');

-- Insert data into the BookCopy table
INSERT INTO BookCopy (copy_number, isbn, status) VALUES
(101, 1, 'Available'),
(102, 1, 'Available'),
(103, 2, 'Available'),
(104, 3, 'Reserved'),
(105, 4, 'Checked Out');

-- Insert data into the Borrower table
INSERT INTO Borrower (card_id, name, address, phone) VALUES
(201, 'John Doe', '123 Main St, Cityville', '555-1234'),
(202, 'Jane Smith', '456 Oak St, Townsville', '555-5678'),
(203, 'Bob Johnson', '789 Pine St, Villageton', '555-9012');

-- Insert data into the BookLoan table
INSERT INTO BookLoan (loan_id, isbn, copy_number, card_id, date_out, due_date, date_in) VALUES
(301, 1, 101, 201, '2023-01-01', '2023-01-15', NULL),
(302, 2, 103, 202, '2023-02-01', '2023-02-15', '2023-02-10'),
(303, 3, 104, 203, '2023-03-01', '2023-03-15', NULL);

-- Insert data into the Librarians table
INSERT INTO Librarians (librarian_id, name, address, phone) VALUES
(401, 'Alice Johnson', '987 Elm St, Hamletown', '555-3456'),
(402, 'Bob Smith', '654 Birch St, Woodsville', '555-7890');

-- A query and subquery to select people who hav overdue loans
SELECT 
name FROM Borrower
WHERE card_id IN (
    SELECT 
    card_id FROM BookLoan
    WHERE due_date < CURDATE()
);