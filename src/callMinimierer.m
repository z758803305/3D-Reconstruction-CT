function merkmalsraum = callMinimierer(para,filename)
%% Reads the features from an excel file that are created with the feature extractor (Xiaoyu) 
% This features are then evaluated by a optimization function, that
% minimizes the error

%% Inputs:
% Path and Filename of the Excel file:
pathExcel = 'C:\Users\fuxia\Documents\Thesis\code\prototyp\Data\';
filenameExcel = filename;

%% Import data from spreadsheet

% Import the data
[~, ~, importRaw] = xlsread(filenameExcel);
% Create table
merkmalsraum = cell2table(importRaw(2:end,:));
% Set variable names
% merkmalsraum.Properties.VariableNames = importRaw(1,:); doesnt work, because of :
% and % in variable names so you have to set it by hand

variableNames = {'Probe','Kth','ElementSize','MinVolume','Porositaet','SpeOberflaeche','NObjects','NNodes','NodesEnd','Nodes3','Nodes4','Nodes5','NodeLength','Porengroesse','PorengroesseAnteil','xRichtung','yRichtung','zRichtung'};
merkmalsraum.Properties.VariableNames = variableNames;
% Clear temporary variables
clearvars importRaw variableNames;

%% Add minimization Row to table:
merkmalsraum.fMin = ones(size(merkmalsraum,1),1)*(-1);

%% Create minimization function
fmin = @(x,y,z,k) para.factors.porositaet*(x-para.soll.porositaet)^2+...
    para.factors.nObjects*(y-para.soll.nObjects)^2+...
    para.factors.nodesEnd*(z-para.soll.nodesEnd)^2+...
    para.factors.sizePoren*(k-para.soll.sizePoren)^2;

for i = 1:size(merkmalsraum,1)
    merkmalsraum.fMin(i)= fmin(merkmalsraum.Porositaet(i), merkmalsraum.NObjects(i), merkmalsraum.NodesEnd(i),merkmalsraum.Porengroesse(i));
end

end