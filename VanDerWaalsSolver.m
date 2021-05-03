function [] = vanDerWaalsSolver()

close all;
global gui;
gui.fig = figure('numbertitle', 'off', 'name', 'Van der Waals Equation Calculator');

%input variables needed: temperature of conditions (T), pressure of
%conditions (P), critical temperature of species (Tc), critical pressure of
%species (Pc)

%temperature conditions
gui.tempText = uicontrol('style', 'text', 'position', ...
    [20 400 70 25], 'string', 'Temperature of Conditions:', 'horizontalalignment', 'left');
gui.tempInput = uicontrol('style', 'edit', 'position', [20 375 100 20]);

%pressure conditions
gui.pressText = uicontrol('style', 'text', 'position', ...
    [20 350 70 25], 'string', 'Pressure of Conditions:', 'horizontalalignment', 'left');
gui.pressInput = uicontrol('style', 'edit', 'position', [20 325 100 20]);

%critical temperature
gui.critTempText = uicontrol('style', 'text', 'position', ...
    [20 270 70 40], 'string', 'Critical Temperature of Species:', 'horizontalalignment', 'left');
gui.critTempInput = uicontrol('style', 'edit', 'position', [20 245 100 20]);

%critical pressure
gui.critPressText = uicontrol('style', 'text', 'position', ...
    [20 200 70 40], 'string', 'Critical Pressure of Species:', 'horizontalalignment', 'left');
gui.critPressInput = uicontrol('style', 'edit', 'position', [20 175 100 20]);

%drop down menus for units
gui.tempUnits = uicontrol('style', 'popupmenu', 'string', {'Celsius';'Kelvin'}, 'position', [120 375 100 20], 'horizontalalignment', 'left');
gui.pressUnits = uicontrol('style', 'popupmenu', 'string', {'Atmospheres';'Pascals'}, 'position', [120 325 100 20], 'horizontalalignment', 'left');
gui.critTempUnits = uicontrol('style', 'popupmenu', 'string', {'Celsius';'Kelvin'}, 'position', [120 245 100 20], 'horizontalalignment', 'left');
gui.critPressUnits = uicontrol('style', 'popupmenu', 'string', {'Atmospheres';'Pascals'}, 'position', [120 175 100 20], 'horizontalalignment', 'left');

%%solve button
gui.convertUnitsText = uicontrol('style', 'text', 'position', ...
        [20 125 70 40], 'string', 'Must Select Convert Units Before Solving', 'horizontalalignment', 'left');
gui.convertUnits = uicontrol('style', 'pushbutton', 'position', [20 100 100 20], 'string', 'Solve', 'horizontalalignment', 'left', 'callback', {@solve});
    
%%output answers

end

function [] = convertUnits(~,~)
global gui;
%if pressure given in atm, convert to Pa
pressUnitsI = get(gui.pressUnits, 'value');
    switch pressUnitsI
        case 1
            P = str2num(get(gui.pressInput, 'String')) * 101325 ;
        case 2
            P = str2num(get(gui.pressInput, 'String')) ;
        otherwise
            error('Unit Value Not Recognized')
    end
critPressUnitsI = get(gui.critPressUnits, 'value');
switch critPressUnitsI
    case 1
        Pc = str2num(get(gui.critPressInput, 'String')) * 101325 ;
    case 2
        Pc = str2num(get(gui.critPressInput, 'String'));
    otherwise
        error('Unit Value Not Recognized')
end

%if temp given in Celsius, convert to Kelvin
tempUnitsI = get(gui.tempUnits, 'value');
    switch tempUnitsI
        case 1
            T = str2num(get(gui.tempInput, 'String')) + 273.15;
        case 2
            T = str2num(get(gui.tempInput, 'String')) ;
        otherwise
            error('Unit Value Not Recognized')
    end
critTempUnitsI = get(gui.critTempUnits, 'Value');
switch critTempUnitsI
    case 1 %atm
        Tc = str2num(get(gui.critTempInput, 'String')) + 273.15;
    case 2 %Pa
        Tc = str2num(get(gui.critTempInput, 'String')) ;
    otherwise
        error('Unit Value Not Recognized')
end

set(gui.convertUnits, 'Position', [20 100 0 20]);
set(gui.solve, 'Position', [20 100 100 20]);

convT = sprintf("Temperature of Conditions = %d K\n", T);
convP = sprintf("Pressure of Conditions = %d Pa\n", P);
convTc = sprintf("Critical Temperature = %d K\n", Tc);
convPc = sprintf("Critical Pressure = %d Pa\n", Pc);

gui.temp = T;
gui.press = P;
gui.critTemp = Tc;
gui.critPress = Pc;

gui.outputConvertedUnits = uicontrol('style', 'text', 'position', ...
    [250 400 200 20], 'string', 'Converted Units:', 'horizontalalignment', 'left');
gui.tempDisplay = uicontrol('style', 'text', 'position', ...
    [250 380 200 20], 'string', 'convT', 'horizontalalignment', 'left');

end

function [specificVolume] = solve(~,~)
global gui;
%calculate a and b constants
        a = 29.161 * gui.critTemp^2 / gui.critPress ;
        b = (8.314) * gui.critTemp / (8 * gui.critPress) ;
        
        %van der waals equation
        
        A = -1 * a * b ;
        B = a;
        C = -1 * ( (gui.press * b) + (8.314 * gui.temp) );
        D = gui.press;
        Y = [D, C, B, A];
        X = roots(Y);
        x = X(1);
        specificVolume = x;
        fprintf("Specific Volume = %d m^3/mol\n", specificVolume);
        
        gui.outputSolution = uicontrol('style', 'text', 'position', ...
    [250 300 100 20], 'string', 'Solution:', 'horizontalalignment', 'left');

end
%output variables: specific volume of non-ideal gas
        
        
        

      