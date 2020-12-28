function per = est_per(data)

[~,c] = size(data);

pers = zeros(c-1,1);

for i = 2:c
    try
        temp_amp = max(data(:,i))-min(data(:,i));

        [~,locs] = findpeaks(data(:,i),'MinPeakProminence', temp_amp/1.5);

        pers(i-1) = data(locs(2),1)-data(locs(1),1);
    catch
        continue;
    end
    
end

per = mean(pers);
if(per == 0)
    per = data(end,1)-data(1,1);
end

end