function correct_data = correct_data(data,all_parameters)

data(1,:) = []
a = size(data)
count = a(2)
for i = 1:count
   zero = find(isnan(data(:,i)))
   zero_count = size(zero) 
   half = a(1)/2

   if zero_count(1) > 0 & zero_count(1) < half
       tmp = find(~isnan(data(:,i)))
       tmp1 = data(tmp,i)
       tmp2 = mean(tmp1)
        for j = 1:zero_count(1)  
            data(zero(j),i) = tmp2
        end
   end
end

final = [all_parameters;data]
result = rmmissing(final,2)
correct_data = result

end