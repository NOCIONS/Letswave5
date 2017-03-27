function [outheader,outdata] = LW_artefactsuppression(header,data,x1,x2)
% LW_artefactsuppression
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - x1,x2
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none.
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

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_artefactsuppression';
outheader.history(i).date=date;
outheader.history(i).index=[x1,x2];

%determine dx1 and dx2
dx1=fix(((x1-header.xstart)/header.xstep)+1);
dx2=fix(((x2-header.xstart)/header.xstep)+1);

%set outdata
outdata=data;

%loop 
xv=[dx1 dx2];
xi=dx1:1:dx2;
for epochpos=1:header.datasize(1);
    for chanpos=1:header.datasize(2);
        for indexpos=1:header.datasize(3);
            for dz=1:header.datasize(4);
                for dy=1:header.datasize(5);
                    yv=squeeze(data(epochpos,chanpos,indexpos,dz,dy,[dx1 dx2]));
                    yi=interp1(xv,yv,xi);
                    outdata(epochpos,chanpos,indexpos,dz,dy,dx1:dx2)=yi;
                end;
            end;
        end;
    end;
end;