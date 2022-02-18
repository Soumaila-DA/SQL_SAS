* Procédures sur SQL ;

Libname erfi 'C:\Users\dasou\Desktop\Cours M1 ENSP\M2\SQL\ERFI';

PROC SLQ ;
SELECT 
FROM ;
WHERE ;
GROUP BY ;
HAVING ;
ORDER BY ;
QUIT ;

PROC SQL ;
SELECT IDENT, ANAISENF
FROM erfi.enfants
WHERE ANAISENF > 1999 AND ANAISENF NE 9999
ORDER BY anaisenf;
QUIT ;

PROC SQL ;
SELECT IDENT, ANAISENF
FROM erfi.enfants
WHERE ANAISENF > 1999 AND ANAISENF NE 9999
GROUP BY IDENT;
QUIT ;

PROC SQL ;
SELECT IDENT, 2005-ANAISENF as AGE LABEL='Âge de l''enfant'
FROM erfi.enfants
WHERE ANAISENF > 1999 AND ANAISENF NE 9999
GROUP BY IDENT;
QUIT ;

PROC SQL ;
SELECT IDENT, count (IDENT) as NBENF LABEL='Nombre d''enfants de moins de 6 ans',
mean(2005-ANAISENF) as AGE_MOY LABEL='Âge moyen'
FROM erfi.enfants
WHERE ANAISENF > 1999 AND ANAISENF NE 9999
GROUP BY IDENT;
QUIT ;

PROC SQL ;
SELECT IDENT, count (IDENT) as NBENF LABEL='Nombre d''enfants',
mean(2005-ANAISENF) as AGE_MOY LABEL='Âge moyen'
FROM erfi.enfants
WHERE ANAISENF NE 9999
GROUP BY IDENT;
QUIT ;

PROC SQL ;
SELECT IDENT, count (IDENT) as NBENF LABEL='Nombre d''enfants',
	max(2005-ANAISENF) as AGE_AINE LABEL='Âge aîné',
	min(2005-ANAISENF) as AGE_CADET LABEL='Âge cadet',
	mean(2005-ANAISENF) as AGE_MOY LABEL='Âge moyen'
FROM erfi.enfants
WHERE ANAISENF NE 9999
GROUP BY IDENT;
QUIT ;

*Lorsqu'on veut utiliser les variables créer dans notre réquêt pour les filtre on utilise
la close HAVING après GROUP BY à la place de WHERE;
PROC SQL ;
SELECT IDENT, count (IDENT) as NBENF LABEL='Nombre d''enfants',
	max(2005-ANAISENF) as AGE_AINE LABEL='Âge aîné',
	min(2005-ANAISENF) as AGE_CADET LABEL='Âge cadet',
	mean(2005-ANAISENF) as AGE_MOY LABEL='Âge moyen'
FROM erfi.enfants
WHERE ANAISENF NE 9999
GROUP BY IDENT
HAVING NBENF > 1;
QUIT ;

PROC SQL ;
SELECT IDENT, count (IDENT) as NBENF LABEL='Nombre d''enfants',
	max(2005-ANAISENF) as AGE_AINE LABEL='Âge aîné',
	min(2005-ANAISENF) as AGE_CADET LABEL='Âge cadet',
	mean(2005-ANAISENF) as AGE_MOY LABEL='Âge moyen'
FROM erfi.enfants
WHERE ANAISENF NE 9999
GROUP BY IDENT
HAVING NBENF > 1
ORDER BY NBENF DESC;
QUIT ;


* Création des variables conditionnelles ;
proc sql ;
select ident, sexeenf, noenf, agenfm, typenfr, rangenf
from erfi.enfants;
quit ;

proc sql ;
select ident,
	case
		when sexeenf = '1' then 'Masculin'
		when sexeenf = '2' then 'Feminin'
		else 'NP'
	end as Sexe label='Sexe',
	noenf,agenfm, typenfr, rangenf
from erfi.enfants;
quit ;

proc sql SQL INOBS=100;
select ident,
	case
		when sexeenf = '1' then 'Masculin'
		when sexeenf = '2' then 'Feminin'
		else 'NP'
	end as Sexe label='Sexe',
	noenf,
	case
		when agenfm < 5 then '0-4'
		when agenfm >=5 and agenfm < 10 then '5-9'
		when agenfm >=10 and agenfm < 15 then '10-14'
		when agenfm >=15 and agenfm < 20 then '15-19'
		when agenfm >=20 and agenfm < 25 then '20-24'
		when agenfm >=25 and agenfm < 30 then '25-29'
		when agenfm between 30 and 34 then '30-34'
		when agenfm between 35 and 39 then '35-39'
		when agenfm between 40 and 44 then '40-44'
		when agenfm between 45 and 49 then '45-49'
		when agenfm >=50 then '50 ans ou plus'
		else 'NP'
	end as trage label='Tranches d''âges',
	typenfr, rangenf
from erfi.enfants
where typenfr = '14' | typenfr = '20';
quit ;

PROC SQL ;
SELECT IDENT, count (IDENT) as NBENF LABEL='Nombre d''enfants',
	max(2005-ANAISENF) as AGE_AINE LABEL='Âge aîné',
	min(2005-ANAISENF) as AGE_CADET LABEL='Âge cadet',
	mean(2005-ANAISENF) as AGE_MOY LABEL='Âge moyen',
	(CALCULATED AGE_AINE - CALCULATED AGE_CADET) as Dist_gen LABEL='Différence d''âge générationnelle'
FROM erfi.enfants
WHERE ANAISENF NE 9999
GROUP BY IDENT
HAVING NBENF > 1
ORDER BY NBENF DESC;
QUIT ;


* Création de table ou de visualisation ;

proc sql OUTOBS=100;
create table Adoption as
select ident,
	case
		when sexeenf = '1' then 'Masculin'
		when sexeenf = '2' then 'Feminin'
		else 'NP'
	end as Sexe label='Sexe',
	noenf,
	case
		when agenfm < 5 then '0-4'
		when agenfm >=5 and agenfm < 10 then '5-9'
		when agenfm >=10 and agenfm < 15 then '10-14'
		when agenfm >=15 and agenfm < 20 then '15-19'
		when agenfm >=20 and agenfm < 25 then '20-24'
		when agenfm >=25 and agenfm < 30 then '25-29'
		when agenfm between 30 and 34 then '30-34'
		when agenfm between 35 and 39 then '35-39'
		when agenfm between 40 and 44 then '40-44'
		when agenfm between 45 and 49 then '45-49'
		when agenfm >=50 then '50 ans ou plus'
		else 'NP'
	end as trage label='Tranches d''âges',
	typenfr, rangenf
from erfi.enfants
where typenfr = '14' | typenfr = '20';
select * from Adoption;
quit ;

proc sql OUTOBS=100;
create table Biologie as
select ident,
	case
		when sexeenf = '1' then 'Masculin'
		when sexeenf = '2' then 'Feminin'
		else 'NP'
	end as Sexe label='Sexe',
	noenf,
	case
		when agenfm < 5 then '0-4'
		when agenfm >=5 and agenfm < 10 then '5-9'
		when agenfm >=10 and agenfm < 15 then '10-14'
		when agenfm >=15 and agenfm < 20 then '15-19'
		when agenfm >=20 and agenfm < 25 then '20-24'
		when agenfm >=25 and agenfm < 30 then '25-29'
		when agenfm between 30 and 34 then '30-34'
		when agenfm between 35 and 39 then '35-39'
		when agenfm between 40 and 44 then '40-44'
		when agenfm between 45 and 49 then '45-49'
		when agenfm >=50 then '50 ans ou plus'
		else 'NP'
	end as trage label='Tranches d''âges',
	typenfr, rangenf
from erfi.enfants
where typenfr = '30' | relenf in ('2','3');
select * from Biologie;
quit ;


* Joining Datasets Using Proc SQL
	Ne jamais appliqué une telle jointure;
proc sql;
select *
from Adoption, Biologie;
quit;


proc sql OUTOBS=100;
create table Biologie2 as
Select IDENT, CJPAR, RELENF, ADEBCOH
from erfi.enfants
where typenfr = '30' | relenf in ('2','3');
select * from Biologie2;
quit ;

proc sql;
select *
from Biologie as b1 left join Biologie2 as b2
on b1.ident = b2.ident;
quit;

proc sql;
Create table fus_bio as
select *
from Biologie, Biologie2
where Biologie.ident = biologie2.ident;
quit;



* Examen ;

proc sql ;
create table Information as
select ident, sexe, agem,
	case
		when MNAIS = 1-3 then 'Trimestre 1'
		when MNAIS = 4-6 then 'Trimestre 2'
		when MNAIS = 7-9 then 'Trimestre 3'
		when MNAIS = 10-12 then 'Trimestre 4'
	end as trimestre Lable='Trimestre de naissance'
from erfi.individu ;
quit ;

proc sql ;
create table Relation as
select ident , noi, rel,
	case
		when rel = '1' then 'conjoint(e)'
		when rel = '2' then 'Enfant issu du couple'
		when rel in ('3','4','5','6') then 'Enfant non issu du couple'
		when rel = '' then 'Ego'
		else 'Autre'
	end as relation_detail label='Détail de la rélation'
from erfi.individu
where calculated relation_detail NE 'Ego' and calculated relation_detail NE 'Autre';
quit ;

proc sql ;
create table Relation2 as
select ident , noi, rel,
	case
		when relation_detail = 'conjoint(e)' then 1
		else 0
	end as conjoint label='Presence conjoint',
	case
		when relation_detail = 'Enfant issu du couple' then 1
		else 0
	end as Enfant_couple label='Presence Enfant issu du couple',
	case
		when relation_detail = 'Enfant non issu du couple' then 1
		else 0
	end as Enfant_hcouple label='Presence Enfant non issu du couple'
from Relation
quit ;

proc sql ;
create table Type_Famille as
select ident,
	case
		when conjoint = 1 and Enfant_couple = 0 and Enfant_hcouple = 0 then 'couple sans enfant'
		when conjoint = 1 and Enfant_couple = 1 and Enfant_hcouple = 0 then 'Famille classique'
		when conjoint = 1 and Enfant_couple = 0 and Enfant_hcouple = 1 then 'Famille récomposée'
		when conjoint = 0 and Enfant_couple = 1 and Enfant_hcouple = 0 then 'Famille monoparentale'
		when conjoint = 0 and Enfant_couple = 1 and Enfant_hcouple = 1 then 'Famille recomposée'
		when conjoint = 1 and Enfant_couple = 1 and Enfant_hcouple = 1 then 'Famille recomposée'
		else 'autre'
	end as type_famille
from Relation2
quit;

proc sql ;
select distinct ident, count(type_famille) as nb_enfant
from type_famille
where type_famille = 'Famille classique' | type_famille = 'Famille récomposée' | type_famille = 'Famille monoparentale'
group by ident;
quit;
