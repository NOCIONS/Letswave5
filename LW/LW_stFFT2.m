function [outheader,outdata] = LW_stFFT2(header,data,freqstart,freqstep,freqsize,timestart,timestep,timesize,windowsize,windowtype,postproc,average)
% LW_stFFT2
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - freqstart : frequency of first line
% - freqstep : frequency step
% - freqsize : number of lines
% - timestart
% - timestep
% - timesize
% - windowsize : width of the window (in s)
% - windowtype : 'hann'
% - postproc : 'none','abs','square','angle'
% - average : 'yes' 'no'
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : $.
%
% Author : 
% André Mouraux
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information




%transfer header to outheader
outheader=header;

%update outheader YStep, YStart and YSize

outheader.ystep=freqstep;
outheader.ystart=freqstart;
outheader.datasize(5)=freqsize;

%update outheader XStep,XStart and XSize
outheader.xstep=timestep;
outheader.xstart=timestart;
outheader.datasize(6)=timesize;

%prepare xtimes
xtimes=0:header.datasize(6)-1;
xtimes=(xtimes*header.xstep)+header.xstart;

%prepare t
t=0:outheader.datasize(6)-1;
t=(t*outheader.xstep)+outheader.xstart;

%prepare f
f=0:outheader.datasize(5)-1;
f=(f*outheader.ystep)+outheader.ystart;

%prepare Fs
Fs=1/header.xstep;

%prepare winsize (in ms)
winsize=windowsize*1000;

%prepare wintype
wintype=windowtype;

%prepare padvalue
padvalue='circular';

%update file type
if strcmpi(postproc,'none');
    outheader.filetype='frequency_time_complex';
end;
if strcmpi(postproc,'abs');
    outheader.filetype='frequency_time_amplitude';
end;
if strcmpi(postproc,'square');
    outheader.filetype='frequency_time_power';
end;
if strcmpi(postproc,'angle');
    outheader.filetype='frequency_time_phase';
end;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_stFFT2';
outheader.history(i).date=date;
outheader.history(i).index=[freqstart,freqstep,freqsize];

%convert to ms
xtimes=xtimes*1000;
t=t*1000;

%prepare outdata
dt = t(2)-t(1); % time interval (uniform step)
[junk,t_idx_min] = min(abs(xtimes-t(1)));
[junk,t_idx_max] = min(abs(xtimes-t(end)));
t_idx = t_idx_min:round((dt/1000)*Fs):t_idx_max; 
N_T = length(t_idx);
outheader.datasize(6)=N_T;
outdata=zeros(outheader.datasize);

%outheader.xstart and outheader.xstep
outheader.xstart=t(1)/1000;
outheader.xstep=(t(2)-t(1))/1000;

%Loop 
for chanpos=1:header.datasize(2);
    for indexpos=1:header.datasize(3);
        for dz=1:header.datasize(4);
            %prepare x
            x=squeeze(data(:,chanpos,indexpos,dz,1,:))';
            %stfft
            [S,P]=sub_tfa_stft(x,xtimes,t,f,Fs,winsize,wintype,padvalue);
            S=permute(S,[3,1,2]);
            P=permute(P,[3,1,2]);
            if strcmpi(postproc,'none');
                outdata(:,chanpos,indexpos,dz,:,:)=S;
            end;
            if strcmpi(postproc,'abs');
                outdata(:,chanpos,indexpos,dz,:,:)=sqrt(P);
            end;
            if strcmpi(postproc,'square');
                outdata(:,chanpos,indexpos,dz,:,:)=P;
            end;
            if strcmpi(postproc,'angle'); %not functional
                outdata(:,chanpos,indexpos,dz,:,:)=P;
            end;
        end;
    end;
end;

if strcmpi(average,'average');
    outdata=mean(outdata,1);
    outheader.datasize(1)=1;
end;

