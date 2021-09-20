function [FWHM,Proms]= freq_doamin_1(data,range1,range2)
    data_1 = data(:,2)
    data_2 = data_1'
    [PS_W,faxis_W] = pwelch(data_2,[],[],[],6) 
    freq(:,1) = faxis_W
    freq(:,2) = 10*log10(PS_W)
    
    [pks,locs,widths,proms]=findpeaks(freq(:,2),freq(:,1),'MinPeakProminence',10,'Annotate','extents')
    
    a = size(locs)
    c1=0
   
    for i=1:a(1)
        if locs(i) > range1 & locs(i) <= range2
            c1 = c1+1
            first(c1,1) = proms(i)
            first(c1,2) = i           
        end
    end
    if c1 == 0
        Proms = "NA"
        FWHM = "NA"
    else
        Proms = max(first(:,1))
        c1_1 = size(first)
        for j=1:c1_1(1)
            if Proms == first(j,1)
                FWHM = widths(first(j,2))
            end
        end
    end    
end