# **Proje Yönergesi: NovaStore E-Ticaret Veri Yönetim Sistemi**

Projenin Amacı:

Bu proje, 5 günlük SQL eğitiminde öğrendiğiniz veri tabanı tasarımı, tablo oluşturma, ilişkilendirme ve karmaşık sorgu yazma (Join, Group By, Subquery) becerilerinizi gerçek hayat senaryosu üzerinde uygulamanızı hedefler.

Senaryo:

Yeni kurulan "NovaStore" adlı e-ticaret sitesinin veri tabanı yöneticisi (DBA) olarak atandınız. Şirket sizden; ürünlerin, müşterilerin ve siparişlerin tutulacağı ilişkisel bir veri tabanı tasarlamanızı ve yönetim için gerekli raporları SQL ile hazırlamanızı beklemektedir.

---

### **BÖLÜM 1: Veri Tabanı Tasarımı (Logical Design ve DDL)**

İlk olarak veri tabanı iskeletini oluşturmalısınız. Aşağıdaki tablo yapılarını ve kurallarını CREATE TABLE komutlarını kullanarak SQL Server'da kodlayınız.

**İpucu:** Tabloları oluştururken "Foreign Key" (Yabancı Anahtar) bağımlılıklarına dikkat ediniz. Önce ana tabloları (Categories, Customers), sonra bağımlı tabloları (Products, Orders) oluşturmalısınız.

#### **1\. Veri Tabanı Oluşturma**

* **Veri tabanı adı:** NovaStoreDB

#### **2\. Tablo Gereksinimleri**

**A. Tablo: Categories (Kategoriler)**

* CategoryID (int, PK): Otomatik artan (Identity 1,1).

* CategoryName (varchar(50)): Boş geçilemez (Not Null).

**B. Tablo: Products (Ürünler)**

* ProductID (int, PK): Otomatik artan.

* ProductName (varchar(100)): Boş geçilemez.

* Price (decimal(10,2)): Ürün fiyatı.

* Stock (int): Stok adedi (Varsayılan değer 0 olsun).

* CategoryID (int, FK): *Categories* tablosuna bağlanacak.

     **C. Tablo: Customers (Müşteriler)**

* CustomerID (int, PK): Otomatik artan.

* FullName (varchar(50)): Müşteri adı soyadı.

* City (varchar(20)): Şehir bilgisi.

* Email (varchar(100)): E-posta adresi (Unique/Benzersiz olmalı).

     **D. Tablo: Orders (Siparişler)**

* OrderID (int, PK): Otomatik artan.

* CustomerID (int, FK): *Customers* tablosuna bağlanacak.

* OrderDate (datetime): Sipariş tarihi (Varsayılan değer GETDATE() olsun).

* TotalAmount (decimal(10,2)): Toplam sipariş tutarı.

     **E. Tablo: OrderDetails (Sipariş Detayları \- Ara Tablo)**

* DetailID (int, PK): Otomatik artan.

* OrderID (int, FK): *Orders* tablosuna bağlanacak.

* ProductID (int, FK): *Products* tablosuna bağlanacak.

* Quantity (int): Kaç adet alındığı.

---

### **BÖLÜM 2: Veri Girişi (DML \- Insert)**

Sistemi test edebilmek için "Dummy Data" (Örnek Veri) girişi yapmalısınız.

* **Görev 1:** 5 adet Kategori ekleyin (Örn: Elektronik, Giyim, Kitap, Kozmetik, Ev ve Yaşam).

* **Görev 2:** Her kategoriye ait olacak şekilde toplamda en az 10-12 Ürün ekleyin.

* **Görev 3:** 5-6 adet Müşteri kaydı oluşturun.

* **Görev 4:** Farklı tarihlerde yapılmış en az 8-10 Sipariş ve bu siparişlere ait Sipariş Detayları girin.

*Not: Bu aşamada ChatGPT veya benzeri bir AI aracından "SQL Server için insert scriptleri oluştur" şeklinde yardım alarak verileri hızlıca hazırlayabilirsiniz (Müfredat 5\. Gün konusu).*

---

### **BÖLÜM 3: Sorgulama ve Analiz (DQL \- Select ve Joins)**

Yönetim kurulu sizden aşağıdaki soruların cevaplarını raporlamanızı istiyor. Her madde için uygun SQL sorgusunu yazınız.

**1\. Temel Listeleme:**

* **Soru:** Stok miktarı 20'den az olan ürünlerin adını ve stok miktarını, stok miktarına göre "AZALAN" sırada listeleyin.

* ***Kullanılacaklar:*** SELECT, WHERE, ORDER BY. 

**2\. Veri Birleştirme (JOIN):**

* **Soru:** Hangi müşteri, hangi tarihte sipariş vermiş? Sonuçta Müşteri Adı, Şehir, Sipariş Tarihi ve Toplam Tutar gözüksün.

* ***Kullanılacaklar:*** INNER JOIN (Customers ve Orders tabloları). 

**3\. Çoklu Birleştirme ve Detay Raporu:**

* **Soru:** "Ahmet Yılmaz" (veya verinizdeki bir müşteri) isimli müşterinin aldığı ürünlerin isimlerini, fiyatlarını ve kategorilerini listeleyin.

* ***Kullanılacaklar:*** JOIN (Customers, Orders, OrderDetails, Products, Categories tabloları zincirleme bağlanacak). 

**4\. Gruplama ve Aggregate Fonksiyonlar:**

* **Soru:** Hangi kategoride toplam kaç adet ürünümüz var? (Örn: Elektronik \- 5 ürün).

* ***Kullanılacaklar:*** GROUP BY, COUNT(), LEFT JOIN. 

**5\. Ciro Analizi (Zor):**

* **Soru:** Her müşterinin şirkete kazandırdığı toplam ciro nedir? En çok harcama yapan müşteriden en aza doğru sıralayın.

* ***Kullanılacaklar:*** SUM(), GROUP BY, ORDER BY. 

**6\. Zaman Analizi:**

* **Soru:** Bugünün tarihine göre, siparişlerin üzerinden kaç gün geçtiğini hesaplayan bir sorgu yazın.

* ***Kullanılacaklar:*** DATEDIFF(), GETDATE(). 

---

### 

### **BÖLÜM 4: İleri Seviye Veri Tabanı Nesneleri**

**1\. View (Görünüm) Oluşturma:**

* Sürekli uzun JOIN sorguları yazmamak için; **Müşteri Adı**, **Sipariş Tarihi**, **Ürün Adı** ve **Adet** bilgilerini tek bir tablodaymış gibi getiren vw\_SiparisOzet isminde bir VIEW oluşturun.

* ***Konu:*** CREATE VIEW. 

**2\. Yedekleme (Backup):**

* Projenizi tamamladıktan sonra NovaStoreDB veri tabanının C:\\Yedek\\ klasörüne yedeğini alan T-SQL komutunu yazın.

* ***Konu:*** BACKUP DATABASE. 

---

### **BÖLÜM 5: Teslim Formatı**

* Tüm adımları (Tablo oluşturma, Veri ekleme, Sorgular) içeren tek bir .sql dosyası hazırlayın.

* Dosya içinde “\--" Yorum Satırları kullanarak hangi sorgunun hangi göreve ait olduğunu belirtin.

* Bir Word dosyası oluşturun. Bu dosyada kodlarınızı Markdown (kod kutusu) stiliyle düzenleyin, elde ettiğiniz tabloların ekran görüntüsünü alıp yapıştırın ve altına gerekli açıklamaları ekleyin.

* Oluşturulan tabloların ilişkisel yapısını tek bir ekran görüntüsü olacak şekilde alın.

* **Dosya adı:** 

  * AdSoyad\_NovaStore\_Proje.sql

  * AdSoyad\_NovaStore\_Proje.docx

  * AdSoyad\_NovaStore\_Proje.png

---

