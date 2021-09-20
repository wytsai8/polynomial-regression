function [PASA_0_1,PASA_1_2,PASA_2_3,PASA_0_3,Midbandfit_0_1,Midbandfit_1_2,Midbandfit_2_3,Midbandfit_0_3,Intercept_0_1,Intercept_1_2,Intercept_2_3,Intercept_0_3,freq_area] = freq_doamin(data)
    data_1 = data(:,2)
    data_2 = data_1'
    [PS_W,faxis_W] = pwelch(data_2,[],[],[],6) 
    freq(:,1) = faxis_W
    freq(:,2) = 10*log10(PS_W)
  
    a = size(freq)
    c1=1
    c2=1
    c3=1
    for i=1:a(:,1)
        if freq(i,1) <= 1
            first(c1,1) = freq(i,1)
            first(c1,2) = freq(i,2)
            c1 = c1+1
        elseif freq(i,1) >1 & freq(i,1) <=2
            second(c2,1) = freq(i,1)
            second(c2,2) = freq(i,2)
            c2 = c2+1
        elseif freq(i,1) >2 & freq(i,1) <=3
            third(c3,1) = freq(i,1)
            third(c3,2) = freq(i,2)
            c3 = c3+1
        end
    end

    mdl_first = fitlm(first(:,1),first(:,2))
    mdl_second = fitlm(second(:,1),second(:,2))
    mdl_third = fitlm(third(:,1),third(:,2))
    mdl_all = fitlm(freq(:,1),freq(:,2))

    first_arr = mdl_first.Coefficients
    second_arr = mdl_second.Coefficients
    third_arr = mdl_third.Coefficients
    all_arr = mdl_all.Coefficients

    first_data = table2array(first_arr)
    second_data = table2array(second_arr)
    third_data = table2array(third_arr)
    all_data = table2array(all_arr)

    PASA_0_1 = first_data(2,1)
    PASA_1_2 = second_data(2,1)
    PASA_2_3 = third_data(2,1)
    PASA_0_3 = all_data(2,1)

    Intercept_0_1 = first_data(1,1)
    Intercept_1_2 = second_data(1,1)
    Intercept_2_3 = third_data(1,1)
    Intercept_0_3 = all_data(1,1)

    Midbandfit_0_1 = first_data(2,1)*0.5 + first_data(1,1)
    Midbandfit_1_2 = second_data(2,1)*1.5 + second_data(1,1)
    Midbandfit_2_3 = third_data(2,1)*2.5 + third_data(1,1)
    Midbandfit_0_3 = all_data(2,1)*1.5 + all_data(1,1)
     
    min_point = min(freq(:,2))
    freq(:,3) = freq(:,2)-min_point
    freq_area = trapz(freq(:,1),freq(:,3))
end