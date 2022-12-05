# Proyecto ETL


![traffic](https://user-images.githubusercontent.com/112175733/201521353-046d7bba-13a1-4380-a506-c48363452433.png)


🎯 **OBJETIVOS**

1) Crear un repo nuevo con files src, img, data, Readme.md y gitignore.

2) Issue con el link pegado de nuestro Repo

3) Extracción de datos mediante dos métodos (CSV, Webscraping, APIs...) de tres fuentes distintas.

4) Transformación de los dataframes obtenidos en el paso anterior:   

5) Cargar datos limpios a una nueva base de datos.

------------------------------------------

📋 **PASOS SEGUIDOS**

**1) Extracción** 

Se han extraído datos demográficos y de accidentes de tráfico en el municipio de Madrid para un posterior análisis de los mismos.

  - Ficheros excel del Ayuntamiento de Madrid con los datos de accidentes por distrito para los años 2019-2022. 
  
    *Vía descarga en la web de datos abiertos del Ayuntamiento de Madrid*

  - Tabla de densidad de población por distritos de Madrid de Wikipedia.
  
    *Vía webscraping con Beautiful Soup*

  - Tabla de indicadores demográficos de Edad media, % de población menor de 18 años y % mayor de 65 años por distritos en Madrid del INE.
  
    *Vía webscraping con Selenium*

**2) Transformación**

Una vez extraídos los datos y convertidos a los dataframes pertinentes, se ha procedido a su transformación y limpieza.

   **a)** Dataframe de densidad de población por distrito.
   
   - Se ha convertido el campo densidad a float
      
   **b)** Dataframe de demografía por edades por distrito.
   
   - Transformación de todas las columnas a tipo float y creación de la columna 'pob_adulta_perc'
   
   **c)** Dataframe accidentes de tráfico en el municipio de Madrid.
   
   - En primer lugar se han concatenado los 4 dataframes procedentes de cada csv para trabajar con uno sólo
   
   - Se han comprobado los valores nulos y en general se han sustituido por 'unknown' con algunas excepciones:
   
     - La columna 'positiva_droga' tiene más de un 99% de nulos, pero se ha asumido que habiendo otra columna llamada 'positiva_alcohol', para cada accidente se han realizado pruebas de ambos tipos, así que todas los nulos del test de droga se han convertido a 0 (negativo). *susceptible a cambios futuros*
     
     - Para la columna 'cod_distrito' se han eliminado los 5 registros en los que no se conoce el distrito (corresponden a dos accidentes), ya que nuestro futuro análisis requiere conocer este campo y son una pequeña muestra de todos los registros. Después se ha convertido la columna a tipo integer.
     
     - Para las columnas de coordenadas, se han eliminado todas aquellas filas en los que las valores fueran nulos (27), porque para nuestro posterior análisis necesitamos esta información, por lo que las que no tienen no nos sirven.
     
     - Como anteriormente supusimos que los nulos en positivos en droga serían negativos porque se habrían hecho ambas pruebas, en este caso, si no tengo datos de positividad en alcohol, voy a rellenarlos como negativos.
     
   - Se ha cambiado la disposición de la columna fecha de D-M-A a A-M-D y se han creado tres nuevas columnas de Año, Mes y Día que se han convertido a tipo integer.
   
   - Se han creado dos nuevas columnas con latitud y longitud a partir de las columnas de coordenadas porque están en UTM. Se ha utilizado la librería pyproj. A continuación se han eliminado las dos columnas originales de 'coordenadas_x_utm' y 'coordenadas_y_utm'.
   
   - Por último, se ha decidido eliminar la columna 'cod_lesividad' porque las lesividades vamos a analizarlas por su nombre/tipo.
   
   - Se ha creado una nueva columna 'id' para poder usarla como primary key y para evitar confusión con algunos duplicados existentes que realmente no lo eran.
   
**3) Carga de datos en MySQL**

  - Tras guardar todos los dataframes limpios como csv para quedarnos con una copia limpia de cada uno, se ha procedido a crear una nueva bbdd en MySQL denominada *trafico*.
  
  - A continuación se han cargado mediante pandas y sqlalchemy los 3 dataframes en la bbdd recién creada.
  
  - Por último, se haejecutado un script de SQL para crear una nueva tabla que une las tres tablas en una sola.
  

------------------------------------------

© **FUENTES**

- Ficheros excel del Ayuntamiento de Madrid con los datos de accidentes por distrito para los años 2019-2022: https://datos.madrid.es/portal/site/egob/menuitem.c05c1f754a33a9fbe4b2e4b284f1a5a0/?vgnextoid=7c2843010d9c3610VgnVCM2000001f4a900aRCRD&vgnextchannel=374512b9ace9f310VgnVCM100000171f5a0aRCRD&vgnextfmt=default

- Tabla de densidad de población por distritos de Madrid de Wikipedia: https://es.wikipedia.org/wiki/Anexo:Distritos_de_Madrid#cite_note-munimadrid-1

- Tabla de indicadores demográficos de Edad media, % de población menor de 18 años y % mayor de 65 años por distritos en Madrid del INE: https://www.ine.es/jaxiT3/Datos.htm?t=31105
