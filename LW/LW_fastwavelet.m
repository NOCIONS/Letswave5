function [outheader,outdata]=LW_fastwavelet(header,data,ystart,ystep,ysize,type,periods,stdev,mothersize,postprocess,baseline,baseline_start,baseline_end,output)

isOptim = 1;
isDebug = 0;
% On SESOSTRIS:
% no optim: 3 epoch, 3 channels: 38.4 s
% otptim 14/11:                          6,77 s    ratio: 5.7
% otptim 15/11:                          4.87 S    ratio: 7.89
% ML 2009a                       43.7 s  3.9 s     ratio: 11.2


% Debug mode: clip epochs and channels after 3
if isDebug
    nEpochs   = 10;
    nChannels = 2;
else
    nEpochs   = header.datasize(1);
    nChannels = header.datasize(2);
end
 

%calculate wavelet
[wav1 wav2]=LW_fastwavelet_mother(type,periods,stdev,mothersize);

%parameters
srate=1/header.xstep;
xsize=header.datasize(6);
xstep=header.xstep;
xstart=header.xstart;

hzi=ystart;
if isOptim
    data = single(data);
    
    outarray1 = zeros(ysize,xsize,'single');
    outarray2 = zeros(ysize,xsize,'single');
    outarray  = zeros(ysize,xsize,'single');
else
    outarray1 = zeros(ysize,xsize);
    outarray2 = zeros(ysize,xsize);
    outarray  = zeros(ysize,xsize);
end

% nEpochs = header.datasize(1);
% nChannels = header.datasize(2);
% nIndexes = header.datasize(3);
% OUTARRAY1 = zeros(ysize,xsize,nEpochs,nChannels);


%outheader
outheader=header;
outheader.datasize(5)=ysize;
if strcmpi(output,'average');
    outheader.datasize(1)=1;
end;
outheader.ystart=ystart;
outheader.ystep=ystep;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_fastwavelet';
outheader.history(i).date=date;
outheader.history(i).index=[];

if strcmpi(postprocess,'amplitude');
    outheader.filetype='frequency_time_amplitude';
elseif strcmpi(postprocess,'power');
    outheader.filetype='frequency_time_power';
elseif strcmpi(postprocess,'phase');
    outheader.filetype='frequency_time_phase';
elseif strcmpi(postprocess,'real');
    outheader.filetype='frequency_time_amplitude';
elseif strcmpi(postprocess,'imag');
    outheader.filetype='frequency_time_amplitude';
end;


%prepare outdata
if isOptim
    outdata=zeros(outheader.datasize,'single');
else
    outdata=zeros(outheader.datasize);
end

%prepare outdata for PLV
if strcmpi(output,'average');
    if strcmpi(postprocess,'phase'); %PLV
        tp=outheader.datasize;
        tp(1)=2;
        outdata=zeros(tp);
    end;
end;



z=1;
y=1;


TSPEC1 = cell(1,ysize);
TSPEC2 = cell(1,ysize);

if isOptim
    wav1 = single(wav1);
    wav2 = single(wav2);
    
    for dy=1:ysize;
        %compress wavelet
        specsize=round((srate*periods)/hzi);
        %     specsizediv2=floor(specsize/2);
        specinc=mothersize/specsize;
        tps=floor(0:specinc:(specinc*(specsize-1)))+1;
        tspec1 = wav1(tps)';
        tspec2 = wav2(tps)';
        
        wavScale = sqrt(hzi/periods);

        
% %         C. Jacques's edits
% %         From:
% %         TSPEC1{dy} = repmat(tspec1,1,xsize);
% %         TSPEC2{dy} = repmat(tspec2,1,xsize);
% %         [X,Y] = meshgrid(1:xsize,0:specsize-1);
% %         DX{dy} = uint16(X + Y);
% %         To:
        TSPEC1{dy} = tspec1 * wavScale;
        TSPEC2{dy} = tspec2 * wavScale;


        hzi=hzi+ystep;
    end
end





for epoch = 1 : nEpochs
    disp(['epoch : ' num2str(epoch)]);
    
    for channel = 1 : nChannels
        disp(['channel : ' num2str(channel)]);
        
        for index=1:header.datasize(3);
            hzi=ystart;
            
            for dy=1:ysize;
%                 C. Jacques's edits - commented the next few lines.
% %                 compress wavelet
% %                 specsize = round((srate*periods) / hzi);
% %                 specsizediv2 = floor(specsize/2);
% %                 
% %                 %res
% %                 res = vertcat(zeros(specsizediv2,1,'single'),...
% %                     squeeze(data(epoch,channel,index,z,y,:)),...
% %                     zeros(specsizediv2,1,'single'));
                
       
                if isOptim %<bj: optimized code: 4.7 msec>
% %                   C. Jacques's edits.
% %                 From:
% %                     R = res(DX{dy});
% %                     outarray1(dy,:) = mean(TSPEC1{dy} .* R)';
% %                     outarray2(dy,:) = mean(TSPEC2{dy} .* R)';
% %                 To: (using convolution is faster)
                    R = squeeze(data(epoch,channel,index,z,y,:))';
                    outarray1(dy,:) = conv2(R,TSPEC1{dy}', 'same');
                    outarray2(dy,:) = conv2(R,TSPEC2{dy}', 'same');
%                     
                else %<old code: 30.5 msec>
                    res = vertcat(zeros(specsizediv2,1),squeeze(data(epoch,channel,index,z,y,:)),zeros(specsizediv2,1));
                    
                    specinc=mothersize/specsize;
                    tps=floor(0:specinc:(specinc*(specsize-1)))+1;
                    tspec1=wav1(tps)';
                    tspec2=wav2(tps)';
                    
%                     tic
                    for dx=1:xsize;
                        %pseudo-convolution
                        %sigpos : start point on signal
                        outarray1(dy,dx)=mean(tspec1.*res(dx:dx+specsize-1)); %!!! 97% time for those 2 lines !
                        outarray2(dy,dx)=mean(tspec2.*res(dx:dx+specsize-1)); %!!! 97% time for those 2 lines !
                    end;
%                     toc
                end
                hzi=hzi+ystep;
             
            end;
            %postprocessing
            if strcmpi(postprocess,'amplitude');
                outarray=sqrt(outarray1.^2+outarray2.^2);
            elseif strcmpi(postprocess,'power');
                outarray=outarray1.^2+outarray2.^2;
            elseif strcmpi(postprocess,'phase');
                outarray=atan2(outarray2,outarray1);
            elseif strcmpi(postprocess,'real');
                outarray=outarray1;
            elseif strcmpi(postprocess,'imag');
                outarray=outarray2;
            end;
            %baseline correction
            if strcmpi(baseline,'subtract');
                bl1=round((baseline_start-xstart)/xstep)+1;
                bl2=round((baseline_end-xstart)/xstep)+1;
                outarray_mean=mean(outarray(:,bl1:bl2),2);
                for dy=1:ysize;
                    outarray(dy,:)=outarray(dy,:)-outarray_mean(dy);
                end;
            elseif strcmpi(baseline,'percent');
                bl1=round((baseline_start-xstart)/xstep)+1;
                bl2=round((baseline_end-xstart)/xstep)+1;
                outarray_mean=mean(outarray(:,bl1:bl2),2);
                for dy=1:ysize;
                    outarray(dy,:)=(outarray(dy,:)-outarray_mean(dy))/outarray_mean(dy);
                end;
            end;
                
            if strcmpi(output,'average');
                if strcmpi(postprocess,'phase'); %PLV
                    outdata(1,channel,index,z,:,:)=squeeze(outdata(1,channel,index,z,:,:))+sin(outarray);
                    outdata(2,channel,index,z,:,:)=squeeze(outdata(2,channel,index,z,:,:))+cos(outarray);
                else
                    outdata(1,channel,index,z,:,:)=squeeze(outdata(1,channel,index,z,:,:))+outarray;
                end;
            else
                outdata(epoch,channel,index,z,:,:)=outarray;
            end;
        end;
    end;
end;

if strcmpi(output,'average');
    outdata=outdata/header.datasize(1);
    if strcmpi(postprocess,'phase'); %PLV
        tp=outdata.^2;
        outdata=zeros(outheader.datasize);
        outdata(1,:,:,:,:,:)=sqrt(squeeze(tp(1,:,:,:,:,:))+squeeze(tp(2,:,:,:,:,:)));
    end;
end;




% workspaceexport; %<bj>