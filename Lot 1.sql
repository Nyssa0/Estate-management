
-- -----------------------------------------------------------------------------
--      Projet : Application de gestion de lotissements
--      Auteur : Archibald SABATIER & Hassina AYACHI
--      Date de dernière modification : 15/05/2020
-- -----------------------------------------------------------------------------

alter session set nls_date_format = 'DD/MM/RRRR';

REM SUPPRESSION des tables et des sequences

DROP TABLE PARCELLE CASCADE CONSTRAINTS;
DROP TABLE LOTISSEMENT CASCADE CONSTRAINTS;
DROP TABLE AGENCE CASCADE CONSTRAINTS;
DROP TABLE AGENT CASCADE CONSTRAINTS;
DROP TABLE GERER CASCADE CONSTRAINTS;
DROP TABLE ENGAGER CASCADE CONSTRAINTS;


DROP SEQUENCE SeqParcelle;
DROP SEQUENCE SeqLotissement;
DROP SEQUENCE SeqAgence;
DROP SEQUENCE SeqAgent;


REM CREATION des sequences

CREATE SEQUENCE SeqParcelle START WITH 1 MINVALUE 0 INCREMENT BY 1;
CREATE SEQUENCE SeqLotissement START WITH 1 MINVALUE 0 INCREMENT BY 1;
CREATE SEQUENCE SeqAgence START WITH 1 MINVALUE 0 INCREMENT BY 1;
CREATE SEQUENCE SeqAgent START WITH 1 MINVALUE 0 INCREMENT BY 1;


REM CREATION des tables

-- -----------------------------------------------------------------------------
--       TABLE : PARCELLE
-- -----------------------------------------------------------------------------
REM CREATION TABLE PARCELLE

CREATE TABLE PARCELLE
   (
   	No_Parc INTEGER NOT NULL,
   	Reference_Parc VARCHAR(32) UNIQUE NOT NULL,
   	No_Loti INTEGER
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : LOTISSEMENT
-- -----------------------------------------------------------------------------
REM CREATION TABLE LOTISSEMENT

CREATE TABLE LOTISSEMENT
   (
   	No_Loti INTEGER NOT NULL,
   	Nom_Loti VARCHAR(32) NOT NULL,
   	NbreAgent INTEGER NOT NULL,
   	CAGlobal NUMBER
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : AGENCE
-- -----------------------------------------------------------------------------
REM CREATION TABLE AGENCE

CREATE TABLE AGENCE
   (
   	No_Agence INTEGER NOT NULL,
   	Nom_Agence VARCHAR(32) NOT NULL,
   	Site_Agence VARCHAR(32)
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : AGENT
-- -----------------------------------------------------------------------------
REM CREATION TABLE AGENT

CREATE TABLE AGENT
   (
   	No_Agent INTEGER NOT NULL,
   	Nom_Agent VARCHAR(32) NOT NULL,
   	Prenom_Agent VARCHAR(32),
   	Specialite_Agent VARCHAR(32),
   	Mail_Agent VARCHAR(64),
   	Portable_Agent VARCHAR(15),
   	No_Agence INTEGER
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : GERER
-- -----------------------------------------------------------------------------
REM CREATION TABLE GERER

CREATE TABLE GERER
   (
   	Vente CHAR(1),
   	NoParc INTEGER,
   	NoAgent INTEGER
   ) ;

-- -----------------------------------------------------------------------------
--       TABLE : ENGAGER
-- -----------------------------------------------------------------------------
REM CREATION TABLE ENGAGER

CREATE TABLE ENGAGER
   (
   	DateEngage DATE,
   	NoLoti INTEGER,
   	NAgent INTEGER
   ) ;

-- -----------------------------------------------------------------------------
--       MISE EN PLACE DES CONTRAINTES
-- -----------------------------------------------------------------------------
REM Création des contraintes

ALTER TABLE LOTISSEMENT
	ADD CONSTRAINT PK_AS_No_Loti PRIMARY KEY (No_Loti) --clé primaire No_Loti de la table LOTISSEMENT--
	;

ALTER TABLE AGENCE
	ADD CONSTRAINT PK_AS_No_Agence PRIMARY KEY (No_Agence) --clé primaire No_Agence de la table AGENCE--
	;

ALTER TABLE AGENT
	ADD CONSTRAINT PK_AS_No_Agent PRIMARY KEY (No_Agent) --clé primaire No_Agent de la table AGENT--
	ADD CONSTRAINT FK_AS_No_Agence FOREIGN KEY (No_Agence) REFERENCES AGENCE (No_Agence) --clé étrangère No_Agence de la table AGENT--
	;

ALTER TABLE PARCELLE 
     ADD CONSTRAINT PK_AS_No_Parc PRIMARY KEY (No_Parc) --clé primaire No_Parc de la table PARCELLE--
     ADD CONSTRAINT FK_AS_No_Loti_Parc FOREIGN KEY (No_Loti) REFERENCES LOTISSEMENT (No_Loti) --clé étrangère No_Loti de la table PARCELLE--
    ;

ALTER TABLE GERER
	ADD CONSTRAINT FK_AS_No_Parc FOREIGN KEY (NoParc) REFERENCES PARCELLE (No_Parc) --clé étrangère NoParc de la table GERER--
	ADD CONSTRAINT FK_AS_No_Agent_Gerer FOREIGN KEY (NoAgent) REFERENCES AGENT (No_Agent) --clé étrangère NoAgent de la table GERER--
	;

ALTER TABLE ENGAGER
	ADD CONSTRAINT FK_AS_No_Loti_Enga FOREIGN KEY (NoLoti) REFERENCES LOTISSEMENT (No_Loti) --clé étrangère NoLoti de la table ENGAGER--
	ADD CONSTRAINT FK_AS_No_Agent_Enga FOREIGN KEY (NAgent) REFERENCES AGENT (No_Agent) --clé étrangère NAgent de la table ENGAGER--
	;

REM Création du jeu d''essai

REM INSERTION dans la table LOTISSEMENT

insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement1', 2, 10000);
insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement2', 5, 69000);
insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement3', 1, 12000);
insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement4', 3, 42000);
insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement5', 2, 17000);
insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement6', 4, 73800);
insert into LOTISSEMENT (No_Loti,Nom_Loti,NbreAgent,CAGlobal) values (SeqLotissement.NEXTVAL, 'Lotissement7', 1, 93000);

REM INSERTION dans la table AGENCE

insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceParis', 'Paris');
insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceMoscou', 'Moscou');
insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceTokyo', 'Tokyo');
insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceGareDuNord', 'GareDuNord');
insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceLondres', 'Londres');
insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceCuba', 'Cuba');
insert into AGENCE (No_Agence,Nom_Agence,Site_Agence) values (SeqAgence.NEXTVAL, 'AgenceMiami', 'Miami');

REM INSERTION dans la table AGENT

insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Freecs', 'Gon', 'Appartement', 'Gon.Freecs@gmail.com', '0664728432', 1);
insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Zoldyck', 'Killua', 'Manoir', 'Killua.Zoldyck@gmail.com', '0664819364', 2);
insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Tetsuya', 'Kuroko', 'Maison', 'Kuroko.Tetsuya@gmail.com', '0672548934', 3);
insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Uzumaki', 'Naruto', 'Studio', 'Naruto.Uzumaki@gmail.com', '0626409735', 7);
insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Yukihira', 'Soma', 'Restaurant', 'Soma.Yukihira@gmail.com', '0673910253', 3);
insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Izuku', 'Midoriya', 'Academie', 'Midoriya.Izuku@gmail.com', '0673926483', 5);
insert into AGENT (No_Agent,Nom_Agent,Prenom_Agent,Specialite_Agent, Mail_Agent, Portable_Agent, No_Agence) values (SeqAgent.NEXTVAL, 'Ackerman', 'Livai', 'Caserne', 'Livai.Ackerman@gmail.com', '0618352940', 6);

REM INSERTION dans la table ENGAGER

insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('12/01/2019',1,1);
insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('01/05/2019',1,2);
insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('06/12/2019',2,3);
insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('27/02/2019',2,4);
insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('24/06/2019',2,5);
insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('26/06/2019',7,6);
insert into ENGAGER (DateEngage,NoLoti,NAgent) values ('19/09/2019',7,7);

REM INSERTION dans la table PARCELLE

insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle1', 2);
insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle2', 6);
insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle3', 4);
insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle4', 3);
insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle5', 2);
insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle6', 1);
insert into PARCELLE (No_Parc,Reference_Parc,No_Loti) values (SeqParcelle.NEXTVAL, 'Parcelle7', 5);

REM INSERTION dans la table GERER

insert into GERER (Vente,NoParc,NoAgent) values ('O',1,1);
insert into GERER (Vente,NoParc,NoAgent) values ('N',4,2);
insert into GERER (Vente,NoParc,NoAgent) values ('O',3,3);
insert into GERER (Vente,NoParc,NoAgent) values ('N',2,4);
insert into GERER (Vente,NoParc,NoAgent) values ('O',2,5);
insert into GERER (Vente,NoParc,NoAgent) values ('N',6,2);
insert into GERER (Vente,NoParc,NoAgent) values ('O',4,6);
insert into GERER (Vente,NoParc,NoAgent) values ('O',4,1);
insert into GERER (Vente,NoParc,NoAgent) values ('O',3,5);
insert into GERER (Vente,NoParc,NoAgent) values ('O',1,3);
insert into GERER (Vente,NoParc,NoAgent) values ('O',1,4);
