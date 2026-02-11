-- Veri Tabanı Oluşturma
CREATE DATABASE NovaStoreDB;

GO
-- Veri Tabanını Kullanma
USE NovaStoreDB;

GO
-- Tabloların Oluşturulması
-- Categories Tablosu
CREATE TABLE
    Categories (
        CategoryID INT IDENTITY (1, 1) PRIMARY KEY,
        CategoryName VARCHAR(50) NOT NULL
    );

-- Customers Tablosu
CREATE TABLE
    Customers (
        CustomerID INT IDENTITY (1, 1) PRIMARY KEY,
        FullName VARCHAR(50),
        City VARCHAR(20),
        Email VARCHAR(100) UNIQUE
    );