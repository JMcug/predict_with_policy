function [P] =transfer(temp,nyear,Year)

year=8;

for q=1:nyear-1
    NC(:,:,q)=temp(:,:,q)*10+temp(:,:,q+1);
end

for k=1:nyear-1
    for i=1:7
        for j=1:7
            te=i*10+j;
            LU=length(find(temp(:,:,k)==i));
            C=length(find(NC(:,:,k)==te));
            T=1;
            P(i,j,k)=C/(LU*T);
        end
    end
end
P(5,:,:)=0;

Year=Year-1987;
for i=1:7
    for j=1:7
        for k=1:nyear-2
            Py(k)=P(i,j,k);
        end
        x=Year(1:end-2);
        y=polyfit(x,Py,1);
        xi=1:Year(year);
        yi=polyval(y,xi);
        P(i,j,nyear)=yi(Year(year));
        count(i,j)=yi(Year(year))*length(find(NC(:,:,year)==i));
    end
end
