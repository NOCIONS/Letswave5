function [outheader,outdata]=LW_FFTnotch(header,data,freq,freq_width,num_harmonics);
% LW_averageepochs
% Average epochs
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - freq
% - freq_width
% - num_harmonics
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : none
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
%

%store header in headertime for iFFT
headertime=header;
%FFT
disp('*** Computing FFT');
[header,data]=LW_FFT(header,data,'complex',0,'no');
%notch filter
disp('*** Notch filter');
locutoff=freq;
locutoffwidth=freq_width;
hicutoff=freq;
hicutoffwidth=freq_width;
vector=LW_buildFFTbandpass(header,locutoff,hicutoff,locutoffwidth,hicutoffwidth);
vector=(vector-1)*-1;
if num_harmonics>1;
    for harmonicpos=2:num_harmonics;
        locutoff=harmonicpos*freq;
        locutoffwidth=freq_width;
        hicutoff=harmonicpos*freq;
        hicutoffwidth=freq_width;
        vector=vector.*((LW_buildFFTbandpass(header,locutoff,hicutoff,locutoffwidth,hicutoffwidth)-1)*-1);
    end;
end;
%invert vector
%figure;plot(vector);
%filter
disp('*** Filtering FFT product');
[header,data]=LW_multiplyvector(header,data,vector);
%iFFT
disp('*** Computing iFFT');
[outheader,outdata]=LW_iFFT(header,data,headertime,0);
end

