function [outheader,outdata] = LW_mmanova(headers,datas,groups,within,model)
%LW_mmanova 
%
% - datas : array of LW5 datas (datas(i).data)
% - headers : array of LW5 headers (headers(i).header)
% - groups : matrix n datafiles x m groups
% - within : matrix m groupd 0=between,1=within
% - model : 

groups
within
model

full_group=[];
%observations
for i=1:length(headers);
    header=headers(i).header;
    tp=1:1:header.datasize(1);
    full_group=[full_group tp];
end;
full_groups(:,1)=full_group;

%full_groups
for j=1:size(groups,2);
    full_group=[];
    for i=1:size(groups,1);
        header=headers(i).header;
        tp=zeros(1,header.datasize(1));
        tp=tp+groups(i,j);
        full_group=[full_group tp];
    end;
    full_groups(:,j+1)=full_group;
end;

%model
%model=fliplr(model); %CHECK WHETHER THE ORDER OF THE FACTORS SHOULD BE REVERSED???
tp=zeros(1,size(model,2));
model=vertcat(tp,model);

%anova_type
within_groups=find(within==1);
between_groups=find(within==0);
anova_type=3;
if isempty(within_groups);
    anova_type=2;
end;
if isempty(between_groups);
    anova_type=1;
end;

%disp
if anova_type==1;
    disp('Factors are all within subject : repeated-measures ANOVA');
end;
if anova_type==2;
    disp('Factors are all between subject : ANOVA');
end;
if anova_type==3;
    disp('Model includes both within and between-subject factors : mixed-model ANOVA');
end;



%mixed model : 
if anova_type==3;
    %grouping group
    tp=full_groups(:,between_groups);
    k=1;
    tp2(1)=1;
    for i=2:size(tp,1);
        ok=0;
        for j=1:size(tp,2);
            if tp(i,j)==tp(i-1,j);
            else
                ok=1;
            end;
        end;
        if ok==1;
            k=k+1;
        end;
        tp2(i)=k;
    end;
    full_groups(:,size(full_groups,2)+1)=tp2;
    %nest
    nest=zeros(size(full_groups,2));
    nest(1,size(full_groups,2))=1;
    %model
    tp=zeros(1,size(model,2));
    model=vertcat(model,tp);
end;

%disp('Running point-by-point ANOVA. This may take a while!');

%rotate model
model=model';

%anovan (mixed model)
datasize=headers(1).header.datasize;
%prepare outdata
datasize(1)=size(model,1);
outdata=zeros(datasize);

%mixed model anova
if anova_type==3;
    %loop through channels
    for channelpos=1:datasize(2);
        disp(['Channel : ' headers(1).header.chanlocs(channelpos).labels]);
        %loop through indexes
        for indexpos=1:datasize(3);
            %loop through z
            for dz=1:datasize(4);
                %loop through y
                for dy=1:datasize(5);
                    %loop through x
                    for dx=1:datasize(6);
                        tpdata=[];
                        for datapos=1:length(datas);
                            tpdata=[tpdata squeeze(datas(datapos).data(:,channelpos,indexpos,dz,dy,dx))'];
                        end;
                        outdata(:,channelpos,indexpos,dz,dy,dx)=anovan(tpdata,full_groups,'random',1,'nested',nest,'display','off','model',model);
                    end;
                end;
            end;
        end;
    end;
end;

%between-subject anova
if anova_type==2;
    %loop through channels
    for channelpos=1:datasize(2);
        disp(['Channel : ' headers(1).header.chanlocs(channelpos).labels]);
        %loop through indexes
        for indexpos=1:datasize(3);
            %loop through z
            for dz=1:datasize(4);
                %loop through y
                for dy=1:datasize(5);
                    %loop through x
                    for dx=1:datasize(6);
                        tpdata=[];
                        for datapos=1:length(datas);
                            tpdata=[tpdata squeeze(datas(datapos).data(:,channelpos,indexpos,dz,dy,dx))'];
                        end;
                        outdata(:,channelpos,indexpos,dz,dy,dx)=anovan(tpdata,full_groups,'display','off','model',model);
                    end;
                end;
            end;
        end;
    end;
end;

full_groups
model

%repeated-measures anova
if anova_type==1;
    %loop through channels
    for channelpos=1:datasize(2);
        disp(['Channel : ' headers(1).header.chanlocs(channelpos).labels]);
        %loop through indexes
        for indexpos=1:datasize(3);
            %loop through z
            for dz=1:datasize(4);
                %loop through y
                for dy=1:datasize(5);
                    %loop through x
                    for dx=1:datasize(6);
                        tpdata=[];
                        for datapos=1:length(datas);
                            tpdata=[tpdata squeeze(datas(datapos).data(:,channelpos,indexpos,dz,dy,dx))'];
                        end;
                        outdata(:,channelpos,indexpos,dz,dy,dx)=anovan(tpdata,full_groups,'random',1,'display','off','model',model);
                    end;
                end;
            end;
        end;
    end;
end;


%outheader
outheader=headers(1).header;
outheader.datasize=datasize;

end
