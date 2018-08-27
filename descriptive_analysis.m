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
% TabularTextDatastore (de la familia de objetos de tipo _datastore_). La
% ventaja cargándolo de esta forma, es que los datos no llenan la memoria
% del equipo, a pesar de que sean Large (Big) Data.
ttds = tabularTextDatastore(strcat(pathDB,'madrid_2001.csv'));
% Miremos por ejemplo qué variables contiene el archivo
ttds.VariableNames
% Escojamos una variable de interés para visualizarla
ttds.SelectedVariableNames = 'BEN';
% y hagamos una previsualización de los datos
data = preview(ttds)
% Si nos fijamos, el programa está tratando los missing values como NaN.
% Esto podemos cambiarlo.
ttds.MissingValue = 0;
% Visualicemos de nuevo
data = preview(ttds)
% Por defecto, el objeto datastore se crea leyendo 20000 filas del archivo
% original. Para cambiar el número de filas se emplea la siguiente opción
ttds.ReadSize = 20000;
sums = [];
counts = [];
while hasdata(ttds)
    T = read(ttds);
    sums(end+1) = sum(T.BEN);
    counts(end+1) = length(T.BEN);
end
avgBEN = sum(sums)/sum(counts)



%% Miremos ahora cómo analizar toda la base de datos
ttds = tabularTextDatastore(strcat(pathDB,'*.csv'));
ttds.MissingValue = 0;
ttds.SelectedVariableNames = 'BEN';
data = preview(ttds)