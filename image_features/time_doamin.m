function [P2P_Amp,positive_Amp,negative_Amp,positive_slope,negative_slope,time_area,first,second,third,fourth] = time_doamin(data,num)
    y=data(:,2)
    
    M = max(y)
    mi = min(y)
    P2P_Amp = M-mi

    [ipt,residual] = findchangepts(y,'MaxNumChanges',num)

    c=1
    [voltage_max,pos] = max(data(:,2))
    
    [point,index] = sort(abs(ipt-pos))
    if ipt(index(1)) < pos
        second = ipt(index(1))
        first = ipt(index(1)-1)
        third = ipt(index(1)+1)
        fourth = ipt(index(1)+2)
        if abs(second-first) <= 250
            second = ipt(index(1)-1)
            first = ipt(index(1)-2)
        end
        if abs(fourth-third) <= 250
            third = ipt(index(1)+2)
            fourth = ipt(index(1)+3)
        end
    end
    if ipt(index(1)) > pos
        second = ipt(index(1)-1)
        first = ipt(index(1)-2)
        third = ipt(index(1))
        if third == ipt(end)
           fourth = 2500
        else
           fourth = ipt(index(1)+1)
        end
        if abs(second-first) <= 250
            second = ipt(index(1)-2)
            first = ipt(index(1)-3)
        end
        if abs(fourth-third) <= 250
            third = ipt(index(1)+1)
            fourth = ipt(index(1)+2)
        end
    end
    for b = 1:2500
        if data(b,1) >= data(first,1) & data(b,1) <= data(second,1)
            data2(c,1) = data(b,2)
            c = c+1
        elseif data(b,1) >= data(third,1) & data(b,1) <= data(fourth,1)
            data2(c,1) = data(b,2)
            c = c+1  
        end
    end
    voltage_Avg=mean(data2)
    positive_Amp = voltage_max - voltage_Avg
    negative_Amp = P2P_Amp - positive_Amp
    
    p = polyfit(data(second:pos,1),data(second:pos,2),1)
    f = polyval(p,data(second:pos,1))
    p1 = polyfit(data(pos:third,1),data(pos:third,2),1)
    f1 = polyval(p1,data(pos:third,1))
    positive_slope = p(1)
    negative_slope = p1(1)
    
    time_area = trapz(data(:,1),data(:,2))
 end