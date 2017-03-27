function [outheader,outdata]=LW_fastwavelet(header,data,ystart,ystep,ysize,type,periods,stdev,mothersize,postprocess,baseline,baseline_start,baseline_end,output)

%calculate wavelet
[wav1 wav2]=LW_fastwavelet_mother(type,periods,stdev,mothersize);

%parameters
srate=1/header.xstep;
xsize=header.datasize(6);
xstep=header.xstep;
xstart=header.xstart;

hzi=ystart;
outarray1=zeros(ysize,xsize);
outarray2=zeros(ysize,xsize);
outarray=zeros(ysize,xsize);

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
end;
if strcmpi(postprocess,'power');
    outheader.filetype='frequency_time_power';
end;
if strcmpi(postprocess,'phase');
    outheader.filetype='frequency_time_phase';
end;
if strcmpi(postprocess,'real');
    outheader.filetype='frequency_time_amplitude';
end;
if strcmpi(postprocess,'imag');
    outheader.filetype='frequency_time_amplitude';
end;


%prepare outdata
outdata=zeros(outheader.datasize);

z=1;
y=1;

for epoch=1:header.datasize(1);
    disp(['epoch : ' num2str(epoch)]);
    for channel=1:header.datasize(2);
        disp(['channel : ' num2str(channel)]);
        for index=1:header.datasize(3);
            hzi=ystart;
            for dy=1:ysize;
                %compress wavelet
                specsize=round((srate*periods)/hzi);
                specsizediv2=floor(specsize/2);
                specinc=mothersize/specsize;
                tps=floor(0:specinc:(specinc*(specsize-1)))+1;
                tspec1=wav1(tps)';
                tspec2=wav2(tps)';
                %res
                res=vertcat(zeros(specsizediv2,1),squeeze(data(epoch,channel,index,z,y,:)),zeros(specsizediv2,1));
                for dx=1:xsize;
                    %pseudo-convolution
                    %sigpos : start point on signal
                    outarray1(dy,dx)=mean(tspec1.*res(dx:dx+specsize-1));
                    outarray2(dy,dx)=mean(tspec2.*res(dx:dx+specsize-1));
                end;
                hzi=hzi+ystep;
            end;
            %postprocessing
            if strcmpi(postprocess,'amplitude');
                outarray=sqrt(outarray1.^2+outarray2.^2);
            end;
            if strcmpi(postprocess,'power');
                outarray=outarray1.^2+outarray2.^2;
            end;
            if strcmpi(postprocess,'phase');
                outarray=atan2(outarray2,outarray1);
            end;
            if strcmpi(postprocess,'real');
                outarray=outarray1;
            end;
            if strcmpi(postprocess,'imag');
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
            end;
            if strcmpi(baseline,'percent');
                bl1=round((baseline_start-xstart)/xstep)+1;
                bl2=round((baseline_end-xstart)/xstep)+1;
                outarray_mean=mean(outarray(:,bl1:bl2),2);
                for dy=1:ysize;
                    outarray(dy,:)=(outarray(dy,:)-outarray_mean(dy))/outarray_mean(dy);
                end;
            end;
                
            if strcmpi(output,'average');
                outdata(1,channel,index,z,:,:)=squeeze(outdata(1,channel,index,z,:,:))+outarray;
            else
                outdata(epoch,channel,index,z,:,:)=outarray;
            end;
        end;
    end;
end;

if strcmpi(output,'average');
    outdata=outdata/header.datasize(1);
end;