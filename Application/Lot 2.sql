
-- -----------------------------------------------------------------------------
--      Projet : Application de gestion de lotissements
--      Auteur : Archibald SABATIER & Hassina AYACHI
--      Date de dernière modification : 15/05/2020
-- -----------------------------------------------------------------------------

REM Création du package LotissementPack

CREATE OR REPLACE PACKAGE LotissementPack IS

FUNCTION AGENTCONTINGENT (NoLot INTEGER) RETURN number;
PROCEDURE CHANGERCONTINGENT (Nombre NUMBER, NoLot NUMBER);
PROCEDURE LOTISSEMENTCONTINGENT;
PROCEDURE AFFICHAGEVENTEPARC (NoParcel INTEGER);
PROCEDURE AFFICHAGEVENTELOT (NoLot INTEGER);
PROCEDURE CREATIONENGAGEMENT (NoLot integer, NoAg integer);

END LotissementPack;
/

REM Mise en place des fonctions et procédures

CREATE OR REPLACE PACKAGE BODY LotissementPack IS

--Fonction qui calcule le nombre d'agents engagés pour un lotissement--
FUNCTION AGENTCONTINGENT (NoLot INTEGER) RETURN number IS
NbAgent number;
BEGIN
select count(NAgent) into NbAgent from engager where NoLoti = NoLot;
return NbAgent;

END AGENTCONTINGENT;

--Procédure qui change le nombre maximum d'agents engagés--
PROCEDURE CHANGERCONTINGENT (Nombre NUMBER, NoLot NUMBER) IS
nbreavant number;
nbreactu number;
BEGIN
select NbreAgent into nbreavant from LOTISSEMENT where No_Loti = NoLot;
UPDATE LOTISSEMENT set NbreAgent = NbreAgent + Nombre where No_Loti = NoLot;
FOR tuple IN (SELECT Nom_Loti as nom, NbreAgent as nbre FROM lotissement where No_Loti = NoLot) LOOP
DBMS_OUTPUT.PUT_LINE('Le nombre d''agents maximum du ' || tuple.nom || ' passe de ' || nbreavant || ' à ' || tuple.nbre || '.');
END LOOP;

select NbreAgent into nbreactu from lotissement where No_Loti = NoLot;
IF nbreactu <= 0 THEN 
RAISE_APPLICATION_ERROR (-20001, 'Nombre maximum d''agents négatif');
END IF;

END CHANGERCONTINGENT;

--Procédure qui affiche la liste des lotissements ainsi que leur nombre de lotissement--
PROCEDURE LOTISSEMENTCONTINGENT IS
BEGIN
FOR tuple IN (SELECT Nom_Loti as nom, NbreAgent as nbre FROM lotissement) LOOP
DBMS_OUTPUT.PUT_LINE('Le lotissement de nom ' || tuple.nom || ' a ' || tuple.nbre || ' agent(s) engagé(s)');
END LOOP; 

END LOTISSEMENTCONTINGENT;

--Procédure qui affiche la liste des agents ayant vendu une parcelle--
PROCEDURE AFFICHAGEVENTEPARC (NoParcel INTEGER) IS
verif VARCHAR(32);
BEGIN
select count(*) into verif from AGENT A , GERER G where G.Vente = 'O' and G.NoAgent = A.No_Agent and G.NoParc = NoParcel;
IF verif != 0 THEN
DBMS_OUTPUT.PUT_LINE('Nom et prénom des agents ayant vendu la parcelle ' || NoParcel || ' : ');
FOR tuple IN (select A.Nom_Agent as noma, A.Prenom_Agent as prenoma from AGENT A , GERER G where G.Vente = 'O' and G.NoAgent = A.No_Agent and G.NoParc = NoParcel ORDER BY A.Nom_Agent) LOOP
DBMS_OUTPUT.PUT_LINE( tuple.noma || ' ' || tuple.prenoma );
END LOOP; 
ELSE
DBMS_OUTPUT.PUT_LINE( 'Aucun agent n''a vendu la parcelle '|| NoParcel || '. ' );
END IF;

END AFFICHAGEVENTEPARC;

--Procédure qui affiche la liste des agents ayant vendu une parcelle du lotissement--
PROCEDURE AFFICHAGEVENTELOT (NoLot INTEGER) IS
verif VARCHAR(32);
BEGIN
select count(*) into verif from AGENT A , GERER G, PARCELLE P where G.Vente = 'O' and G.NoAgent = A.No_Agent and P.No_Loti = NoLot and G.NoParc = P.No_Parc;
IF verif != 0 THEN
DBMS_OUTPUT.PUT_LINE('Nom et prénom des agents ayant vendu une parcelle du lotissement ' || NoLot || ' : ');
FOR TUPLE IN (select A.Nom_Agent as noma, A.Prenom_Agent as prenoma from AGENT A , GERER G, PARCELLE P where G.Vente = 'O' and G.NoAgent = A.No_Agent and P.No_Loti = NoLot and G.NoParc = P.No_Parc ORDER BY A.Nom_Agent) LOOP
DBMS_OUTPUT.PUT_LINE( tuple.noma || ' ' || tuple.prenoma );
END LOOP;
ELSE
DBMS_OUTPUT.PUT_LINE( 'Aucun agent n''a vendu une parcelle du lotissement '|| NoLot || '. ' );
END IF;

END AFFICHAGEVENTELOT;

--Procédure qui permet de créer un nouvel engagement pour un lotissement--
PROCEDURE CREATIONENGAGEMENT (NoLot integer, NoAg integer) IS
nbremax number;
BEGIN
select NbreAgent into nbremax from lotissement where No_Loti = NoLot;

IF AGENTCONTINGENT(NoLot) < nbremax THEN
insert into ENGAGER (DateEngage,NoLoti,NAgent) values (SYSDATE,NoLot,NoAg);
FOR TUPLE IN (select Nom_Agent as noma, Prenom_Agent as prenoma from AGENT where No_Agent = NoAg) LOOP
DBMS_OUTPUT.PUT_LINE( 'L''agent '|| tuple.noma ||' ' || tuple.prenoma || ' a été engagé pour le lotissement '|| NoLot || ' le ' || SYSDATE || '.');
END LOOP;
ELSE
RAISE_APPLICATION_ERROR (-20002, 'Le nombre maximum d''agents prévu n''est pas suffisant');
END IF;

END CREATIONENGAGEMENT;

END LotissementPack;
/

REM Mise en place du jeu de test

--Jeu de test pour AGENTCONTINGENT--
SELECT LotissementPack.AGENTCONTINGENT(1) from dual;
SELECT LotissementPack.AGENTCONTINGENT(2) from dual;
SELECT LotissementPack.AGENTCONTINGENT(3) from dual;
SELECT LotissementPack.AGENTCONTINGENT(4) from dual;
SELECT LotissementPack.AGENTCONTINGENT(5) from dual;

--Jeu de test pour CHANGERCONTINGENT--
EXEC LotissementPack.CHANGERCONTINGENT(1,2);
EXEC LotissementPack.CHANGERCONTINGENT(-4,1);
EXEC LotissementPack.CHANGERCONTINGENT(3,3);
EXEC LotissementPack.CHANGERCONTINGENT(-1,5);
EXEC LotissementPack.CHANGERCONTINGENT(6,6);

--Jeu de test pour LOTISSEMENTCONTINGENT--
EXEC LotissementPack.LOTISSEMENTCONTINGENT;

--Jeu de test pour AFFICHAGEVENTEPARC--
EXEC LotissementPack.AFFICHAGEVENTEPARC(1);
EXEC LotissementPack.AFFICHAGEVENTEPARC(5);
EXEC LotissementPack.AFFICHAGEVENTEPARC(7);
EXEC LotissementPack.AFFICHAGEVENTEPARC(2);
EXEC LotissementPack.AFFICHAGEVENTEPARC(3);

--Jeu de test pour AFFICHAGEVENTELOT--
EXEC LotissementPack.AFFICHAGEVENTELOT(3);
EXEC LotissementPack.AFFICHAGEVENTELOT(6);
EXEC LotissementPack.AFFICHAGEVENTELOT(2);
EXEC LotissementPack.AFFICHAGEVENTELOT(1);
EXEC LotissementPack.AFFICHAGEVENTELOT(5);

--Jeu de test pour CREATIONENGAGEMENT--
EXEC LotissementPack.CREATIONENGAGEMENT(3,1);
EXEC LotissementPack.CREATIONENGAGEMENT(6,2);
EXEC LotissementPack.CREATIONENGAGEMENT(3,4);
EXEC LotissementPack.CREATIONENGAGEMENT(2,1);
EXEC LotissementPack.CREATIONENGAGEMENT(4,3);