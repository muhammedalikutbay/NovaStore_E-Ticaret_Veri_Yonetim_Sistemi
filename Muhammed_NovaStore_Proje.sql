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

-- Products Tablosu
CREATE TABLE
    Products (
        ProductID INT IDENTITY (1, 1) PRIMARY KEY,
        ProductName VARCHAR(100) NOT NULL,
        Price DECIMAL(10, 2),
        Stock INT DEFAULT 0,
        CategoryID INT,
        CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
    );

-- Orders Tablosu
CREATE TABLE
    Orders (
        OrderID INT IDENTITY (1, 1) PRIMARY KEY,
        CustomerID INT,
        OrderDate DATETIME DEFAULT GETDATE (),
        TotalAmount DECIMAL(10, 2),
        CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID)
    );

-- OrderDetails Tablosu
CREATE TABLE
    OrderDetails (
        DetailID INT IDENTITY (1, 1) PRIMARY KEY,
        OrderID INT,
        ProductID INT,
        Quantity INT,
        CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
        CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products (ProductID)
    );