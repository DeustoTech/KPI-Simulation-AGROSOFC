
function E = Enthalpy(Tspan,Specie)


E = Tspan*0;
iter = 0;
for T = Tspan
    iter = iter + 1;
switch Specie
    case 'H2O'
        if ~((T > 500)*(T<1700));error('Temperature out ranges [500-1700] K');end
        % https://webbook.nist.gov/cgi/cbook.cgi?ID=C7732185&Mask=1#Thermo-Gas
        Ap = 30.09200;
        Bp = 6.832514;
        Cp = 6.793435;
        Dp = -2.534480;
        Ep = 0.082139;
        Fp = -250.8810;
        Gp = 223.3967;
        Hp = -241.8264;
        
    case 'O2'
        if ~((T > 100)*(T<2000));error('Temperature out ranges [500-1700] K');end
        if ((T>100).*(T<700))
            Ap = 31.32234;
            Bp = -20.23531;
            Cp = 57.866445;
            Dp = -36.50624;
            Ep = -0.007374;
            Fp = -8.903471;
            Gp = 246.7945;
            Hp = 0;
        elseif  ((T>=700).*(T<2000))
            Ap = 30.03235;
            Bp = 8.772972;
            Cp = -3.988133;
            Dp = 0.788313;
            Ep = -0.741599;
            Fp = -11.32468	;
            Gp = 236.1663;
            Hp = 0.0;            
        end
    case 'H2'
        if (T>298)*(T<1000)
            Ap=	33.066178;
            Bp=	-11.363417;
            Cp=	11.432816;
            Dp=	-2.772874;
            Ep=	-0.158558;
            Fp=	-9.980797;
            Gp=	172.707974;
            Hp=	0.0 ;
        elseif (T>=1000)*(T<2500)
            Ap=	18.563083;
            Bp=	12.257357;
            Cp=	-2.859786;
            Dp=	0.268238;
            Ep=	1.977990;
            Fp=	-1.147438;
            Gp=	156.288133;
            Hp=	0.0 ;
        end
    case 'CO'
        if (T>298)*(T<1300)
            Ap=	25.56759;
            Bp=	6.096130;
            Cp= 4.054656;
            Dp=	-2.671301;
            Ep=	0.131021;
            Fp=	-118.0089;
            Gp=	227.3665;
            Hp=	-110.5271 ;
        else
            error('CO out Temperature Range')
        end
    case 'CH4'
        if (T>298)*(T<1300)
            Ap=	-0.703029;
            Bp=	108.4773;
            Cp= -42.52157;
            Dp=	5.862788;
            Ep=	0.678565;
            Fp= -76.84376;
            Gp=	158.7163;
            Hp=	-74.87310;
        else
            error('CH4 out Temperature Range')
        end        
    case 'CO2'
       if (T>298)*(T<1200)
            Ap=	24.99735;
            Bp=	55.18696;
            Cp= -33.69137;
            Dp=	7.948387;
            Ep=	-0.136638;
            Fp= -403.607;
            Gp=	228.2431;
            Hp=	-393.5224;
        else
            error('CO2 out Temperature Range')
        end      
end
t  = T/1000;
H = Ap*t + Bp*t^2/2 + Cp*t^3/3 + Dp*t^4/4 - Ep/t + Fp - Hp + Hp;
E(iter) = 1e3*H;

end