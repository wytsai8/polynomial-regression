function photoacoustic_avg = photoacoustic_average(data_1)
    a= abs(min(data_1(:,2)))
    data_1(:,12)=data_1(:,2)+a
    data_1(:,13)=data_1(:,3)+a
    data_1(:,14)=data_1(:,4)+a
    data_1(:,15)=data_1(:,5)+a
    data_1(:,16)=data_1(:,6)+a
    data_1(:,17)=data_1(:,7)+a
    data_1(:,18)=data_1(:,8)+a
    data_1(:,19)=data_1(:,9)+a
    data_1(:,20)=data_1(:,10)+a
    data_1(:,21)=data_1(:,11)+a

    time_1 = data_1(:,1)
    voltage_12 = data_1(:,12)
    voltage_13 = data_1(:,13)
    voltage_14 = data_1(:,14)
    voltage_15 = data_1(:,15)
    voltage_16 = data_1(:,16)
    voltage_17 = data_1(:,17)
    voltage_18 = data_1(:,18)
    voltage_19 = data_1(:,19)
    voltage_20 = data_1(:,20)
    voltage_21 = data_1(:,21)
    
    voltage = data_1(:,12:21)
    voltage_Avg = mean(voltage,2)
    voltage_Avg_1 = [time_1 voltage_Avg]

    photoacoustic_avg = voltage_Avg_1
end