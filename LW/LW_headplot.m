function h=LW_headplot(header,data,epoch,index,x,y,z,varargin)
%LW_headplot
%h=LW_headplot(header,data,epoch,index,x,y,z,varargin)



%fetch data to display
vector=squeeze(data(epoch,:,index,z,y,x));
%parse data and chanlocs according to topo_enabled
k=1;
for chanpos=1:size(header.chanlocs,2);
    if header.chanlocs(chanpos).topo_enabled==1
        vector2(k)=vector(chanpos);
        chanlocs2(k)=header.chanlocs(chanpos);
        k=k+1;
    end;
end;

%headplot
%h=topoplot(vector2,chanlocs2,varargin{:});
%headplot(values,'spline_file','Param','Value',...)
if isfield(header,'filename_spl');
    if exist(header.filename_spl)==0;
        disp('SPL file not found. Run the Build spline file function to display headplots');
    else
        h=headplot(vector2,header.filename_spl,varargin{:});
    end;
else
    disp('SPL file not found. Run the Build spline file function to display headplots');    
end;



