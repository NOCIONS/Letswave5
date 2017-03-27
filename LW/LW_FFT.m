function [outheader,outdata] = LW_FFT(header,data,output,half,normalize)
% LW_FFT
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - output : 'power', 'amplitude', 'complex' , 'phase' or 'special'
% - half : half=0: output the entire spectrum, half=1: output half of the spectrum
% - normalize: 'yes', 'no'
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
if strcmpi(header.filetype,'time_amplitude');
else
    disp('!!! WARNING : input data is not of format time_amplitude !!!');
end;

%transfer header to outheader
outheader=header;

%adjust outheader
%xstart
outheader.xstart=0;
%xsize=samplingrate
outheader.xstep=1/(header.xstep*size(data,6));
%outheader.filetype
if strcmpi(output,'power');
    outheader.filetype='frequency_power';
end;
if strcmpi(output,'amplitude');
    outheader.filetype='frequency_amplitude';
end;
if strcmpi(output,'phase');
    outheader.filetype='frequency_phase';
end;
if strcmpi(output,'complex');
    outheader.filetype='frequency_complex';
end;


%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_FFT';
outheader.history(i).date=date;
outheader.history(i).index=[output];

%delete events
if isfield(outheader,'events');
    outheader=rmfield(outheader,'events');
end;

disp(['postprocess : ',output]);

%loop through all the data
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    if strcmpi(output,'complex');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=fft(data(epochpos,channelpos,indexpos,dz,dy,:));
%                         if strcmpi(normalize,'yes');
%                             data=data/size(data,6);
%                         end;
                    end;
                    if strcmpi(output,'amplitude');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=abs(fft(data(epochpos,channelpos,indexpos,dz,dy,:)));
%                         if strcmpi(normalize,'yes');
%                             data=data/size(data,6);
%                         end;
                    end;
                    if strcmpi(output,'power');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=abs(fft(data(epochpos,channelpos,indexpos,dz,dy,:)));
%                         if strcmpi(normalize,'yes');
%                             data=data/size(data,6);
%                         end;
%                         data=data.^2;
                    end;
                    if strcmpi(output,'phase');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=angle(fft(data(epochpos,channelpos,indexpos,dz,dy,:)));
                    end;
                    if strcmpi(output,'real');
                         data(epochpos,channelpos,indexpos,dz,dy,:)=real(fft(data(epochpos,channelpos,indexpos,dz,dy,:)));
%                         if strcmpi(normalize,'yes');
%                             data=data/size(data,6);
%                         end;                
                    end;
                    if strcmpi(output,'imag');
                         data(epochpos,channelpos,indexpos,dz,dy,:)=imag(fft(data(epochpos,channelpos,indexpos,dz,dy,:)));
%                         if strcmpi(normalize,'yes');
%                             data=data/size(data,6);
%                         end;
                    end;
                    if strcmpi(output,'special');
                    end;
                end;
            end;
        end;
    end;
end;


% Do we need to normalize?
if strcmpi(normalize,'yes');
data=data/size(data,6);
end

%Do we need to square? (power)
if strcmpi(output,'power');
    data=data.^2;
end;

%half if half=1
if half==1;
    outdata(:,:,:,:,:,:)=data(:,:,:,:,:,1:fix(size(data,6)/2));
    outdata(:,:,:,:,:,2:end)=outdata(:,:,:,:,:,2:end)*2;
else
    outdata=data;
end;

%outheader size
outheader.datasize=size(outdata);
