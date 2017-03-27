function [header,data] = LW_importDELTAMED(filename);
% Import DELTAMED files
%
% Inputs
% - filename: name of TXT header file
%
% Outputs
% - header (LW5 header)
% - data (LW5 data)
%
%
% Author : 
% Andr? Mouraux
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information

%load the TXT file

[p n e]=fileparts(filename);
filename_txt=[p filesep n '.txt'];
disp(['Loading TXT header : ' filename_txt]);
txtfile=fopen(filename_txt);
tp=fgetl(txtfile);
while ischar(tp);
  if length(tp)>=8
    if strcmpi(tp(1:8),'Sampling');
        sampling_rate=str2num(tp(10:length(tp)));
    end;
    if strcmpi(tp(1:8),'Channels');
        st=tp(10:length(tp));
    end;
    if strcmpi(tp(1:8),'Gainx100');
        st2=tp(11:length(tp));
    end;
  end;
  if length(tp)>=7
      if strcmpi(tp(1:7),'[EVENT]');
          break
      end;
  end;
  tp=fgetl(txtfile);
end;


index=1;
while ischar(tp);
    tp=fgetl(txtfile);
    if ischar(tp);
        if length(tp)>1;
            rl=textscan(tp,'%d%s','delimiter',',');
            event_pos(index)=rl{1};
            event_code{index}=rl{2};
            index=index+1;
        end;
    end;
end;

channel_labels=textscan(st,'%s','delimiter',',');
channel_labels=channel_labels{1};
channel_gain=textscan(st2,'%f','delimiter',',');
channel_gain=channel_gain{1};

%channel_gain

xstart=0;
xstep=1/sampling_rate;
event_lat=(double(event_pos)-1).*xstep;

clear header;

for i=1:length(event_code);
    header.events(i).code=cell2mat(event_code{i});
    header.events(i).latency=event_lat(i);
    header.events(i).epoch=1;
end;

for i=1:length(channel_labels);
    header.chanlocs(i).labels=channel_labels{i};
    header.chanlocs(i).topo_enabled=0;
end;

header.filetype='time_amplitude';
header.name=filename_txt;
header.tags='';
header.history(1).description='Import DELTAMED ASCII';
header.history(1).date=date;
header.history(2).index=[];
header.datasize=[0 0 0 0 0 0];
header.xstart=0;
header.xstep=xstep;
header.ystart=0;
header.ystep=1;
header.zstart=0;
header.zstep=1;

disp(['Number of channels : ' num2str(length(header.chanlocs))]);

%load data (ASCII)
filename_bin=[p filesep n '.bin'];
if exist(filename_bin);
    fileID=fopen(filename_bin);
    tp1=fread(fileID,'int16');
    EpochSize=size(tp1,1)/length(header.chanlocs);
    disp(['EpochSize : ' num2str(EpochSize)]);
    tp2=reshape(tp1,length(header.chanlocs),EpochSize);
    data=zeros(1,size(tp2,1),1,1,1,size(tp2,2));
    for chanpos=1:size(tp2,1);
        data(1,chanpos,1,1,1,:)=(tp2(chanpos,:)*channel_gain(chanpos))/1000;
    end;
else
    filename_asc=[p filesep n '.asc'];
    if exist(filename_asc);
        disp('Loading the ASCII data. *** This can take a while***');
        tp=load(filename_asc,'ascii');
        for i=1:size(tp,2);
            data(1,i,1,1,1,:)=(tp(:,i)*channel_gain(i))/1000;
        end;
    else
        disp('!!! No datafile found ???');
    end;
end;
size(data)
header.datasize=size(data);

disp(['Number of epochs : ' num2str(header.datasize(1))]);
disp(['Number of channels : ' num2str(header.datasize(2))]);
disp(['Number of bins : ' num2str(header.datasize(6))]);


fclose('all');

disp('Finished importing');
