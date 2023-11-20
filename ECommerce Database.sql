-- Creating the E-Commerce database
CREATE DATABASE ECommerce;
USE ECommerce;

-- Create Genre table to normalize genres
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100) UNIQUE NOT NULL
);

-- Create Products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    genre_id INT,
    price DECIMAL(10, 2) NOT NULL,
    star_rating INT,   
    image_url VARCHAR(512),
    availability VARCHAR(50),     
    UNIQUE (product_name, genre_id), -- ensures unique product name for each genre
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);


-- Create Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    registration_date DATE NOT NULL
);

-- Create Transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    transaction_date DATE NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create Reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    review_date DATE NOT NULL,
    review_text TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create Suppliers table
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_info TEXT,
    UNIQUE (supplier_name) -- ensures each supplier name is unique
);

-- Advanced Options: Procedures, Triggers, and Events

-- create a procedure to get all products of a particular genre.
DELIMITER //
CREATE PROCEDURE GetProductsByGenre(IN genre_name VARCHAR(100))
BEGIN
    SELECT p.* 
    FROM products p 
    JOIN genres g ON p.genre_id = g.genre_id
    WHERE g.genre_name = genre_name;
END //
DELIMITER ;

-- This can be called using CALL GetProductsByGenre('NAME_OF_GENRE');

-- Database was populated via jupyter notebooking using the ETL process

ALTER TABLE products 
CHANGE COLUMN price `price (£)` DECIMAL(10, 2) NOT NULL;


-- Some books were loaded with a genre_name 'Add a comment', this will be updated to bear 'Unknown' instead.
-- First, update the related products from 'Add a comment' to 'Unknown'
UPDATE products
JOIN genres ON products.genre_id = genres.genre_id
SET products.genre_id = (SELECT genre_id FROM genres WHERE genre_name = 'Unknown')
WHERE genres.genre_name = 'Add a comment';

-- Now, delete the 'Add a comment' genre
DELETE FROM genres WHERE genre_name = 'Add a comment';


/*
The column name price (£) contains a space and a special character, 
which means you have to use backticks (`) around it to correctly 
reference it in SQL.
*/


-- SIMPLE QUERIES

-- List All Products with their Prices:
SELECT product_name, `price (£)` 
FROM products;

-- List All Genres
SELECT DISTINCT genre_name 
FROM genres;

-- ADVANCED QUERIES

-- List the Top 5 Most Expensive Products with their Genre
SELECT p.product_name, p.`price (£)`, g.genre_name 
FROM products p
JOIN genres g ON p.genre_id = g.genre_id
ORDER BY p.`price (£)` DESC 
LIMIT 5;

-- Find the Average Price of Products in Each Genre
SELECT g.genre_name, AVG(p.`price (£)`) AS average_price
FROM products p
JOIN genres g ON p.genre_id = g.genre_id
GROUP BY g.genre_name
ORDER BY average_price DESC;

-- List the Products with a Rating of 5, but Price Less Than £20
SELECT p.product_name, p.`price (£)`, p.star_rating
FROM products p
WHERE p.star_rating = 5 AND p.`price (£)` < 20
ORDER BY p.`price (£)` ASC;
















