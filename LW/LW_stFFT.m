function [outheader,outdata] = LW_stFFT(header,data,freqstart,freqstep,freqsize,window,dxstep,postproc,output,baseline,baseline_start,baseline_end)
% LW_stFFT
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - freqstart : frequency of first line
% - freqstep : frequency step
% - freqsize : number of lines
% - window : width of the Hanning window (in s)
% - dxstep : (size=xsize/dxstep)
% - postproc : 'none','abs','square','angle'
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none.
%
% Author : 
% Andr?Mouraux
% Institute of Neurosciences (IONS)
% Universit?catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information




%transfer header to outheader
outheader=header;

%update outheader YStep and YStart
outheader.ystep=freqstep;
outheader.ystart=freqstart;

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
outheader.history(i).description='LW_stFFT';
outheader.history(i).date=date;
outheader.history(i).index=[freqstart,freqstep,freqsize,window,dxstep,postproc];

%freqs
frequencies=1:1:freqsize;
frequencies=freqstart+((frequencies-1)*freqstep);

%window > dxwindow
dxwindow=fix(window/header.xstep);

%dxstep > noverlap
noverlap=dxwindow-dxstep;

%disp
disp(['Window : ',num2str(dxwindow),' NOverlap : ',num2str(noverlap)]);

%k
k=fix((header.datasize(6)-noverlap)/(dxwindow-noverlap));

%adjust outheader.datasize
outheader.datasize(6)=k;
outheader.datasize(5)=freqsize;

%outheader.xstep
[S,F,T]=spectrogram(squeeze(data(1,1,1,1,1,:)),dxwindow,noverlap,frequencies,1/header.xstep);
outheader.xstart=header.xstart+T(1);
outheader.xstep=T(2)-T(1);

if strcmpi(output,'average');
        outheader.datasize(1)=1;
    end;
        
%prepare outdata
outdata=zeros(outheader.datasize);

%loop through all the data
z=1;
y=1;

outarray=zeros(outheader.datasize(5),outheader.datasize(6));
for channelpos=1:size(data,2);
    disp(['channel: ',num2str(channelpos)]);
    for indexpos=1:size(data,3);
        for epochpos=1:size(data,1);
            disp(['epoch: ',num2str(epochpos)]);
            if strcmpi(postproc,'none');
                %outdata(epochpos,channelpos,indexpos,dz,:,:)=spectrogram(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),dxwindow,noverlap,frequencies,1/header.xstep);
                outarray(:,:)=spectrogram(squeeze(data(epochpos,channelpos,indexpos,z,y,:)),dxwindow,noverlap,frequencies,1/header.xstep);
            end;
            if strcmpi(postproc,'abs');
                %outdata(epochpos,channelpos,indexpos,dz,:,:)=abs(spectrogram(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),dxwindow,noverlap,frequencies,1/header.xstep));
                outarray(:,:)=abs(spectrogram(squeeze(data(epochpos,channelpos,indexpos,z,y,:)),dxwindow,noverlap,frequencies,1/header.xstep));
            end;
            if strcmpi(postproc,'square');
                %outdata(epochpos,channelpos,indexpos,dz,:,:)=abs(spectrogram(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),dxwindow,noverlap,frequencies,1/header.xstep))^2;
                outarray(:,:)=abs(spectrogram(squeeze(data(epochpos,channelpos,indexpos,z,y,:)),dxwindow,noverlap,frequencies,1/header.xstep))^2;
            end;
            if strcmpi(postproc,'angle');
                %outdata(epochpos,channelpos,indexpos,dz,:,:)=angle(spectrogram(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),dxwindow,noverlap,frequencies,1/header.xstep));
                outarray(:,:)=angle(spectrogram(squeeze(data(epochpos,channelpos,indexpos,z,y,:)),dxwindow,noverlap,frequencies,1/header.xstep));
            end;
            if strcmpi(baseline,'subtract');
                bl1=round((baseline_start-outheader.xstart)/outheader.xstep)+1;
                bl2=round((baseline_end-outheader.xstart)/outheader.xstep)+1;
                outarray_mean=mean(outarray(:,bl1:bl2),2);
                for dy=1:outheader.datasize(5);
                    outarray(dy,:)=outarray(dy,:)-outarray_mean(dy);
                end;
            end;
            if strcmpi(baseline,'percent');
                bl1=round((baseline_start-outheader.xstart)/outheader.xstep)+1;
                bl2=round((baseline_end-outheader.xstart)/outheader.xstep)+1;
                outarray_mean=mean(outarray(:,bl1:bl2),2);
                for dy=1:outheader.datasize(5);
                    outarray(dy,:)=(outarray(dy,:)-outarray_mean(dy))/outarray_mean(dy);
                end;
            end;
            if strcmpi(output,'average');
                outdata(1,channelpos,indexpos,z,:,:)=squeeze(outdata(1,channelpos,indexpos,z,:,:))+outarray;
            else
                outdata(epochpos,channelpos,indexpos,z,:,:)=outarray;
            end;
        end;
        if strcmpi(output,'average');
            outdata=outdata/size(data,1);
            outheader.datasize(1)=1;
        end
    end;
end;

