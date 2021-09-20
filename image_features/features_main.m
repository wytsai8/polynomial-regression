clear
folder = 'optical' %'photoacoustic''optical'
file = strcat(folder,"/","sample_list.txt")
sample_list = importdata(file)
sample_count = size(sample_list)
sample_count1 = sample_count(1)

for i=1:sample_count1
    filename = strcat(sample_list(i),".txt")
    file = strcat(folder,"/",filename)
    data_1 = importdata(file)
    all = data_1.data

    if strcmp(folder,'photoacoustic')
        photoacoustic_avg = photoacoustic_average(all)
       % data2 = importdata(photoacoustic_avg)
       data2 = photoacoustic_avg
    end

    if strcmp(folder,'optical')
        optical_avg = optical_average(all)
        %data2 = importdata(optical_avg)
        data2 = optical_avg
    end

    [P2P_Amp,positive_Amp,negative_Amp,positive_slope,negative_slope,time_area,first,second,third,fourth]=time_doamin(data2,10)
    time_result = [P2P_Amp,positive_Amp,negative_Amp,positive_slope,negative_slope,time_area]

    [PASA_0_1,PASA_1_2,PASA_2_3,PASA_0_3,Midbandfit_0_1,Midbandfit_1_2,Midbandfit_2_3,Midbandfit_0_3,Intercept_0_1,Intercept_1_2,Intercept_2_3,Intercept_0_3,freq_area] = freq_doamin(data2)
    freq_result = [PASA_0_1,PASA_1_2,PASA_2_3,PASA_0_3,Midbandfit_0_1,Midbandfit_1_2,Midbandfit_2_3,Midbandfit_0_3,Intercept_0_1,Intercept_1_2,Intercept_2_3,Intercept_0_3,freq_area] 

    [FWHM,Proms]= freq_doamin_1(data2,0,0.5)
    FWHM_Proms_first = [FWHM,Proms]

    [FWHM,Proms]= freq_doamin_1(data2,0.5,1)
    FWHM_Proms_second = [FWHM,Proms]

    [FWHM,Proms]= freq_doamin_1(data2,1,1.5)
    FWHM_Proms_third = [FWHM,Proms]

    [FWHM,Proms]= freq_doamin_1(data2,1.5,2)
    FWHM_Proms_fourth = [FWHM,Proms]

    [FWHM,Proms]= freq_doamin_1(data2,2,2.5)
    FWHM_Proms_fifth = [FWHM,Proms]

    [FWHM,Proms]= freq_doamin_1(data2,2.5,3)
    FWHM_Proms_sixth = [FWHM,Proms]

    result_data = [time_result,freq_result,FWHM_Proms_first(1),FWHM_Proms_second(1),FWHM_Proms_third(1),...
        FWHM_Proms_fourth(1),FWHM_Proms_fifth(1),FWHM_Proms_sixth(1),FWHM_Proms_first(2),FWHM_Proms_second(2),...
        FWHM_Proms_third(2),FWHM_Proms_fourth(2),FWHM_Proms_fifth(2),FWHM_Proms_sixth(2)]
    
    if i==1
        all_parameters = parameters
        final = [all_parameters;result_data]
    else
        final = [final;result_data]
    end
end

final_1 = str2double(final)
%correct_data = correct_data(final)
correct_data = correct_data(final_1,all_parameters)
%final_2 = correct_data
%final_3 = [all_parameters;final_2]
result = strcat("../polynomial_regression/model/data/",folder,"_image.txt")
writematrix(correct_data, result,'Delimiter','tab')