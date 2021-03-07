function [Tout,Nout]=PNabor(i,j,pre,PP)
year=8;
nyear=9;
num=1;
for i1=i-1:i+1
    for j1=j-1:j+1
        Type(num)=PP(pre(i,j,year),pre(i1,j1,year),nyear);
        nabor(num)=pre(i1,j1,year);
        num=num+1;
    end
end
Tout=Type;
Nout=nabor;