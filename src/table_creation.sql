create table accidentes_data
select accidentes.*, den.densidad_pob, dem.edad_media, dem.pob_men_18_perc, dem.pob_may_65_perc, dem.pob_adulta_perc
from accidentes
left join demografia as dem
on accidentes.cod_distrito = dem.id_distrito
left join densidad as den
on accidentes.cod_distrito = den.id_distrito