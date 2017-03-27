function [outheader_pvalue,outdata_pvalue,outheader_Fvalue,outdata_Fvalue] = LW_custANOVA(headers,datas,within_levels,within_labels,between_levels,between_labels);
%LW_mmanova
%



%results=anovaNxM(tpdata,tpsubjects,wtfactors,wtfactornames,btfactors,btfactornames);

outheader_pvalue=[];
outheader_Fvalue=[];
outdata_pvalue=[];
outdata_Fvalue=[];

%prepare wtfactornames
wtfactornames=within_labels;

%prepare btfactornames
btfactornames=between_labels;


%prepare tpsubjects
k=1;
for datapos=1:length(headers);
    num_epochs=headers(datapos).header.datasize(1);
    for i=1:num_epochs;
        tpsubjects(k)=i;
        k=k+1;
    end;
end;
tpsubjects=tpsubjects';

%prepare wtfactors
if isempty(within_levels);
    wtfactors=[];
else
    k=1;
    for datapos=1:length(headers);
        num_epochs=headers(datapos).header.datasize(1);
        for i=1:num_epochs;
            wtfactors(k,:)=within_levels(datapos,:);
            k=k+1;
        end;
    end;
end;

%prepare btfactors
if isempty(between_levels);
    btfactors=[];
else
    k=1;
    for datapos=1:length(headers);
        num_epochs=headers(datapos).header.datasize(1);
        for i=1:num_epochs;
            btfactors(k,:)=between_levels(datapos,:);
            k=k+1;
        end;
    end;
end;

%prepare tpdata_datapos
k=1;
for datapos=1:length(headers);
    for i=1:num_epochs;
        tpdata_datapos(k)=datapos;
        tpdata_epochpos(k)=i;
        k=k+1;
    end;
end;

%header
header=headers(1).header;

%total iterations
total_tests=header.datasize(2)*header.datasize(4)*header.datasize(5)*header.datasize(6);
disp(['Total number of tests to perform : ' num2str(total_tests)]);
progress_increment=total_tests/100;

if isempty(within_levels);
    disp('Using anovaN');
    %loop anovaN anovan(tpdata,wtfactors,'model','full');
    for channelpos=1:header.datasize(2);
        for dz=1:header.datasize(4);
            for dy=1:header.datasize(5);
                disp(['C:' num2str(channelpos) ' Z:' num2str(dz) ' Y:' num2str(dy)]);
                for dx=1:header.datasize(6);
                    tpdata=[];
                    for i=1:length(tpdata_datapos);
                        tpdata(i)=datas(tpdata_datapos(i)).data(tpdata_epochpos(i),channelpos,1,dz,dy,dx);
                    end;
                    tpdata=tpdata';
                    [result_p,result_T]=anovan(tpdata,btfactors,'varnames',btfactornames,'model','interaction','display','off');
                    T=cell2mat(result_T(2:size(result_T,1)-2,2:size(result_T,2)));
                    for i=1:size(T,1);
                        outdata_pvalue(1,channelpos,i,dz,dy,dx)=T(i,6);
                        outdata_Fvalue(1,channelpos,i,dz,dy,dx)=T(i,5);
                    end;
                end;
            end;
        end;
    end;
    outheader_pvalue=header;
    outheader_pvalue.datasize=size(outdata_pvalue);
    for i=2:size(result_T,1)-2;
        outheader_pvalue.indexlabels{i-1}=result_T{i,1};
    end;
    outheader_Fvalue=outheader_pvalue;
else
    tic;
    outdata_pvalue=zeros(1,header.datasize(2),2^length(wtfactornames)-1,header.datasize(4),header.datasize(5),header.datasize(6));
    outdata_Fvalue=zeros(1,header.datasize(2),2^length(wtfactornames)-1,header.datasize(4),header.datasize(5),header.datasize(6));
    pvalue=cell(header.datasize(2),header.datasize(4),header.datasize(5));
    Fvalue=cell(header.datasize(2),header.datasize(4),header.datasize(5));
    for channelpos=1:header.datasize(2);
        for dz=1:header.datasize(4);
            for dy=1:header.datasize(5);
                disp(['C:' num2str(channelpos) ' Z:' num2str(dz) ' Y:' num2str(dy)]);
                tpdata=[];
                for k=1:length(headers)
                    tpdata=[tpdata;squeeze(datas(k).data(:,channelpos,1,dz,dy,:))];
                end
                result=anovaNxM(tpdata,tpsubjects,wtfactors,wtfactornames,btfactors,btfactornames);
                pvalue{channelpos,dz,dy}=zeros(2^length(wtfactornames)-1,header.datasize(6));
                Fvalue{channelpos,dz,dy}=zeros(2^length(wtfactornames)-1,header.datasize(6));
                for i=1:length(result.eff);
                    pvalue{channelpos,dz,dy}(i,:)=result.eff(i).p;
                    Fvalue{channelpos,dz,dy}(i,:)=result.eff(i).F;
                end;
            end
        end
    end
    
    for channelpos=1:header.datasize(2);
        for dz=1:header.datasize(4);
            for dy=1:header.datasize(5);
                for i=1:2^length(wtfactornames)-1;
                    outdata_pvalue(1,channelpos,i,dz,dy,:)=pvalue{channelpos,dz,dy}(i,:);
                    outdata_Fvalue(1,channelpos,i,dz,dy,:)=Fvalue{channelpos,dz,dy}(i,:);
                end;
            end
        end
    end
    outheader_pvalue=header;
    outheader_pvalue.datasize=size(outdata_pvalue);
    result=anovaNxM(rand(length(tpsubjects),1),tpsubjects,wtfactors,wtfactornames,btfactors,btfactornames);
    for i=1:length(result.eff);
        outheader_pvalue.indexlabels{i}=result.eff(i).Name;
    end;
    outheader_Fvalue=outheader_pvalue;
    toc;
    
    %     tic;
    %     %loop anovaNxM
    %     disp('Using anovaNxM');
    %     for channelpos=1:header.datasize(2);
    %         for dz=1:header.datasize(4);
    %             for dy=1:header.datasize(5);
    %                 disp(['C:' num2str(channelpos) ' Z:' num2str(dz) ' Y:' num2str(dy)]);
    %                 for dx=1:header.datasize(6);
    %                     tpdata=[];
    %                     for i=1:length(tpdata_datapos);
    %                         tpdata(i)=datas(tpdata_datapos(i)).data(tpdata_epochpos(i),channelpos,1,dz,dy,dx);
    %                     end;
    %                     tpdata=tpdata';
    %                     result=anovaNxM(tpdata,tpsubjects,wtfactors,wtfactornames,btfactors,btfactornames);
    %                     for i=1:length(result.eff);
    %                         outdata_pvalue(1,channelpos,i,dz,dy,dx)=result.eff(i).p;
    %                         outdata_Fvalue(1,channelpos,i,dz,dy,dx)=result.eff(i).F;
    %                     end;
    %                 end;
    %             end;
    %         end;
    %     end;
    %     toc;
    %     outheader_pvalue=header;
    %     outheader_pvalue.datasize=size(outdata_pvalue);
    %     for i=1:length(result.eff);
    %         outheader_pvalue.indexlabels{i}=result.eff(i).Name;
    %     end;
    %     outheader_Fvalue=outheader_pvalue;
end;


end
