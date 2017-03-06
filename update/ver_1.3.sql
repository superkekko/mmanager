ALTER TABLE category ADD COLUMN keyword TEXT NOT NULL AFTER income;
create table importcsv (imp_key INT NOT NULL AUTO_INCREMENT, dat_mov varchar(100) not null, description varchar(1000) not null, value varchar(100) not null, usr_mov varchar(20) not null, mov_imp char(1)not null default '');
ALTER TABLE movement CHANGE COLUMN note note TEXT NOT NULL;
ALTER TABLE movement ADD COLUMN imp_key INT(10) NOT NULL DEFAULT 0 AFTER tms_upd;
CREATE FUNCTION SPLIT_STR( x VARCHAR(255), delim VARCHAR(12), pos INT ) RETURNS varchar(255) CHARSET utf8 RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos), CHAR_LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1), delim, '');
CREATE PROCEDURE csv_import() BEGIN  DECLARE n_key INT; DECLARE v_key VARCHAR(255); DECLARE n_cat INT; DECLARE cat CURSOR FOR SELECT cat_id FROM category where keyword <> '';  OPEN cat;  read_loop: LOOP FETCH cat INTO n_cat; SET n_key = 1; select ifnull(trim(SPLIT_STR(c.keyword, ',', n_key)),'') into v_key from category c where c.cat_id = n_cat;  WHILE v_key <> '' DO insert into movement (cat_id, val, type, dat_mov, usr_mov, usr_id, note, imp_key) select distinct c.cat_id, cast(replace(i.value, ',', '.') as DECIMAL(10,2)) as value, case when cast(replace(i.value, ',', '.') as DECIMAL(10,2)) > 0 then 'P' else 'N' end as type, STR_TO_DATE(i.dat_mov, '%d/%m/%Y') as dat_mov, i.usr_mov, 'IMP_MASS', i.description, i.imp_key from importcsv i join category c on lower(i.description) like lower(concat('%',trim(SPLIT_STR(c.keyword, ',', n_key)),'%')) and c.cat_id = n_cat and i.mov_imp <> 'S' and not exists (select 1 from movement mm where mm.cat_id = c.cat_id and mm.dat_mov = STR_TO_DATE(i.dat_mov, '%d/%m/%Y') and mm.val = cast(replace(i.value, ',', '.') as DECIMAL(10,2)));  update importcsv i set i.mov_imp = 'S' where i.imp_key in (select imp_key from movement);  commit;  SET n_key = n_key +1;  select ifnull(trim(SPLIT_STR(c.keyword, ',', n_key)), '') into v_key from category c where c.cat_id = n_cat; END WHILE; END LOOP; END;
CREATE OR REPLACE VIEW cat AS select c.cat_id AS cat_id, c.parent_id AS parent_id, c.cat_name AS cat_name, c.color AS color, c.income AS income, c.keyword AS keyword, (case when (c.cat_id = c.parent_id) then ' ' else c1.cat_name end) AS parent_cat, (select count(1) from mov where (mov.cat_id = c.cat_id)) AS num_mov, (select (case when (count(1) > 2) then 'S' else 'N' end) from category cc where (c.cat_id = cc.parent_id)) AS have_ch from (category c join category c1) where (c.parent_id = c1.cat_id) order by c.parent_id , c.cat_id;
insert into mversion (db) values ('1.3');