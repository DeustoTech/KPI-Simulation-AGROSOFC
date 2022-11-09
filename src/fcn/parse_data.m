function result = parse_data(rl)
POWER = rl.logsout.getElement('Potencia calor').Values;

TOMATO = rl.logsout.getElement('Tomato').Values;

POWER_SOFC =  rl.logsout.getElement('Q SOFC thermal').Values;

POWER_SOFC_e =  rl.logsout.getElement('Q SOFC electrical').Values;

Activity =  rl.logsout.getElement('Activity').Values;

Tw =  rl.logsout.getElement('Tw').Values;

OP = rl.logsout.getElement('OP').Values;


for ic = {'TOMATO','POWER','POWER_SOFC','POWER_SOFC_e','Activity','Tw','OP'}
    eval("Data = "+ic{:}+".Data;")
    eval("Time = "+ic{:}+".Time;")

    result.(ic{:}).Data = Data;
    result.(ic{:}).Time = Time;

end
%%
result.GH.time = rl.tout;

sg_CROP = rl.logsout.getElement('Crop');
result.GH.CROP = parseCrop(sg_CROP,rl.tout);
%
sg_IC = rl.logsout.getElement('Indoor Climate');
result.GH.IC = parseIndoorClimate(sg_IC,rl.tout);
%
sg_EC = rl.logsout.getElement('EC');
result.GH.EC = parseIndoorClimate(sg_EC,rl.tout);
%
dTom_dt = gradient(TOMATO.Data,TOMATO.Time);
dTom_dt(dTom_dt<0) = 0;
result.GH.TOMATO_EVOLUTION = cumtrapz(TOMATO.Time,dTom_dt);
result.GH.TOTAL_TOMATO = result.GH.TOMATO_EVOLUTION(end);

% Creamos un fichero que contiene los parameteros selecionados 
text = printstruct(result,'printcontents', 0);
writecell(text,'Resultados')

end
