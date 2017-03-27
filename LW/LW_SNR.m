function [outheader,outdata] = LW_SNR(header,data,dx1,dx2,operation,nextremes)
% LW_SNR
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - dx1 : begin of sliding baseline interval (bin)
% - dx2 : end of sliding baseline interval (bin)
% - operation : 'subtract','snr','percent'
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
outheader.history(i).description='LW_SNR';
outheader.history(i).date=date;
outheader.history(i).index=[dx1,dx2,operation];

outdata=zeros(size(data));

%initialize bl and stdbl variables (for zscore only)
bl = zeros(size(data,2),size(data,6));
if strcmpi(operation,'zscore')==1;
    stdbl = bl;
end

%loop through all the data (pooling across channels)
for epochpos=1:size(data,1);
    for indexpos=1:size(data,3);
        for dz=1:size(data,4);
            for dy=1:size(data,5);
                tp=squeeze(data(epochpos,:,indexpos,dz,dy,:));
                %transpose tp when there is a single electrode
                if size(tp,2)==1;
                    tp=tp';
                end
                dxsize=size(data,6);
                for dx=1:size(data,6);
                    dx31=dx-dx2;
                    dx32=dx-dx1;
                    dx41=dx+dx1;
                    dx42=dx+dx2;
                    if dx31<1;
                        dx31=1;
                    end;
                    if dx32<1;
                        dx32=1;
                    end;
                    if dx41>dxsize;
                        dx41=dxsize;
                    end;
                    if dx42>dxsize;
                        dx42=dxsize;
                    end;
                    tp2=tp(:,[dx31:dx32,dx41:dx42]);
                    if nextremes>0;
                        tp2=sort(tp2,2);
                        tp2=tp2(:,1+nextremes:end-nextremes);
                    end;
                    bl(:,dx)=mean(tp2,2); % mean over selected bins
                    % compute standard deviation over selected bins for
                    % zscore only (save computation time for other
                    % operations).
                    if strcmpi(operation,'zscore')==1;
                        stdbl(:,dx) = std(tp2,[],2);
                    end
                end;
                
                switch operation
                    case 'subtract'%subtraction
                        tp2=tp-bl;
                        % tp2=bsxfun(@minus,tp,bl);
                    case 'snr'
                        tp2=tp./bl;
                    case 'zscore'
                        tp2=(tp - bl) ./stdbl;
                    case 'percent'
                        tp2=tp-bl;
                        tp2=tp2./bl;
                end
                outdata(epochpos,:,indexpos,dz,dy,:)=tp2;
            end;
        end;
    end;
end;
end



