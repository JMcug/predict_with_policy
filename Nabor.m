function out=Nabor(i,j,data)

% Na=[data(i-1,j),data(i,j-1),data(i,j),data(i,j+1),data(i+1,j)];

count1=1;
[m1,n1]=size(data);
b=1;
% b=2;
for c1=i-b:i+b
    for b1=j-b:j+b
        if(c1<1||b1<1||c1>m1||b1>n1)
            Na(count1)=0;
        else
        Na(count1)=data(c1,b1);
        end
        count1=count1+1;
    end
end
out=Na;