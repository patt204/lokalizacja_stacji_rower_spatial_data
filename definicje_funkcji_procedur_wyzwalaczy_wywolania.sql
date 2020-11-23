--Wykonali: Patrycja Wysocka, Wiktor Szczepanski

USE new_database
GO

--FUNKCJE I PROCEDURY

--1.FUNKCJA
--obliczajaca podwyzke/obnizke ceny danego kursu z numerem 
--identyfikacyjnym kursu i wielkoscia podwyzki/obnizki w postaci parametrow.

--Definicja:
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE = 'FN' AND name = 'podwyzka_obnizka') DROP FUNCTION podwyzka_obnizka
GO
CREATE FUNCTION podwyzka_obnizka(@id_oferty INT, @pod_obn FLOAT)
RETURNS INT
AS
BEGIN
DECLARE @nowacena1 INT
IF @pod_obn != 0
SELECT @nowacena1 = cena * (1 + @pod_obn)
FROM oferta WHERE @id_oferty = id_oferty
ELSE
SELECT @nowacena1 = cena
FROM oferta WHERE @id_oferty = id_oferty
RETURN @nowacena1
END

--Wywolanie:
SELECT [dbo].[podwyzka_obnizka]('1','-0.05') AS 'Nowa Cena';


--2. FUNKCJA
--Z parametrem prostym zliczajaca jaki procent utargu calkowitego 
--stanowi utarg z kursu zadanego w parametrze (procentowy udzial utargu 
--danego kursu na tle calego utargu z kursow).

--Definicja:
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE = 'FN' AND name = 'udzial') DROP FUNCTION udzial
GO
CREATE FUNCTION Udzial (@id int)
RETURNS FLOAT
AS
BEGIN
DECLARE @budzet1 FLOAT
DECLARE @budzet_cal FLOAT
DECLARE @utarg FLOAT

SELECT @budzet1=SUM(cena) FROM oferta AS ofe
INNER JOIN  kurs k
INNER JOIN ocena o 
INNER JOIN uczestnik u
ON u.id_uczestnika=o.id_uczestnika
ON o.id_kursu=k.id_kursu
ON k.id_oferty=ofe.id_oferty
WHERE @id=ofe.id_oferty
GROUP BY ofe.nazwa, ofe.cena,
k.id_oferty, ofe.id_oferty;
IF (@budzet1 = 0) SET @utarg=0
ELSE
SELECT @budzet_cal = SUM(cena) FROM oferta AS ofe
INNER JOIN  kurs k
INNER JOIN ocena o 
INNER JOIN uczestnik u
ON u.id_uczestnika=o.id_uczestnika
ON o.id_kursu=k.id_kursu
ON k.id_oferty=ofe.id_oferty
SET @utarg = (@budzet_dz *100)/@budzet_cal

RETURN ROUND(@utarg,2) 
END;


--Wywolanie:
select dbo.Udzial('2') as 'Udzial w %';



--3.PROCEDURA
--Z parametrami, obliczajaca dlugosc danego kursu w dniach, cene za dzien 
--oraz wyswietlajaca komunikat o tym, czy oferta jest droga czy tania.

--Definicja:
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE = 'P' AND name = 'procedure1') DROP PROCEDURE procedure1
GO
CREATE PROCEDURE procedure1
WITH RECOMPILE
AS
SET NOCOUNT ON
BEGIN
DECLARE @sumacen money
SELECT @sumacen = SUM(cena) 
FROM oferta;
DECLARE @sumadl INT
SELECT @sumadl = SUM(datediff(dd, data_rozp, data_zak))
FROM oferta;
SELECT nazwa, cena, DATEDIFF(dd, data_rozp, data_zak) AS ilosc_dni,
cena/DATEDIFF(dd, data_rozp, data_zak) AS srednia_cena_za_dzien,
CASE
WHEN cena/DATEDIFF(dd, data_rozp, data_zak) < @sumacen/@sumadl THEN 'Tania oferta'
WHEN cena/DATEDIFF(dd, data_rozp, data_zak) = @sumacen/@sumadl THEN 'Oferta w sredniej cenie'
ELSE 'Droga oferta'
END AS ocena_ceny
FROM oferta
END

--Wywolanie:
exec procedure1;



--4.PROCEDURA
--Z parametrem, wyswietlajaca liste dziedzin, które spelniaja okreslone kryterium 
--znakowe w nazwie i maja numer identyfikacyjny niepodzielny przez dwa.

--Definicja:
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE = 'P' AND name = 'listadziedzin') DROP PROCEDURE listadziedzin
GO
CREATE PROCEDURE listadziedzin
@wzoropisu varchar(25) = '%'
AS
BEGIN
IF @wzoropisu IS NOT NULL
SELECT id_dziedziny, opis
FROM dziedzina
WHERE opis LIKE @wzoropisu AND id_dziedziny%2 = 1
END

--Wywolanie:
EXEC listadziedzin 'Z%'



--5. PROCEDURA
--z zadeklarowanym kursorem, umozliwiajacym wyswietlenie ilosci wszystkich 
--zajec uruchomionych w okreslonym w parametrze roku.

--Definicja:
IF EXISTS(SELECT 1 FROM sys.objects WHERE TYPE = 'P' AND name = 'zajecia_roku') DROP PROCEDURE zajecia_roku
GO
CREATE PROCEDURE zajecia_roku
@rok INT
AS
DECLARE @nazwa VARCHAR(50),
@data_rozp smalldatetime,
@data_zak smalldatetime,
@il INT

SET @il=1;
DECLARE dane_zajec1 CURSOR 
FORWARD_ONLY
FOR SELECT nazwa, data_rozp, data_zak 
FROM oferta
WHERE YEAR(data_rozp)=@rok;
OPEN dane_zajec1;
FETCH NEXT FROM dane_zajec1 
INTO @nazwa, @data_rozp, @data_zak;
PRINT 'Dane zajec z roku' + ' ' + CONVERT(VARCHAR(4),@rok)
WHILE @@FETCH_STATUS = 0
BEGIN
IF @nazwa != NULL
PRINT 'Dane zajec' + CONVERT(VARCHAR(3),@il) + ':' + @nazwa + '-' + YEAR(@data_rozp) + '-' + YEAR(@data_zak) + ';';
SET @il+=1;
FETCH NEXT FROM dane_zajec1
INTO @nazwa, @data_rozp, @data_zak;
END
PRINT 'W roku' + ' ' + CONVERT(VARCHAR(4),@rok) + ' ' + 'pojawilo sie w ofercie' + ' ' + convert(varchar(4),@il-1) + ' ' +'szkolen.'
CLOSE dane_zajec1;
DEALLOCATE dane_zajec1;

--Wywolanie:
EXEC zajecia_roku 2017;



--WYZWALACZE

--5. WYZWALACZ
--Uruchamiany dla polecen UPDATE, zapisujacy wprowadzone zmiany 
--z tabeli uczestnik w dodatkowej tabeli audyt wraz z rodzajem 
--tych zmian i ich godzina.

--Definicja:
CREATE TRIGGER dodaj_uczestnika
ON uczestnik
FOR INSERT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @id_uczestnika INT
DECLARE @calosc VARCHAR(50)
DECLARE @akcja VARCHAR(50)
SELECT @id_uczestnika=id_uczestnika
FROM inserted
SELECT @calosc=(SELECT imie + ' ' + nazwisko 
FROM inserted)
SELECT @akcja='Wiersz wprowadzony'
CREATE TABLE audyt1
    ( id_uczestnika int
	, nazwisko VARCHAR(25)
	, akcja VARCHAR(50)
	, czas DATETIME
    )
INSERT INTO audyt1(id_uczestnika, nazwisko, akcja, czas)
VALUES (@id_uczestnika, @calosc, @akcja, GETDATE())
END

--Wywolanie:
INSERT INTO uczestnik VALUES 
        ( 21
        , 'Marian'
        , 'Dolek'
        , 'finansista'
        );



--6. WYZWALACZ
--Uruchamiany dla polecen DELETE, zapisujacy wprowadzone zmiany 
--z tabeli uczestnik w dodatkowej tabeli audyt wraz z rodzajem tych 
--zmian i ich godzina.

--Definicja:
CREATE TRIGGER usun_uczestnika
ON uczestnik
AFTER DELETE
AS
BEGIN
DECLARE @id_uczestnika int
DECLARE @calosc varchar(50)
DECLARE @akcja varchar(500)
SET @akcja='Wiersz usuniety'
CREATE TABLE audyt2
    ( id_uczestnika int
	, nazwisko VARCHAR(25)
	, akcja VARCHAR(50)
	, czas datetime
    )
INSERT INTO audyt2(id_uczestnika, nazwisko, akcja, czas)
SELECT d.id_uczestnika, d.imie + ' ' + d.nazwisko, @akcja, GETDATE()
FROM deleted d
END

--Wywolanie:
DELETE FROM uczestnik where id_uczestnika = 31



--7. WYZWALACZ
--Uruchamiany dla polecen UPDATE, wyswietlajacy biezaca date i czas, 
--jesli bedzie aktualizoawana tabela uczestnik

--Definicja:
CREATE TRIGGER wyswietl_date_i_czas
ON uczestnik
FOR UPDATE
AS
PRINT GETDATE()
GO

--Wywolanie:
UPDATE uczestnik
SET imie = 'Artur'
WHERE id_uczestnika = 1;