function EEG = LW_LW52SET(header,data)
% LW_LW52SET
%
%EEG.setname
EEG.setname=header.name;
%EEG.trials
EEG.trials=header.datasize(1);
%EEG.pnts
EEG.pnts=header.datasize(6);
%EEG.nbchan
EEG.nbchan=header.datasize(2);
%EEG.srate
EEG.srate=1/header.xstep;
%EEG.xmin
EEG.xmin=header.xstart;
%EEG.xmax
EEG.xmax=header.xstart+(header.datasize(6)*header.xstep);
%EEG.times
EEG.times=linspace(EEG.xmin,EEG.xmax,EEG.pnts);
%EEG.ref
EEG.ref='common';
%EEG.history
EEG.history={};
%EEG.comments
EEG.comments={};
%EEG.data (chans,frames,epochs)
EEG.data(:,:,:)=squeeze(permute(data(:,:,1,1,1,:),[2 6 1 3 4 5]));
%EEG.data=permute(EEG.data,[2 3 1]);
%EEG.chanlocs
EEG.chanlocs=header.chanlocs;
%EEG.splinefile
if isfield(header,'splinefile_spl');
    EEG.splinefile=header.splinefile_spl;
end;
