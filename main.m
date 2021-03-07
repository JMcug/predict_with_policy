clc
clear all
close all

current_path=pwd;
%%
im_path=strcat(current_path,'\data\DEM'); 
dirname = fullfile(im_path,'*.tif');
imglist = dir(dirname);
imgname=fullfile(imglist(1).name);   
DEM=double(imread(imgname));
       
im_path=strcat(current_path,'\data\landuse'); 
dirname = fullfile(im_path,'*.tif');
imglist = dir(dirname);
imgname=fullfile(imglist(1).name);   
IMin=double(imread(imgname));
[m,n]=size(IMin);
nyear=length(imglist);
D=zeros(m,n,nyear);
for k = 1:nyear
    imgname=fullfile(imglist(k).name);   
    IMin=double( imread(imgname));
    D(:,:,k)=IMin;
end 

year=8;
Year=[1988,1993,1999,2001,2005,2008,2011,2013,2015];

for k=1:nyear
    for i=1:m
        for j=1:n
            if(D(i,j,k)==127)
                temp(i,j,k)=8;
            else
                temp(i,j,k)=D(i,j,k);
            end
        end
    end
end

%%
for k=1:7
    dem(k)=mean(DEM(find(temp(:,:,year)==k)));
end
    

PP=zeros(8,8,length(imglist));
PP(1:7,1:7,:)=transfer(temp,nyear,Year);

pre(:,:,year)=temp(:,:,year);

for i=2:m-1
    for j=2:n-1
        if(pre(i,j,year)~=8)
            [Type,nabor]=PNabor(i,j,pre,PP);
            
%         Type=[PP(pre(i,j,year),pre(i-1,j,year),nyear),PP(pre(i,j,year),pre(i,j-1,year),nyear),PP(pre(i,j,year),pre(i,j+1,year),nyear),PP(pre(i,j,year),pre(i+1,j,year),nyear)];
%         nabor=[pre(i-1,j,year),pre(i,j-1,year),pre(i,j+1,year),pre(i+1,j,year)];
        
        label=zeros(1,8);
        for k=1:length(nabor)
            label(nabor(k))=label(nabor(k))+1;
        end
        
        Type1=sort(Type,'descend');
        label1=sort(label,'descend');
        
        if (Type1(1)>0)
            mm1=find(Type==Type1(1));
            class1=nabor(mm1(1));
            mm2=find(label==label1(1));
            if (mm2(1)==8)
                class2=find(label==label1(2));
            else
                class2=mm2(1);
            end
            class2=class1;
            

            dem1=abs(dem-DEM(i,j));
            dem2=sort(dem1);

            if (find(class2==class1))
                 pre(i,j,year)=class1;
            else 
                for k=1:7
                    class3=find(dem1==dem2(k));
                    if (find(nabor==class3))
                        pre(i,j,year)=class3;
                        break
                    end
                end
                pre(i,j,year)=class2(1);
            end
        end
        else
            pre(i,j,year)=temp(i,j,year);
        end
    end
end



for i=1:7
    class(i)=length(find(pre(:,:,year)==i));
    right(i)=length(find(temp(:,:,year+1)==i));
end

DD=length(find(D(:,:,year)==127));
temp_pre=temp(:,:,year+1)-pre(:,:,year);
pe=sum(class.*right)/((n*m-DD)*(n*m-DD));
po=(length(find(temp_pre==0))-DD)/(n*m-DD);
kappa=(po-pe)/(1-pe);

A=temp(:,:,year);
B=pre(:,:,year);
C=temp(:,:,year+1);
figure(1);imagesc(A);
figure(2);imagesc(B);
figure(3);imagesc(C);






