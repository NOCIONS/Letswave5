function [outheader,outdata] = LW_CWT(header,data,freqstart,freqstep,freqsize,wname,postproc,verbose)
% LW_CWT
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - freqstart : frequency of first line
% - freqstep : frequency step
% - freqsize : number of lines
% - wname : type of wavelet
% - postproc : select 'none','abs','square','angle'
% - verbose : 'on' or 'off'
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none.
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

%update outheader YSize
outheader.datasize(5)=freqsize;
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
outheader.history(i).description='LW_CWT';
outheader.history(i).date=date;
outheader.history(i).index=[freqstart,freqstep,freqsize,wname,postproc];

if strcmpi(verbose,'on')==1;
    disp(['postprocess :',postproc]);
    disp(['wavelet : ',wname]);
end;

%central frequency of chosen mother wavelet
centralfreq=centfrq(wname);

%freqs
frequencies=1:1:freqsize;
frequencies=freqstart+((frequencies-1)*freqstep);

%scales
scales=(centralfreq/header.xstep)./frequencies;

%prepare outdata
outdata=zeros(outheader.datasize);

%loop through all the data
dz=1;
dy=1;
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            if strcmpi(verbose,'on');
                disp(['E:',num2str(epochpos),' C:',num2str(channelpos),' I:',num2str(indexpos)]);
            end;
            if strcmpi(postproc,'none');
                outdata(epochpos,channelpos,indexpos,dz,:,:)=cwt(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),scales,wname);
            end;
            if strcmpi(postproc,'abs');
                outdata(epochpos,channelpos,indexpos,dz,:,:)=abs(cwt(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),scales,wname));
            end;
            if strcmpi(postproc,'square');
                outdata(epochpos,channelpos,indexpos,dz,:,:)=abs(cwt(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),scales,wname)).^2;
            end;
            if strcmpi(postproc,'angle');
                outdata(epochpos,channelpos,indexpos,dz,:,:)=angle(cwt(squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)),scales,wname));
            end;
        end;
    end;
end;

