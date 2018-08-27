% % -----------------------------------------------------------------------
% Script para abrir una base de datos en formato CSV, organizarla y
% realizar un an�lisis preliminar descriptivo para ver el tipo de
% contenido.
% La base de datos est� disponible en 
% (https://www.kaggle.com/decide-soluciones/air-quality-madrid)
% % -----------------------------------------------------------------------
% Por: Julian D. Echeverry - 2018 - Introducci�n a la Ciencia de los Datos
% Maestr�a en Ingenier�a El�ctrica - Universidad Tecnol�gica de Pereira
% Grupo de Investigaci�n en An�lisis de Datos y Sociolog�a Computacional
% contacto: jde@utp.edu.co
% % -----------------------------------------------------------------------

%% Declaraciones iniciales
format compact;
clc; close all;clear all;

%% Definici�n de la ruta de la base de datos
pathDB = 'E:\Documentos\___BASES_DE_DATOS\data_science\air-quality-madrid(link_in_mountain)\csvs_per_year\';

%% Miremos inicialmente un ejemplo de c�mo analizar un �nico archivo de la BD
% Con esta instrucci�n lo cargamos como un objeto del tipo
% TabularTextDatastore (de la familia de objetos de tipo _datastore_). La
% ventaja carg�ndolo de esta forma, es que los datos no llenan la memoria
% del equipo, a pesar de que sean Large (Big) Data.
ttds = tabularTextDatastore(strcat(pathDB,'madrid_2001.csv'));
% Miremos por ejemplo qu� variables contiene el archivo
ttds.VariableNames
% Escojamos una variable de inter�s para visualizarla
ttds.SelectedVariableNames = 'BEN';
% y hagamos una previsualizaci�n de los datos
data = preview(ttds)
% Si nos fijamos, el programa est� tratando los missing values como NaN.
% Esto podemos cambiarlo.
ttds.MissingValue = 0;
% Visualicemos de nuevo
data = preview(ttds)
% Por defecto, el objeto datastore se crea leyendo 20000 filas del archivo
% original. Para cambiar el n�mero de filas se emplea la siguiente opci�n
ttds.ReadSize = 20000;
sums = [];
counts = [];
while hasdata(ttds)
    T = read(ttds);
    sums(end+1) = sum(T.BEN);
    counts(end+1) = length(T.BEN);
end
avgBEN = sum(sums)/sum(counts)



%% Miremos ahora c�mo analizar toda la base de datos
ttds = tabularTextDatastore(strcat(pathDB,'*.csv'));
ttds.MissingValue = 0;
ttds.SelectedVariableNames = 'BEN';
data = preview(ttds)