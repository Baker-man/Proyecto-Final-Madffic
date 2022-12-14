# Proyecto Madffic 🚗🚓


![traffic](https://user-images.githubusercontent.com/112175733/201521353-046d7bba-13a1-4380-a506-c48363452433.png)

**ÍNDICE**

[1. Objetivos](#0) 🎯 <br />
[2. Pasos seguidos](#steps) 📋 <br />
[3. Visualización](#viz) 💹 <br />
[4. Machine Learning](#ML) 🤖 <br />

------------------------------------------

🎯 **OBJETIVOS**<a name="0"/>

1) Crear una base de datos con los accidentes de tráfico producidos en el municipio de Madrid y en la que se puedan añadir los futuros. 

2) Visualizar en un Dashboard los datos presentes en la base de datos que sirva para gestionar esos accidentes de tráfico. 

3) Crear un modelo predictivo de la severidad (basada en la lesividad) de los accidentes para que ayude determinar los recursos necesarios para atender a los implicados en ellos.

4) Crear un modelo predictivo de coordenadas de los accidentes para saber dónde va a ser necesitada atención médica, policial y/o la que sea necesaria y en cierta medida para intentar evitarlos.

------------------------------------------

📋 **PASOS SEGUIDOS**<a name="steps"/>

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
💹 **VISUALIZACIÓN**<a name="viz"/>

1) Dashboard concentración de accidentes de tráfico en Madrid:

![Dashboard1](https://user-images.githubusercontent.com/112175733/203138345-64af7a6b-dbca-4af6-9662-f988f3683a82.png)

2) Dashboard de accidentes de tráfico en Madrid:

![Dashboard2](https://user-images.githubusercontent.com/112175733/203138367-136020f9-b7b3-4941-9d46-6052d52d89a4.png)

3) Dashboard de accidentes por distrito en Madrid:

![Dashboard3](https://user-images.githubusercontent.com/112175733/207074840-9e0839bf-64f3-4fd8-b7e0-6c275533c2c4.png)

4) Mapa de calor dinámico por meses:

https://user-images.githubusercontent.com/112175733/202927977-8a08705f-cc0e-45a1-a5cc-40ce513b6c10.mp4

5) Mapa de calor dinámico por horas:

https://user-images.githubusercontent.com/112175733/207074905-606ae04e-3629-49bc-b708-2f67a3d541a4.mp4

-------------------------------------------------------
🤖 **MACHINE LEARNING**<a name="ML"/>

A partir de los datos de lesividad, se ha creado una nueva categoría denominada **severidad** de la siguiente manera:

Lesividad | Severidad 
--- | --- 
Sin asistencia sanitaria, Asistencia sanitaria sólo en el lugar del accidente, Ingreso inferior o igual a 24 horas, Atención en urgencias sin posterior ingreso | Leve (0)  
Asistencia sanitaria inmediata en centro de salud o mutua, Asistencia sanitaria ambulatoria con posterioridad | Media (1) 
Ingreso superior a 24 horas, Fallecido 24 horas | Grave (2) 

- Transformación de datos categóricos con getdummies

- Random Forest Classifier (Severidad): 

Accuracy | F1 score | Precision | Recall
--- | --- | --- | --- 
0.90 | 0.86 | 0.85 | 0.90 

En segundo lugar, con la misma transformación de datos anterior, se han predecido las coordenadas de los accidentes de tráfico en Madrid mediante dos modelos, uno que predice la latiutd y otro la longitud.

- Random Forest Regressor (Latitud): 

R2 test | R2 train | MSE | RMSE
--- | --- | --- | --- 
0.9617 | 0.9944 | 4.4360e-05 | 0.0066 

- Random Forest Regressor (Longitud): 

R2 test | R2 train | MSE | RMSE
--- | --- | --- | --- 
0.9514 | 0.9924 | 7.6589e-05 | 0.0087 

-------------------------------------------------------

🚀 **HERRAMIENTAS UTILIZADAS**

- Python: numpy, pandas, seaborn, matplotlib, selenium, beautiful soup, sklearn, utm, xgboost, catboost

- MySQL

- Power BI

-------------------------------------------------------

© **FUENTES**

- Ficheros excel del Ayuntamiento de Madrid con los datos de accidentes por distrito para los años 2019-2022: https://datos.madrid.es/portal/site/egob/menuitem.c05c1f754a33a9fbe4b2e4b284f1a5a0/?vgnextoid=7c2843010d9c3610VgnVCM2000001f4a900aRCRD&vgnextchannel=374512b9ace9f310VgnVCM100000171f5a0aRCRD&vgnextfmt=default

- Tabla de densidad de población por distritos de Madrid de Wikipedia: https://es.wikipedia.org/wiki/Anexo:Distritos_de_Madrid#cite_note-munimadrid-1

- Tabla de indicadores demográficos de Edad media, % de población menor de 18 años y % mayor de 65 años por distritos en Madrid del INE: https://www.ine.es/jaxiT3/Datos.htm?t=31105
