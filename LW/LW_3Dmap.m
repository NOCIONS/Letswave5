function mat=LW_3Dmap(header,data,epochpos,chanpos,indexpos,z,xstart,xend,xsize,ystart,yend,ysize)
% LW_3Dmap
% - header
% - data
% - epochpos
% - chanpos
% - indexpos
% - z

%dz
dz=((z-header.zstart)/header.zstep)+1;
%fetch matrix to display
mat=squeeze(data(epochpos,chanpos,indexpos,dz,:,:));
%tpx
tpx=1:1:header.datasize(6);
tpx=((tpx-1)*header.xstep)+header.xstart;
%tpy
tpy=1:1:header.datasize(5);
tpy=((tpy-1)*header.ystep)+header.ystart;
%xi,yi
xi=linspace(xstart,xend,xsize);
yi=linspace(ystart,yend,ysize);
%interp
mat=interp2(tpx',tpy,mat,xi',yi);
%figure
figure;
mesh(xi',yi,mat);












end

