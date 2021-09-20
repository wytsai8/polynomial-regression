function parameters = parameters
time = ["PeaktoPeak_Amplitude","Amplitude_positive_peak","Amplitude_negative_peak", "Positive_slope","Negative_slope","Time_domain_area"]
PASA = ["PASA_slope_0_1","PASA_slope_1_2","PASA_slope_2_3","PASA_slope_0_3"]
Mitbandfit = ["Midband_fit_0_1","Midband_fit_1_2","Midband_fit_2_3","Midband_fit_0_3"]
Intercept = ["Intercept_0_1","Intercept_1_2","Intercept_2_3","Intercept_0_3"]
FWHM = ["FWHM_0_0.5","FWHM_0.5_1","FWHM_1_1.5","FWHM_1.5_2","FWHM_2_2.5","FWHM_2.5_3"]
Prominences = ["Prominences_0_0.5","Prominences_0.5_1","Prominences_1_1.5","Prominences_1.5_2","Prominences_2_2.5","Prominences_2.5_3"]
area = ["Frequency_domain_area"]
features = [time,PASA,Mitbandfit,Intercept,area,FWHM,Prominences]
parameters = features
end