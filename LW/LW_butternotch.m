function [outheader,outdata] = LW_butternotch(header,data,locutoff1,locutoff2,hicutoff1,hicutoff2,stopband,passband)
% LW_butternotch
% Apply a zero-phase butterworth notch filter
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - locutoff1 (e.g. 48)
% - locutoff2 (e.g. 49)
% - hicutoff1 (e.g. 51)
% - hicutoff2 (e.g. 52)
% - stopband (e.g. 30)
% - passband (e.g. 3)
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : butter_notch.m (part of LW5)
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
%


%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_butternotch';
outheader.history(i).date=date;
outheader.history(i).index=[locutoff1,locutoff2,hicutoff1,hicutoff2,stopband,passband];

%prepare outdata
outdata=zeros(size(data));

%butter_notch
for epochpos=1:size(data,1);
    for chanpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    outdata(epochpos,chanpos,indexpos,dz,dy,:)=butter_notch(squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)),locutoff1,locutoff2,hicutoff1,hicutoff2,stopband,passband,1/header.xstep);
                end;
            end;
        end;
    end;
end;
