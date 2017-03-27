function [outheader,outdata] = LW_iFFT(header,data,header_time,makereal)
% LW_iFFT
%
% Inputs
% - header (LW5 header) of the FFT data
% - data (LW5 data) of the FFT data
% - header_time (LW5 header) of data to recover temporal information, including events
% - makereal=0: ifft(); makereal=1: abs(ifft())
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


%warning
if strcmpi(header.filetype,'frequency_complex');
else
    disp('!!! WARNING : input data is not of format frequency_complex !!!');
end;

%transfer header to outheader
outheader=header;
outheader.xstart=header_time.xstart;
outheader.xstep=header_time.xstep;
if isfield(header_time,'events');
    outheader.events=header_time.events;
end;

outheader.filetype='time_amplitude';

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_iFFT';
outheader.history(i).date=date;
outheader.history(i).index=[];


%loop through all the data
if makereal==1;
    for epochpos=1:size(data,1);
        for channelpos=1:size(data,2);
            for indexpos=1:size(data,3);
                for dz=1:size(data,4);
                    for dy=1:size(data,5);
                        data(epochpos,channelpos,indexpos,dz,dy,:)=real(ifft(data(epochpos,channelpos,indexpos,dz,dy,:)));
                    end;
                end;
            end;
        end;
    end;
else
    for epochpos=1:size(data,1);
        for channelpos=1:size(data,2);
            for indexpos=1:size(data,3);
                for dz=1:size(data,4);
                    for dy=1:size(data,5);
                        data(epochpos,channelpos,indexpos,dz,dy,:)=ifft(data(epochpos,channelpos,indexpos,dz,dy,:));
                    end;
                end;
            end;
        end;
    end;
end;    


%output
outdata=data;
