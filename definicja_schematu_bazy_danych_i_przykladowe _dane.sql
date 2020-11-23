--Wykonali: Patrycja Wysocka, Wiktor Szczepanski

--DEFINICJA SCHEMATU BAZY DANYCH
USE new_database
GO

CREATE TABLE uczestnik
    ( id_uczestnika    INT 
       CONSTRAINT  id_uczestnika_nn NOT NULL
    , imie	    VARCHAR(25) 
	, nazwisko	    VARCHAR(25) 
	, stanowisko	VARCHAR(50) 
    );
GO

ALTER TABLE uczestnik ADD CONSTRAINT id_ucze_pk PRIMARY KEY (id_uczestnika) ;
GO

CREATE TABLE miasto
    ( id_miasta   INT 
       CONSTRAINT  id_miejsca_nn NOT NULL
    , miasto	VARCHAR(40) 
	, dlugosc VARCHAR(10)
	, szerokosc VARCHAR(10)
    );
GO

ALTER TABLE miasto ADD CONSTRAINT id_mias_pk PRIMARY KEY (id_miejsca) ;
GO

CREATE TABLE miejsce
    ( id_miejsca    INT 
       CONSTRAINT  id_miejsca_nn NOT NULL 
	, ulica	    VARCHAR(50) 
	, numer    INT
	, placowka    VARCHAR(50) 
	, sala     TINYINT
	, id_miasta INT
    );
GO
ALTER TABLE miejsce ADD CONSTRAINT kur_miej_fk FOREIGN KEY (id_miasta) REFERENCES miasto(id_miasta);
GO
ALTER TABLE miejsce ADD CONSTRAINT id_miej_pk PRIMARY KEY (id_miejsca) ;
GO

CREATE TABLE dziedzina
    ( id_dziedziny    INT 
       CONSTRAINT  id_dziedziny_nn NOT NULL
	, opis	    VARCHAR(50) 
    );
GO

ALTER TABLE dziedzina ADD CONSTRAINT id_dzie_pk PRIMARY KEY (id_dziedziny) ;
GO  

CREATE TABLE oferta 
    ( id_oferty    INT 
       CONSTRAINT  id_oferty_nn NOT NULL 
    , nazwa    VARCHAR(50)
	, data_rozp   SMALLDATETIME 
    , data_zak    SMALLDATETIME
	, cena  MONEY 
	, limit_miejsc INT
	, id_dziedziny INT
	, CONSTRAINT     id_oferty_pk 
        	     PRIMARY KEY (id_oferty)
    ) ; 
GO
ALTER TABLE oferta ADD CONSTRAINT ofer_dzie_fk FOREIGN KEY (id_dziedziny) REFERENCES dziedzina(id_dziedziny);
GO

CREATE TABLE pracownik
    ( id_pracownika    INT 
       CONSTRAINT  id_pracownika_nn NOT NULL
    , imie	    VARCHAR(25) 
	, nazwisko	    VARCHAR(25) 
	, id_dziedziny INT 
    );
GO

ALTER TABLE pracownik ADD CONSTRAINT id_prac_pk PRIMARY KEY (id_pracownika) ;
GO
ALTER TABLE pracownik ADD CONSTRAINT prac_dzie_fk FOREIGN KEY (id_dziedziny) REFERENCES dziedzina (id_dziedziny);
GO

CREATE TABLE kurs 
    ( id_kursu    INT 
       CONSTRAINT  id_kursu_nn NOT NULL 
		,id_oferty INT
		,id_miasta    INT 
		,id_pracownika    INT 
		,CONSTRAINT id_kursu_pk
        	     PRIMARY KEY (id_kursu)

    ) ; 
GO

ALTER TABLE kurs ADD CONSTRAINT kur_mias_fk FOREIGN KEY (id_miasta) REFERENCES miasto(id_miasta);
GO
 
ALTER TABLE kurs ADD CONSTRAINT kur_prac_fk FOREIGN KEY (id_pracownika) REFERENCES pracownik(id_pracownika);
GO 

ALTER TABLE kurs ADD CONSTRAINT kur_ofer_fk FOREIGN KEY (id_oferty) REFERENCES oferta(id_oferty);
GO


CREATE TABLE ocena 
    ( ocena    FLOAT 
    , id_uczestnika       INT 
	 CONSTRAINT  id_uczestnika_nn NOT NULL 
	, id_kursu    INT  
	 CONSTRAINT  id_kursu_nn NOT NULL 
    ) ; 
GO

ALTER TABLE ocena ADD CONSTRAINT ocena_uczestnik_fk FOREIGN KEY (id_uczestnika) REFERENCES uczestnik(id_uczestnika);
GO

ALTER TABLE ocena ADD CONSTRAINT ocena_kurs_fk FOREIGN KEY (id_kursu) REFERENCES kurs(id_kursu);
GO

ALTER TABLE ocena ADD CONSTRAINT ocena_kurs_ucze_pk PRIMARY KEY (id_uczestnika, id_kursu);
GO

--PRZYKLADOWE DANE DO WSTAWIENIA

INSERT INTO uczestnik VALUES 
        ( 1
        , 'Piotr' 
		, 'Zamojski' 
		, 'pracownik biurowy'  
        );

INSERT INTO uczestnik VALUES 
        ( 2
        , 'Roksana' 
		, 'Pietrusiewicz' 
		, 'specjalista ds. obslugi klienta'  
        );

INSERT INTO uczestnik VALUES 
        ( 3
        , 'Maja' 
		, 'Koniczyna' 
		, 'specjalista ds. logistyki'  
        );

INSERT INTO uczestnik VALUES 
        ( 4
        , 'Patrycja' 
		, 'Kowalczyk' 
		, 'specjalista ds. HR'  
        );

INSERT INTO uczestnik VALUES 
        ( 5
        , 'Weronika' 
		, 'Jarzebska' 
		, 'informatyk'  
        );

INSERT INTO uczestnik VALUES 
        ( 6
        , 'Wieslawa' 
		, 'Romanska' 
		, 'ksiegowa'  
        );

INSERT INTO uczestnik VALUES 
        ( 7
        , 'Wiktor' 
		, 'Gmach' 
		, 'mechatronik'  
        );

INSERT INTO uczestnik VALUES 
        ( 8
        , 'Piotr' 
		, 'Lewandowski' 
		, 'logistyk'  
        );

INSERT INTO uczestnik VALUES 
        ( 9
        , 'Renata' 
		, 'Przybylska' 
		, 'specjalista ds. obs?ugi klienta'  
        );

INSERT INTO uczestnik VALUES 
        ( 10
        , 'Dominika' 
		, 'Foremniak' 
		, 'stazystka'  
        );

INSERT INTO uczestnik VALUES 
        ( 11
        , 'Pawel' 
		, 'Zajac' 
		, 'specjalista ds. logistyki'  
        );

INSERT INTO uczestnik VALUES 
        ( 12
        , 'Barbara' 
		, 'Skrzynka' 
		, 'recepcjonistka'  
        );

INSERT INTO uczestnik VALUES 
        ( 13
        , 'Hironim' 
		, 'Malolepszy' 
		, 'ochroniarz'  
        );

INSERT INTO uczestnik VALUES 
        ( 14
        , 'Maria' 
		, 'Walaszczyk' 
		, 'specjalista ds. planowania produkcji'  
        );

INSERT INTO uczestnik VALUES 
        ( 15
        , 'Anna' 
		, 'Jakubowska' 
		, 'specjalista ds. magazynowania'  
        );

INSERT INTO uczestnik VALUES 
        ( 16
        , 'Karolina' 
		, 'Koziol' 
		, 'prawnik'  
        );

INSERT INTO uczestnik VALUES 
        ( 17
        , 'Joanna' 
		, 'Gaj' 
		, 'pielegniarka'  
        );

INSERT INTO uczestnik VALUES 
        ( 18
        , 'Agnieszka' 
		, 'Wielowska' 
		, 'specjalista ds. sprzedazy'  
        );

INSERT INTO uczestnik VALUES 
        ( 19
        , 'Dariusz' 
		, 'Pestka' 
		, 'architekt'  
        );

INSERT INTO uczestnik VALUES 
        ( 20
        , 'Jerzy' 
		, 'Domowicz' 
		, 'informatyk'  
        );
        
INSERT INTO uczestnik VALUES 
        ( 21
        , 'Maria' 
		, 'Kowalska' 
		, 'matematyk'  
        );

INSERT INTO uczestnik VALUES 
        ( 22
        , 'Jan' 
		, 'Kowalski' 
		, 'listonosz'  
        );

INSERT INTO uczestnik VALUES 
        ( 23
        , 'Piotr' 
		, 'Dabrowski' 
		, 'trener personalny'  
        );
        
INSERT INTO uczestnik VALUES 
        ( 24
        , 'Anna' 
		, 'Muras' 
		, 'analityk'  
        );
                
INSERT INTO uczestnik VALUES 
        ( 25
        , 'Piotr' 
		, 'Pogoda' 
		, 'doradca finansowy'  
        );
        
INSERT INTO uczestnik VALUES 
        ( 26
        , 'Zbigniew' 
		, 'Misiak' 
		, 'sekretarz'  
        );      
        
INSERT INTO uczestnik VALUES 
        ( 27
        , 'Jan' 
		, 'Rokitnik' 
		, 'informatyk'  
        );                
  
INSERT INTO uczestnik VALUES 
        ( 28
        , 'Helena' 
		, 'Modrzejewska' 
		, 'stomatolog'  
        );   
        
INSERT INTO uczestnik VALUES 
        ( 29
        , 'Wies³aw' 
		, 'Molski' 
		, 'stolarz'  
        ); 
        
INSERT INTO uczestnik VALUES 
        ( 30
        , 'Ewa' 
		, 'Bystra' 
		, 'kasjerka'  
        );       
 
 CREATE TABLE miasto
    ( id_miasta   INT 
       CONSTRAINT  id_miejsca_nn NOT NULL
    , miasto	VARCHAR(40) 
	
	, dlugosc VARCHAR(10)
	, szerokosc VARCHAR(10)
	, id_miejsca INT
    );
	
INSERT INTO miasto VALUES 
        ( 1
        , 'Lodz'   
		, '19°28`E'
		, '51°47`N'
        );
		
INSERT INTO miasto VALUES 
        ( 2
        , 'Warszawa'  
		, '21°02`E'
		, '52°12`N'
        );
		
INSERT INTO miasto VALUES 
        ( 3
        , 'Poznan'  
		, '16°55`E'
		, '52°25`N'
        );
		
INSERT INTO miasto VALUES 
        ( 4
        , 'Katowice'  
		, '19° E'       
		, '50°15`N'
        );
		
INSERT INTO miasto VALUES 
        ( 5
        , 'Krakow'  
		, '19°57`E'               
		, '50°03`N'
        );
		
INSERT INTO miasto VALUES 
        ( 6
        , 'Zakopane'  
		, '19°57`E'                       
		, '49°18`N'
        );
		
INSERT INTO miasto VALUES 
        ( 7
        , 'Zabrze'  
		, '18°47`E'                               
		, '50°18`N'
        );
		
INSERT INTO miasto VALUES 
        ( 8
        , 'Bialystok'  
		, '23°10`E'                                      
		, '53°08`N'
        );
		
INSERT INTO miejsce VALUES 
        ( 1 
		, 'Pomorska' 
		, '302'  
		, 'Dom Kultury'
		, '20'
		, 1
        );

INSERT INTO miejsce VALUES 
        ( 2
		, 'Aleje Jerozolimskie' 
		, '15'  
		, 'Biblioteka Miejska'
		, '3'
		, 2
        );


INSERT INTO miejsce VALUES 
        ( 3
		, 'Glogowska' 
		, '54'  
		, 'Szkola Podstawowa'
		, '43'
		, 3
        );

INSERT INTO miejsce VALUES 
        ( 4 
		, 'Krakowska' 
		, '2'  
		, 'Palac Mlodziezy'
		, '11'
		, 4
        );

INSERT INTO miejsce VALUES 
        ( 5 
		, 'Jagiellonska' 
		, '67'  
		, 'Biuro'
		, '77'
		, 5
        );     
        
INSERT INTO miejsce VALUES 
        ( 6
		, 'Zielona' 
		, '22'  
		, 'Gimnazjum'
		, '35'
		, 6
        );       
        
        
INSERT INTO miejsce VALUES 
        ( 7 
		, 'Czerwona' 
		, '103'  
		, 'Sala widowiskowa'
		, '51'
		, 7
        );     
        
INSERT INTO miejsce VALUES 
        ( 8
		, 'Kwiatowa' 
		, '99'  
		, 'Dom Kultury'
		, '4'
		, 8
        );     
        
INSERT INTO miejsce VALUES 
        ( 9
		, 'Zielna' 
		, '33'  
		, 'Biblioteka Narodowa'
		, '62'
		, 2
        );    
        
INSERT INTO miejsce VALUES 
        ( 10 
		, 'Pomnikowa' 
		, '11'  
		, 'Pracownia projektowa'
		, '185'
		, 2
        );  

INSERT INTO dziedzina VALUES 
        ( 1
        , 'informatyka'
        );
        
INSERT INTO dziedzina VALUES 
        ( 2
        , 'zarzadzanie'
        );   

INSERT INTO dziedzina VALUES 
        ( 3
        , 'zdrowie'
        );
        
INSERT INTO dziedzina VALUES 
        ( 4
        , 'rozwoj osobisty'
        );  
        
INSERT INTO dziedzina VALUES 
        ( 5
        , 'finanse'
        );  



INSERT INTO oferta VALUES 
        ( 1
        , 'Podstawy programowania C++' 
		, '2017-12-01 10:00:00' 
		, '2017-12-20 12:30:00'
		, '1000' 
		, 15
		, 1
        );

INSERT INTO oferta VALUES 
        ( 2
        , 'Podstawy programowania Java' 
		, '2017-11-30 12:30:00' 
		, '2018-01-10 15:00:00'
		, '1500'
		, 15
		, 1
        );

INSERT INTO oferta VALUES 
        ( 3
        , 'Zarzadzanie zasobami ludzkimi' 
		, '2017-05-10 12:30:00' 
		, '2017-05-20 17:00:00'
		, '750'
		, 15
		, 2
        );

INSERT INTO oferta VALUES 
        ( 4
        , 'Budowanie marki wlasnej' 
		, '2017-01-20 12:00:00' 
		, '2017-03-20 13:00:00'
		, '1000'
		, 15
		, 4
        );

INSERT INTO oferta VALUES 
        ( 5
        , 'Sztuka prezentacji' 
		, '2017-07-18 09:30:00' 
		, '2017-07-29 12:00:00'
		, '850'
		, 15
		, 4
        );

INSERT INTO oferta VALUES 
        ( 6
        , 'Marketing - trendy i nowosci' 
		, '2017-09-30 11:30:00' 
		, '2017-10-03 12:00:00'
		, '400'
		, 15
		, 2
        );

INSERT INTO oferta VALUES 
        ( 7
        , 'Zaawansowane programowanie C++' 
		, '2017-02-13 17:30:00' 
		, '2017-03-30 19:00:00'
		, '950'
		, 15
		, 1
        );

INSERT INTO oferta VALUES 
        ( 8
        , 'Zdrowe odzywianie' 
		, '2017-10-15 10:30:00' 
		, '2017-10-18 10:00:00'
		, '320'
		, 15
		, 3
        );       
        
INSERT INTO oferta VALUES 
        ( 9
        , 'Zdrowie i uroda' 
		, '2018-02-10 10:30:00' 
		, '2018-02-20 18:00:00'
		, '440'
		, 10
		, 3
        );   
        
INSERT INTO oferta VALUES 
        ( 10
        , 'Zarzadzanie personelem' 
		, '2018-03-10 17:30:00' 
		, '2018-03-25 20:00:00'
		, '300'
		, 10
		, 2
        );     
        
INSERT INTO oferta VALUES 
        ( 11
        , 'Zarzadzanie projektami' 
		, '2018-02-01 17:30:00' 
		, '2018-02-25 20:00:00'
		, '520'
		, 10
		, 2
        ); 
        
INSERT INTO oferta VALUES 
        ( 12
        , 'Podstawy zdrowia publicznego' 
		, '2017-11-05 18:30:00' 
		, '2017-11-25 21:00:00'
		, '600'
		, 15
		, 3
        ); 
        
INSERT INTO oferta VALUES 
        ( 13
        , 'Podatki' 
		, '2018-02-03 10:30:00' 
		, '2018-02-25 15:00:00'
		, '750'
		, 15
		, 5
        ); 
        
INSERT INTO oferta VALUES 
        ( 14
        , 'Podstawy controllingu' 
		, '2018-03-13 17:30:00' 
		, '2018-04-16 20:00:00'
		, '800'
		, 15
		, 5
        ); 
        
INSERT INTO oferta VALUES 
        ( 15
        , 'Rachunkowosc od podstaw' 
		, '2018-01-01 11:00:00' 
		, '2018-01-25 15:00:00'
		, '900'
		, 15
		, 5
        );       

        
INSERT INTO pracownik VALUES 
        ( 1
        , 'Piotr' 
		, 'Wroblewski' 
		, 1
        );

INSERT INTO pracownik VALUES 
        ( 2
        , 'Miroslaw' 
		, 'Nowak'  
		, 2
        );

INSERT INTO pracownik VALUES 
        ( 3
        , 'Ewa' 
		, 'Kowalska' 
		, 3 
        );

INSERT INTO pracownik VALUES 
        ( 4
        , 'Jan' 
		, 'Zieba'
		, 4 
        );

INSERT INTO pracownik VALUES 
        ( 5
        , 'Michal' 
		, 'Siminski' 
		, 5
        );

INSERT INTO pracownik VALUES 
        ( 6
        , 'Roman' 
		, 'Zawadzki'   
		, 1
        );

INSERT INTO pracownik VALUES 
        ( 7
        , 'Slawomira' 
		, 'Biadasiewicz' 
		, 2  
        );

INSERT INTO pracownik VALUES 
        ( 8
        , 'Henryk' 
		, 'Zieba'  
		, 3 
        );

INSERT INTO pracownik VALUES 
        ( 9
        , 'Malgorzata' 
		, 'Fraszczynska'  
		, 4
        );

INSERT INTO pracownik VALUES 
        ( 10
        , 'Slawomir' 
		, 'Zielinski'  
		, 5 
        );
 
INSERT INTO pracownik VALUES 
        ( 11
        , 'Anna' 
		, 'Niewiadomska'  
		, 1 
        ); 
        
INSERT INTO pracownik VALUES 
        ( 12
        , 'Zbigniew' 
		, 'Nowacki'  
		, 2
        );      
 
INSERT INTO pracownik VALUES 
        ( 13
        , 'Ewa' 
		, 'Opolska'  
		, 3
        );   
 
INSERT INTO pracownik VALUES 
        ( 14
        , 'Jan' 
		, 'Kot'  
		, 4
        );   
        
INSERT INTO pracownik VALUES 
        ( 15
        , 'Czeslaw' 
		, 'Porowski'  
		, 5
        ); 
          

INSERT INTO kurs VALUES
		( 1
		, 15
		, 3
		, 2
		, 'tak'
		
		);

INSERT INTO kurs VALUES
		( 2
		, 12
		, 4
		, 4
		, 'tak'
		);

  
INSERT INTO kurs VALUES
		( 3
		, 8
		, 5
		, 6
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 4
		, 7
		, 10
		, 8
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 5
		, 6
		, 7
		, 10
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 6
		, 5
		, 2
		, 12
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 7
		, 4
		, 1
		, 14
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 8
		, 3
		, 1
		, 1
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 9
		, 2
		, 8
		, 4
		, 'tak'
		);
		
		
INSERT INTO kurs VALUES
		( 10
		, 1
		, 9
		, 10
		, 'tak'
		);  
		  

INSERT INTO ocena VALUES 
        ( 5
		, 1
		, 1
        );
INSERT INTO ocena VALUES 
        ( 3
		, 3
		, 2
        );

INSERT INTO ocena VALUES 
        ( 4
		, 5
		, 3
        );

INSERT INTO ocena VALUES 
        ( 5
		, 7
		, 4
        );

INSERT INTO ocena VALUES 
        ( 3
		, 8
		, 5
        );
        
 INSERT INTO ocena VALUES 
        ( 4
		, 9
		, 6
        );
        
INSERT INTO ocena VALUES 
        ( 4
		, 10
		, 7
        );    
        
INSERT INTO ocena VALUES 
        ( 5
		, 11
		, 7
        );
        
INSERT INTO ocena VALUES 
        ( 3
		, 15
		, 8
        );
        
INSERT INTO ocena VALUES 
        ( 5
		, 16
		, 9
        );
        
INSERT INTO ocena VALUES 
        ( 4
		, 17
		, 10
        );
        
INSERT INTO ocena VALUES 
        ( 4
		, 19
		, 1
        );
        
INSERT INTO ocena VALUES 
        ( 3
		, 21
		, 2
        );
        
INSERT INTO ocena VALUES 
        ( 5
		, 23
		, 4
        );
        
INSERT INTO ocena VALUES 
        ( 3
		, 25
		, 5
        );  
        
INSERT INTO ocena VALUES 
        ( 3
		, 26
		, 6
        ); 
        
INSERT INTO ocena VALUES 
        ( 4
		, 27
		, 7
        ); 
        
INSERT INTO ocena VALUES 
        ( 3
		, 28
		, 8
        ); 
        
INSERT INTO ocena VALUES 
        ( 5
		, 29
		, 9
        ); 
        
INSERT INTO ocena VALUES 
        ( 3
		, 30
		, 10
        );
