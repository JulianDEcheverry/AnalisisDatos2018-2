% % -----------------------------------------------------------------------
% Script para abrir una base de datos en formato CSV, organizarla y
% realizar un análisis preliminar descriptivo para ver el tipo de
% contenido.
% La base de datos está disponible en 
% (https://www.kaggle.com/decide-soluciones/air-quality-madrid)
% % -----------------------------------------------------------------------
% Por: Julian D. Echeverry - 2018 - Introducción a la Ciencia de los Datos
% Maestría en Ingeniería Eléctrica - Universidad Tecnológica de Pereira
% Grupo de Investigación en Análisis de Datos y Sociología Computacional
% contacto: jde@utp.edu.co
% % -----------------------------------------------------------------------

%% Declaraciones iniciales
format compact;
clc; close all;clear all;

%% Definición de la ruta de la base de datos
pathDB = 'E:\Documentos\___BASES_DE_DATOS\data_science\air-quality-madrid(link_in_mountain)\csvs_per_year\';

%% Miremos inicialmente un ejemplo de cómo analizar un único archivo de la BD
% Con esta instrucción lo cargamos como un objeto del tipo
% _TabularTextDatastore_ (de la familia de objetos de tipo _datastore_). La
% ventaja cargándolo de esta forma, es que los datos no llenan la memoria
% del equipo, a pesar de que sean _*Large (Big) Data*_.
ttds = tabularTextDatastore(strcat(pathDB,'madrid_2001.csv'));
% Miremos por ejemplo qué variables contiene el archivo
disp('Están contenidas las siguientes variables')
ttds.VariableNames
% Escojamos una variable de interés para visualizarla
ttds.SelectedVariableNames = 'BEN';
% y hagamos una previsualización de los datos de la variable de interés
disp('Hagamos una previsualización de los datos')
data = preview(ttds)
disp('Vemos como los missing values son tratados como NaN (por defecto)')

%% Tratamiento de missing values
% Si nos fijamos, el programa está tratando los _missing values_ como *NaN*.
% Esto podemos cambiarlo.
ttds.MissingValue = 0;
% Visualicemos de nuevo
disp('Previsualicemos nuevamente después de haber cambiado los missing values')
data = preview(ttds)

%% Lectura por bloques
% Por defecto, el objeto _datastore_ se crea leyendo bloques de 20000 filas del archivo
% original. Para cambiar el número de filas se emplea la siguiente opción
ttds.ReadSize = 30000;
% Aunque si los datos contenidos en el archivo caben en la memoria, se
% puede especificar que lea directamente todo el archivo en vez de un
% número específico de filas
ttds.ReadSize = 'file';

%% Veamos ahora cómo empezar a leer y procesar los datos del objeto datastore
% * Inicializamos lo que va a ser un vector con la suma de los valores de
% la variable de interés (lo llamaremos _sums_)
% * E inicializamos lo que va a ser un vector con el total de muestras de
% la variable de interés (lo llamaremos _counts_)
sums = [];
counts = [];
while hasdata(ttds)
    T = read(ttds);
    sums(end+1) = sum(T.BEN);
    counts(end+1) = length(T.BEN);
end
sprintf('El promedio (irreal) de las mediciones de la variable %s es',ttds.SelectedVariableNames{1})
avgBEN = sum(sums)/sum(counts)

%% Cómo ver los datos reales
% * Tengan en cuenta que el resultado anterior es engañoso, pues muchas de las posiciones estaban vacías (_missing values_). 
% * Una forma de corregir este promedio es recalculando el _vector counts_ así:
% * Primero tenemos que resetear la posición de lectura para que vuelva a empezar desde el inicio
% * Y luego limpiar la variable counts (para empezar el conteo nuevamente, pero esta vez contando sólo aquellas posiciones distintas a cero). 
reset(ttds);
clear counts; counts = [];
% El vector _sums_ podemos conservarlo, ya que las posiciones en cero no afectan la suma.
while hasdata(ttds)
    T = read(ttds);
    counts(end+1) = length(find(T.BEN));
end
sprintf('El promedio (real) de las mediciones de la variable %s es',ttds.SelectedVariableNames{1})
avgBEN = sum(sums)/sum(counts)

%% También se puede analizar toda la base de datos de una sola instrucción
clear ttds sums counts T data avgBEN;
ttds = tabularTextDatastore(strcat(pathDB,'*.csv'));
ttds.MissingValue = 0;
ttds.VariableNames
ttds.SelectedVariableNames = {'BEN','CO'};
data = preview(ttds)
sumsBEN   = []; sumsCO   = [];
countsBEN = []; countsCO = [];
while hasdata(ttds)
    T = read(ttds);
    sumsBEN(end+1)   = sum(T.BEN);
    countsBEN(end+1) = length(find(T.BEN));
    sumsCO(end+1)    = sum(T.CO);
    countsCO(end+1) = length(find(T.CO));
end
sprintf('El promedio (real) de las mediciones de la variable %s es',ttds.SelectedVariableNames{1})
avgBEN = sum(sumsBEN)/sum(countsBEN)
sprintf('El promedio (real) de las mediciones de la variable %s es',ttds.SelectedVariableNames{2})
avgCO = sum(sumsCO)/sum(countsCO)

%% Realizando un análisis año por año
% Sin embargo, en esta base de datos particularmente, puede ser más
% interesante realizar un análisis año por año para ver los posibles cambios
clear ttds sumsBEN sumsCO countsBEN countsCO T data avgBEN;
salida2001 = histog(pathDB,'madrid_2001.csv','NO_2');
salida2002 = histog(pathDB,'madrid_2002.csv','NO_2');
salida2003 = histog(pathDB,'madrid_2003.csv','NO_2');
salida2004 = histog(pathDB,'madrid_2004.csv','NO_2');
salida2005 = histog(pathDB,'madrid_2005.csv','NO_2');
salida2006 = histog(pathDB,'madrid_2006.csv','NO_2');
salida2007 = histog(pathDB,'madrid_2007.csv','NO_2');
salida2008 = histog(pathDB,'madrid_2008.csv','NO_2');
salida2009 = histog(pathDB,'madrid_2009.csv','NO_2');
salida2010 = histog(pathDB,'madrid_2010.csv','NO_2');
salida2011 = histog(pathDB,'madrid_2011.csv','NO_2');
salida2012 = histog(pathDB,'madrid_2012.csv','NO_2');
salida2013 = histog(pathDB,'madrid_2013.csv','NO_2');
salida2014 = histog(pathDB,'madrid_2014.csv','NO_2');
salida2015 = histog(pathDB,'madrid_2015.csv','NO_2');
salida2016 = histog(pathDB,'madrid_2016.csv','NO_2');
salida2017 = histog(pathDB,'madrid_2017.csv','NO_2');
salida2018 = histog(pathDB,'madrid_2018.csv','NO_2');
% Se selecciona el número de intervalos que se quiere analizar
bins = 40;
% Se grafica uno a uno los años
figure()
subplot(231)
hist(salida2001,bins)
title('Calidad del aire en 2001')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(232)
hist(salida2002,bins)
title('Calidad del aire en 2002');
xlabel('nitrogen dioxide level')
ylabel('ug/m^3');
%
subplot(233)
hist(salida2003,bins)
title('Calidad del aire en 2003')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3');
%
subplot(234)
hist(salida2004,bins)
title('Calidad del aire en 2004')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(235)
hist(salida2005,bins)
title('Calidad del aire en 2005')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(236)
hist(salida2006,bins)
title('Calidad del aire en 2006')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
figure()
subplot(231)
hist(salida2007,bins)
title('Calidad del aire en 2007')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(232)
hist(salida2008,bins)
title('Calidad del aire en 2008');
xlabel('nitrogen dioxide level')
ylabel('ug/m^3');
%
subplot(233)
hist(salida2009,bins)
title('Calidad del aire en 2009')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3');
%
subplot(234)
hist(salida2010,bins)
title('Calidad del aire en 2010')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(235)
hist(salida2011,bins)
title('Calidad del aire en 2011')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(236)
hist(salida2012,bins)
title('Calidad del aire en 2012')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
figure()
subplot(231)
hist(salida2013,bins)
title('Calidad del aire en 2013')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(232)
hist(salida2014,bins)
title('Calidad del aire en 2014');
xlabel('nitrogen dioxide level')
ylabel('ug/m^3');
%
subplot(233)
hist(salida2015,bins)
title('Calidad del aire en 2015')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3');
%
subplot(234)
hist(salida2016,bins)
title('Calidad del aire en 2016')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(235)
hist(salida2017,bins)
title('Calidad del aire en 2017')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')
%
subplot(236)
hist(salida2018,bins)
title('Calidad del aire en 2018')
xlabel('nitrogen dioxide level')
ylabel('ug/m^3')