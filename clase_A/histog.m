function [salida] = histog(path,name,var)
ttds = tabularTextDatastore(strcat(path,name));
ttds.MissingValue = 0;
ttds.SelectedVariableNames = var;
ttds.ReadSize = 'file';
salida = [];
while hasdata(ttds)
    T = read(ttds);
    salida = [salida ; eval(strcat('T.',var))];
end
