function dxdt = ode_fitz(~,w,p)

% Parameters

a = 0.7;
b = 0.8;
c = 3.0; 
z = -0.4;

% Variables

x = w(1);
y = w(2);

% ODEs

dx = p*(c*(y+x-x^3/3+z));
dy = p*(-(x-a+b*y)/c);

dxdt = [dx; dy];


end

