
function [outheader,data] = LW_butter(header, data, lowcut, highcut, filtOrder, type);

%LW_butter:
%Usage: [outheader,data] = LW_butter(header,data,lowcut,highcut,order,type);
%
%
% Author :
% Corentin Jacques
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
%

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description=['LW_butter_',type];
outheader.history(i).date=date;

%sampling rate and half sampling rate
Fs = 1/header.xstep;
fnyquist = Fs/2;
        
type = lower(type);
data = double(data);

%dividing filter order by 2 because of the forward-reverse filtering used
%(filtfilt).

%if ~mod(filtOrder,2);    
if mod(filtOrder,2);    
    warning('LW_butter: Even number for filter order is needed\n  -> converting order from %i to %i',filtOrder,filtOrder-1);
    filtOrder = filtOrder-1;
end
filtOrder = filtOrder/2;

%b,a
switch type
    case 'lowpass'
        [b,a]   = butter(filtOrder,highcut/fnyquist,'low');
    case 'highpass'
        [b,a]   = butter(filtOrder,lowcut/fnyquist, 'high');
    case 'bandpass'
        [bLow,aLow]   = butter(filtOrder,highcut/fnyquist,'low');
        [bHigh,aHigh]   = butter(filtOrder,lowcut/fnyquist, 'high');
        b = [bLow;bHigh];
        a = [aLow;aHigh];
    case 'notch'
        [b,a]   = butter(filtOrder,[lowcut/fnyquist highcut/fnyquist] , 'stop');
end;
              
%loop through all the data
for epochpos=1:size(data,1)
    for chanpos = 1:size(data,2)
        for indexpos=1:size(data,3)
            for dz=1:size(data,4)
                for dy=1:size(data,5)
                    switch type
                        case 'lowpass'
                            data(epochpos,chanpos,indexpos,dz,dy,:) =    filtfilt(b,a,squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)));
                            
                        case 'highpass'
                            data(epochpos,chanpos,indexpos,dz,dy,:) =    filtfilt(b,a,squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)));
                            
                        case 'bandpass'
                            data(epochpos,chanpos,indexpos,dz,dy,:) = filtfilt(b(1,:),a(1,:),squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)));
                            data(epochpos,chanpos,indexpos,dz,dy,:) = filtfilt(b(2,:),a(2,:),squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)));
                            
                        case 'notch'                            
                            data(epochpos,chanpos,indexpos,dz,dy,:) =  filtfilt(b,a,squeeze(data(epochpos,chanpos,indexpos,dz,dy,:)));
                    end
                end
            end
        end
    end
end
