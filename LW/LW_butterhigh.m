function [outheader,outdata] = LW_butterhigh(header,data,locutoff1,locutoff2,stopband,passband)
% LW_butterlow
% Apply a zero-phase butterworth high-pass filter
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - locutoff1 (e.g. 0.1)
% - locutoff2 (e.g. 0.5)
% - stopband (e.g. 30)
% - passband (e.g. 3)
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : butter_hipass.m (part of LW5)
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
outheader.history(i).description='LW_butterhigh';
outheader.history(i).date=date;
outheader.history(i).index=[locutoff1,locutoff2,stopband,passband];

%prepare outdata
outdata=zeros(size(data));

%butter_hipass
for epochpos=1:size(data,1);
    for chanpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    outdata(epochpos,chanpos,indexpos,dz,dy,:)=butter_hipass(squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)),locutoff1,locutoff2,stopband,passband,1/header.xstep);
                end;
            end;
        end;
    end;
end;
