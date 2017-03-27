function [outheader,outdata] = LW_timecourse_CCA(header,data,fre,windowsize,windowstep)
% LW_timecourse_CCA
% get the time course response for certain frequency points
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - windowsize : width of the window (in s)
% - windowstep : step of the window (in s)
% - windowtype : 'hann'
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none
%
% Author :
% Gan Huang
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
%
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%


%transfer header to outheader
outheader=header;
i=length(outheader.history)+1;
outheader.history(i).description='LW_timecourse_CCA';
outheader.history(i).date=date;
outheader.history(i).index=[fre,windowsize,windowstep];


Fs=1/header.xstep;
win_size=round(windowsize/header.xstep);
win_step=round(windowstep/header.xstep);
hann_win =hann(win_size);

t=header.xstart:header.xstep:header.xstart+header.xstep*(header.datasize(6)-1);
win_start=0:win_step:length(t)-win_size;
t_new=t(win_start+1)+(win_size-1)*header.xstep/2;
outheader.xstep=win_step*header.xstep;
outheader.xstart=t_new(1);
outdata=zeros(size(data,1),1,header.datasize(3),header.datasize(4),size(data,5),length(t_new));
outheader.datasize=size(outdata);

wave=[];
for k=1:length(fre)
    wave=[wave;sin(2*pi*fre(k)*(1:win_size)/Fs);cos(2*pi*fre(k)*(1:win_size)/Fs)];
end
for epochpos=1:size(data,1)
    for indexpos=1:header.datasize(3)
        for dz=1:header.datasize(4)
            for dy=1:size(data,5)
                for k=1:length(win_start)
                    data_temp=squeeze(data(epochpos,:,indexpos,dz,dy,win_start(k)+(1:win_size))).*(ones(size(data,2),1)*hann_win');
                    [~,~,r,~,~] = canoncorr(data_temp',wave');
                    outdata(epochpos,1,indexpos,dz,dy,k)=r(1);
                end
            end
        end
    end
end
