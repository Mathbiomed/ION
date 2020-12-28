

options = odeset('Events', @event);

[~,~,te,ye,~] = ode23tb(@ode_fitz, [0 100], [1 1], options, 1);

fitz_per = te(end)-te(end-1);

[t,x] = ode23tb(@ode_fitz, 0:0.001:1.01, ye(end,:), [], fitz_per);

data = [t, x];

l = length(data);
rp_data = zeros(l,3);

for i = 1:length(data)

    dxdt = ode_fitz(data(i,1), data(i,2:end),fitz_per);
    rp_data(i,:) = [data(i,1) dxdt'];
end

figure(1)
plot(data(:,1),data(:,2:end))

figure(2)
plot(rp_data(:,1), rp_data(:,2:end))

function [value, isterminal, direction] = event(t,x,p)

value = x(1);
isterminal = 0;
direction = 1;

end

