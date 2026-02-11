-- Veri Tabanı Oluşturma
CREATE DATABASE NovaStoreDB;

-- #region BÖLÜM 1 - DDL (Data Definition Language)
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

-- #endregion
-- #region BÖLÜM 2 - DML (Data Manipulation Language)
USE NovaStoreDB;

GO
-- 1. KATEGORİLER
INSERT INTO
    Categories (CategoryName)
VALUES
    ('Elektronik'),
    ('Giyim'),
    ('Kitap'),
    ('Kozmetik'),
    ('Ev ve Yaşam');

-- ÜRÜNLER
INSERT INTO
    Products (ProductName, Price, Stock, CategoryID)
VALUES
    -- Elektronik
    ('Laptop', 25000, 15, 1),
    ('Akıllı Telefon', 18000, 25, 1),
    ('Bluetooth Kulaklık', 1200, 40, 1),
    -- Giyim
    ('T-Shirt', 350, 60, 2),
    ('Kot Pantolon', 900, 30, 2),
    -- Kitap
    ('SQL Öğreniyorum', 250, 20, 3),
    ('Veri Bilimi 101', 300, 18, 3),
    -- Kozmetik
    ('Parfüm', 1500, 12, 4),
    ('Yüz Temizleme Jeli', 200, 50, 4),
    -- Ev ve Yaşam
    ('Kahve Makinesi', 3200, 8, 5),
    ('Masa Lambası', 450, 22, 5),
    ('Halı', 2000, 5, 5);

-- MÜŞTERİLER
INSERT INTO
    Customers (FullName, City, Email)
VALUES
    ('Ahmet Yılmaz', 'İstanbul', 'ahmet@gmail.com'),
    ('Ayşe Demir', 'Ankara', 'ayse@gmail.com'),
    ('Mehmet Kaya', 'İzmir', 'mehmet@gmail.com'),
    ('Zeynep Şahin', 'Bursa', 'zeynep@gmail.com'),
    ('Can Karaca', 'Antalya', 'can@gmail.com'),
    ('Elif Arslan', 'Adana', 'elif@gmail.com');

-- SİPARİŞLER
INSERT INTO
    Orders (CustomerID, OrderDate, TotalAmount)
VALUES
    (1, '2026-02-01', 26200),
    (2, '2026-02-02', 1250),
    (3, '2026-02-03', 300),
    (1, '2026-02-05', 1500),
    (4, '2026-02-06', 350),
    (5, '2026-02-07', 3200),
    (6, '2026-02-08', 2000),
    (2, '2026-02-09', 18000);

-- SİPARİŞ DETAYLARI
INSERT INTO
    OrderDetails (OrderID, ProductID, Quantity)
VALUES
    (1, 1, 1),
    (1, 3, 1),
    (2, 4, 2),
    (3, 7, 1),
    (4, 8, 1),
    (5, 4, 1),
    (6, 10, 1),
    (7, 12, 1),
    (8, 2, 1);

-- #endregion
-- #region BÖLÜM 3 - DQL (Data Query Language)
-- Temel Listeleme:Stok miktarı 20'den az olan ürünlerin adını ve stok miktarını, stok miktarına göre "AZALAN" sırada listeler.
SELECT
    ProductName,
    Stock
FROM
    Products
WHERE
    Stock < 20
ORDER BY
    Stock DESC;

-- Veri Birleştirme (JOIN):: Hangi müşteri, hangi tarihte sipariş vermiş? Sonuçta Müşteri Adı, Şehir, Sipariş Tarihi ve Toplam Tutar gözükür.
SELECT
    c.FullName,
    c.City,
    o.OrderDate,
    o.TotalAmount
FROM
    Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY
    o.OrderDate;

-- Çoklu Birleştirme ve Detay Raporu:müşterinin aldığı ürünlerin isimlerini, fiyatlarını ve kategorilerini listeler.
SELECT
    c.FullName,
    p.ProductName,
    p.Price,
    cat.CategoryName
FROM
    Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE
    c.FullName = 'Ahmet Yılmaz';

-- Gruplama ve Aggregate Fonksiyonlar: Hangi kategoride toplam kaç adet ürün olduğunu listeler.
SELECT
    cat.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM
    Categories cat
    LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY
    cat.CategoryName
ORDER BY
    ProductCount DESC;

-- Ciro Analizi: Her müşterinin şirkete kazandırdığı toplam ciroyu, en çok harcama yapandan en aza doğru sıralar.   
SELECT
    c.FullName,
    SUM(o.TotalAmount) AS TotalRevenue
FROM
    Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY
    c.FullName
ORDER BY
    TotalRevenue DESC;

-- Zaman Analizi:Bugünün tarihine göre, siparişlerin üzerinden kaç gün geçtiğini hesaplayan bir sorgu.
SELECT
    OrderID,
    OrderDate,
    DATEDIFF (DAY, OrderDate, GETDATE ()) AS DaysSinceOrder
FROM
    Orders;

-- #endregion
-- #region BÖLÜM 4 - İleri Seviye Veri Tabanı Nesneleri
-- VIEW: Sipariş Özet Görünümü
CREATE VIEW
    vw_SiparisOzet AS
SELECT
    c.FullName,
    o.OrderDate,
    p.ProductName,
    od.Quantity
FROM
    Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID;

-- View kontrol sorgusu
SELECT
    *
FROM
    vw_SiparisOzet;

-- Databace Backup Script

DECLARE @BackupFolder NVARCHAR(260) = N'C:\Yedek'; -- Yedeklerin kaydedileceği klasör yolu
DECLARE @BackupPath NVARCHAR(400); -- Yedek dosyasının tam yolu (klasör + dosya adı)
DECLARE @Date NVARCHAR(20); -- Yedek dosyasına tarih eklemek için kullanılacak değişken

-- Database var mı kontrolü, Database mevcut değilse işlem durdurulur.
IF DB_ID(N'NovaStoreDB') IS NULL
BEGIN
    RAISERROR('NovaStoreDB does not exist.', 16, 1); -- Database yoksa hata mesajı verir
    RETURN;
END
-- Database ONLINE mı kontrolü, Offline / Restoring durumunda backup alınamaz.
IF EXISTS (
    SELECT 1 -- Kayda değer eklenmez, sadece varlık kontrolü yapılır
    FROM sys.databases -- SQL Server’ın sistem görünümüdür, Sunucudaki tüm veritabanlarının bilgilerini tutar.
    WHERE name = N'NovaStoreDB' -- Veritabanı adı
      AND state_desc <> 'ONLINE' -- Eğer veritabanı ONLINE değilse…
)
BEGIN
    RAISERROR('NovaStoreDB is not ONLINE.', 16, 1); -- Veritabanı ONLINE değilse hata mesajı verir
    RETURN;
END
-- Tarih formatı oluştur (YYYYMMDD_HHMMSS), Aynı isimli dosya çakışmasını engeller.
SELECT @Date =
REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), '-', ''), ' ', '_'), ':', '');

SET @BackupPath =
@BackupFolder + N'\NovaStoreDB_Backup_' + @Date + N'.bak'; -- Yedek dosyasının tam yolu (örneğin: C:\Yedek\NovaStoreDB_Backup_20260201_153000.bak)

-- C diskinde Yedek Klasör yoksa oluşturmayı dene, xp_create_subdir bazı sistemlerde kapalı olabilir.Hata oluşursa backup aşamasında yakalanacaktır.
BEGIN TRY
    EXEC master.dbo.xp_create_subdir @BackupFolder;
END TRY
BEGIN CATCH
    -- Klasör zaten varsa veya yetki yoksa burada sessiz geçilir
END CATCH

-- Backup işlemi. FORMAT kullanılmadı (media header silme riskine karşı)

BEGIN TRY

    BACKUP DATABASE NovaStoreDB
    TO DISK = @BackupPath
    WITH 
        INIT,-- dosya varsa üzerine yazar
        COMPRESSION,-- disk alanı tasarrufu sağlar
        CHECKSUM, -- veri bütünlüğü kontrolü yapar
        STATS = 10; -- ilerleme durumunu %10 aralıklarla gösterir

    PRINT 'Backup completed successfully.';
    PRINT 'Backup file: ' + @BackupPath;

END TRY
BEGIN CATCH

    PRINT 'Backup failed.';
    PRINT ERROR_MESSAGE();
    RETURN;

END CATCH

-- Backup doğrulama, oluşturulan yedeğin bozuk olup olmadığını kontrol eder.
BEGIN TRY

    RESTORE VERIFYONLY -- Yedek dosyasının doğruluğunu kontrol eder, geri yükleme yapmaz
    FROM DISK = @BackupPath 
    WITH CHECKSUM;

    PRINT 'Backup verification successful.';

END TRY
BEGIN CATCH

    PRINT 'Backup verification failed.';
    PRINT ERROR_MESSAGE();

END CATCH;
GO


--#endregion