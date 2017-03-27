function [outheader,outdata] = LW_interpolate(header,data,method,xsrate,ysrate,zsrate)
% LW_interpolate
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - method (see help interp1: 'nearest','linear','spline','pchip','cubic','v5cubic')
% - xsrate : new X dimension samplingrate (xsrate=0 : do not change X dimension samplingrate)
% - ysrate : new Y dimension samplingrate (xsrate=0 : do not change Y dimension samplingrate)
% - zsrate : new Z dimension samplingrate (xsrate=0 : do not change Z dimension samplingrate)
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
%

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_interpolate';
outheader.history(i).date=date;
outheader.history(i).index=[xsrate,ysrate,zsrate];

%tpx,tpy,tpz (original srate)
tpx=1:1:header.datasize(6);
tpy=1:1:header.datasize(5);
tpz=1:1:header.datasize(4);
tpx=((tpx-1)*header.xstep)+header.xstart;
tpy=((tpy-1)*header.ystep)+header.ystart;
tpz=((tpz-1)*header.zstep)+header.zstart;

%ntpx,ntpy,ntpz (new srate)
%ntpx
if xsrate==0;
else
    xstart=header.xstart;
    xend=((header.datasize(6)-1)*header.xstep)+header.xstart;
    xstep=1/xsrate;
    ntpx=xstart:xstep:xend;
end;
%ntpy
if ysrate==0;
else
    ystart=header.ystart;
    yend=((header.datasize(5)-1)*header.ystep)+header.ystart;
    ystep=1/ysrate;
    ntpy=ystart:ystep:yend;
end;
%ntpz
if zsrate==0;
else
    zstart=header.zstart;
    zend=((header.datasize(4)-1)*header.zstep)+header.zstart;
    zstep=1/zsrate;
    ntpz=zstart:zstep:zend;
end;

%interp3(tpx,tpy,tpz,data,ntpx,ntpy,ntpz)

%prepare outdata
if xsrate==0;
else
    outheader.datasize(6)=size(ntpx,2);
    outheader.xstep=xstep;
end;
if ysrate==0;
else
    outheader.datasize(5)=size(ntpy,2);
    outheader.ystep=ystep;
end;
if zsrate==0;
else
    outheader.datasize(4)=size(ntpz,2);
    outheader.zstep=zstep;
end;

outdata=zeros(outheader.datasize);

%loop through epochs
for epochpos=1:header.datasize(1);
    for chanpos=1:header.datasize(2);
        for indexpos=1:header.datasize(3);
            %interpolate X dimension if required
            if xsrate==0;
            else
                for dz=1:header.datasize(4);
                    for dy=1:header.datasize(5);
                        outdata(epochpos,chanpos,indexpos,dz,dy,:)=interp1(tpx,squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)),ntpx,method);
                    end;
                end;
            end;
            %interpolate Y dimension if required
            if ysrate==0;
            else
                for dz=1:header.datasize(4);
                    for dx=1:header.datasize(6);
                        outdata(epochpos,chanpos,indexpos,dz,:,dx)=interp1(tpy,squeeze(data(epochpos,chanpos,indexpos,dz,:,dx)),ntpy,method);
                    end;
                end;
            end;
            %interpolate Z dimension if required
            if zsrate==0;
            else
                for dy=1:header.datasize(5);
                    for dx=1:header.datasize(6);
                        outdata(epochpos,chanpos,indexpos,:,dy,dx)=interp1(tpz,squeeze(data(epochpos,chanpos,indexpos,:,dy,dx)),ntpz,method);
                    end;
                end;
            end;
        end;
    end;
end;

%set new datasize
outheader.datasize=size(outdata);
