function [outheader,outdata] = LW_butterfilter(header,data,locutoff,hicutoff,filterorder)
%LW_butterfilter
%Apply a butterworth filter
%locutoff and hicutoff in Hz
%locutoff=0 = low-pass filter
%hicutoff=0 = no low-pass filter = pure high-pass filter
%filterorder: length of filer in points (default is 3*fix(srate/cutoff),
%set filterorder=0 for detault
%uses the butter1 and filterfilter functions (signal processing toolbux

%transfer header to outheader
outheader=header;

%add history
i=size(outheader.history,2)+1;
outheader.history(i).description='LW_butterfilter';
outheader.history(i).date=date;
outheader.history(i).index=[locutoff,hicutoff,filterorder];

%samplingrate
srate=fix(1/header.xstep);

%fnyquist
fnyquist=0.5*srate;

%low pass filter
if hicutoff>0;
    %build filter
    if filterorder==0;
        fo=3*fix(srate/hicutoff);
    else
        fo=filterorder;
    end;
    [b_low,a_low] = butter(fo,(hicutoff/fnyquist),'low');
end;

%high pass filter
if locutoff>0
    %build filter
    if filterorder==0;
        fo=3*fix(srate/locutoff);
    else
        fo=filterorder;
    end;
    [b_high,a_high] = butter(fo,(locutoff/fnyquist),'high');
end;

%loop through all the data
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    %low pass filter
                    if hicutoff>0
                        data(epochpos,channelpos,indexpos,dz,dy,:)=filtfilt(b_low,a_low,squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)));
                    end;
                    %high pass filter
                    if locutoff>0
                        data(epochpos,channelpos,indexpos,dz,dy,:)=filtfilt(b_high,a_high,squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)));
                    end;
                end;
            end;
        end;
    end;
end;


%output
outdata=data;
