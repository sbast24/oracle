create or replace PROCEDURE "CONSOLIDACION_CUENTAS" AS
BEGIN
    EXECUTE IMMEDIATE 'insert into TBL_CUENTAS_RENTAS(id_tbl_cuentas_rentas, cuenta, fecha, TIPO_FALLA,TIEMPO, INC)

WITH cuentas AS
(
SELECT 
atv.cuenta, ''Compen arreglos TV>16 Hrs'' nombre, atv.tiempo, atv.llamada incidente
FROM
tbl_arreglo_tv_16h  atv
union
SELECT 
 ati.cuenta, ''Compensacion Arreglos > 48 Hr'' nombre, ati.tiempo, ati.llamada incidente
FROM
tbl_arreglo_tel_int_48h  ati

union
SELECT 
cti.cuenta, ''Compensa Fallas masivas > 48 Hr'' nombre, cti.tiempo, cti.incidente incidente
FROM
tbl_compes_tel_int_48h  cti

union
SELECT 
ctv.cuenta, ''Compen falla masiv TV>16 Hrs'' nombre, ctv.tiempo, ctv.incidente incidente
FROM
tbl_compes_tv_16h  ctv
union 
select 
ci.cuenta, ''Improcsssedenciea_falla_masiva'' nombre, ci.tiempo, ci.incidente incidente
from TBL_COMPES_IMPROCEDENCIA ci)
select TBL_CUENTAS_RENTAS_SEQ.nextval,
cuenta, TO_CHAR(SYSDATE,''YYYY-MM-DD''), 
nombre, tiempo, incidente
from cuentas'
    ;
    COMMIT;
--se eliminan los datos duplicados de la tabla
    EXECUTE IMMEDIATE '  DELETE FROM TBL_CUENTAS_RENTAS
 WHERE ROWID NOT
in

( SELECT
    MIN(ROWID)
FROM
    tbl_cuentas_rentas
GROUP BY
    cuenta
)'
    ;
    COMMIT;
END consolidacion_cuentas;