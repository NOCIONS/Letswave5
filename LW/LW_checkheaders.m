function [SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
% LW_checkheaders
% Check the selection of datafiles
%
% Inputs
% - inputfiles : list of LW5 input files
%
% Outputs
% - SameX=1 : same X Dimensions across input files
% - SameY=1 : same Y Dimensions across input files
% - SameZ=1 : same Y Dimensions across input files
% - SameEpochs=1 : same Y Dimensions across input files
% - SameChannels=1 : same Y Dimensions across input files
% - SameIndex=1 : same Y Dimensions across input files
%
% Dependencies : none
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

%load inputfiles
for filepos=1:size(inputfiles,2);
    load(inputfiles{filepos},'-MAT');
    input(filepos).header=header;
end;
%set default values
SameX=1;
SameY=1;
SameZ=1;
SameEpochs=1;
SameChannels=1;
SameIndex=1;
%check
if size(inputfiles,2)>1
    xstart=input(1).header.xstart;
    xstep=input(1).header.xstep;
    xsize=input(1).header.datasize(6);
    ystart=input(1).header.ystart;
    ystep=input(1).header.ystep;
    ysize=input(1).header.datasize(5);
    zstart=input(1).header.zstart;
    zstep=input(1).header.zstep;
    zsize=input(1).header.datasize(4);
    numindex=input(1).header.datasize(3);
    numchannels=input(1).header.datasize(2);
    numepochs=input(1).header.datasize(1);
    for filepos=2:size(inputfiles,2);
        xstart2=input(filepos).header.xstart;
        xstep2=input(filepos).header.xstep;
        xsize2=input(filepos).header.datasize(6);
        ystart2=input(filepos).header.ystart;
        ystep2=input(filepos).header.ystep;
        ysize2=input(filepos).header.datasize(5);
        zstart2=input(filepos).header.zstart;
        zstep2=input(filepos).header.zstep;
        zsize2=input(filepos).header.datasize(4);
        numindex2=input(filepos).header.datasize(3);
        numchannels2=input(filepos).header.datasize(2);
        numepochs2=input(filepos).header.datasize(1);
        %X
        if xstart2==xstart;
        else
            SameX=0;
        end;
        if xstep2==xstep;
        else
            SameX=0;
        end;
        if xsize2==xsize;
        else
            SameX=0;
        end;
        %Y
        if ystart2==ystart;
        else
            SameY=0;
        end;
        if ystep2==ystep;
        else
            SameY=0;
        end;
        if ysize2==ysize;
        else
            SameY=0;
        end;
        %Z
        if zstart2==zstart;
        else
            SameZ=0;
        end;
        if zstep2==zstep;
        else
            SameZ=0;
        end;
        if zsize2==zsize;
        else
            SameZ=0;
        end;
        %Epochs
        if numepochs2==numepochs
        else
            SameEpochs=0;
        end;
        %Channels
        if numchannels2==numchannels
        else
            SameChannels=0;
        end;
        %Index
        if numindex2==numindex
        else
            SameIndex=0;
        end;
    end;
end;

end

