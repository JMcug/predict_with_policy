clear all
clc

current_path=pwd;
xls_path=strcat(current_path,'\data\policy\');
flist = dir(sprintf('%s/*.xlsx', xls_path));
xls_name = flist(1).name;
policy_data=xlsread(xls_name);
policy_data(:,end)=round(policy_data(:,end));

im_path=strcat(current_path,'\data\landuse\');
flist = dir(sprintf('%s/*.tif', im_path));
img_num = length(flist);

for i=1:img_num
     image_name = flist(i).name;
     data(:,:,i) =  imread(strcat(im_path,image_name)); 
end

[m,n]=size(data(:,:,1));
D=zeros(m,n,img_num);

%%
for k=1:img_num-1
    for i=1:m
        for j=1:n
            if (data(i,j,k)~=127)
                D(i,j,k)=data(i,j,k)*10+data(i,j,k+1);
            else
                D(i,j,k)=0;
            end
        end
    end
end


for k=1:img_num-1
    for i=1:7
        for j=1:7
        num1=length(find(D(:,:,k)==i*10+j));
        num2=length(find(data(:,:,k)==i));
        P(i,j,k)=num1/num2;
        end
    end
end

year=[1988,1993,1999,2001,2005,2008,2013,2015];
t=year-year(1);
P(5,:,:)=0;
P(:,:,8)=0;

index=find(policy_data==year(end));
policy_year=policy_data(index:end,1);
count=policy_data(index:end,end);

pt=2;
pyear=policy_year(pt)-year(1);


for i=1:7
    for j=1:7
        x=P(i,j,1:end-1);
        x=reshape(x,[1,7]);
        y=polyfit(t(1:end-1),x,2);
        y1=polyval(y,pyear);
        P(i,j,img_num)=y1;
    end
end


%%
for i=1:m
    for j=1:n
        if(data(i,j,7)~=127)
            nabor=Nabor(i,j,data);

            Temp=find(nabor~=127);
            PP=zeros(1,length(Temp));
            for k=1:length(Temp)
                if(Temp(k)==5)
                    nabor1(k)=5;
                else
                    nabor1(k)=nabor(Temp(k));
                end
                PP(k)=P(nabor(5),nabor1(k),8);
            end
            
            [va,po]=max(PP);
            if(nabor(Temp(po(1)))==4)
                if(count(pt)>0)
                count(pt)=count(pt)-1;
                pre(i,j)=4;
                else
                    pre(i,j)=nabor(5);
                end
            else 
                pre(i,j)=nabor(Temp(po(1)));
            end
        else
            pre(i,j)=0;           
            temp=mode(nabor1);
            Pp=P(nabor(5),temp,8);
            pre(i,j)=temp;
        end
    end
end


old=data(:,:,8);
for i=1:7
    a(i)=length(find(old==i));
    b(i)=length(find(pre==i));
end
sample=n*m-length(find(old==127));
pe=sum(a.*b)/(sample*sample);

A=data(:,:,8)-int8(pre);
po=length(find(A==0))/(sample);
kappa=(po-pe)/(1-pe);


figure(1);
imagesc(pre);
axis off;
imwrite(pre,'predict_result\policy2019.tif');


