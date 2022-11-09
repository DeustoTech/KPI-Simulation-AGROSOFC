function result = parse_data(rl)
POWER = rl.logsout.getElement('Potencia calor').Values;
TOMATO = rl.logsout.getElement('Tomato').Values;
AR = rl.logsout.getElement('AR').Values;



for ic = {'TOMATO','POWER','AR'}
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


end
