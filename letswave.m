function letswave;
%letswave

%platform-specific configuration
%load configuration mat
load('letswave.mat');
if ispc==1;
    disp('This is a Windows PC.');
    %if strcmpi(config.GUI_pc.ChangeFont,'yes');
        %disp('Changing GUI style.');
        %set(0,'DefaultUIControlFontName',config.GUI_pc.FontName);
        %set(0,'DefaultUIControlFontSize',config.GUI_pc.FontSize);
    %end;
end;
if ismac==1;
    disp('This is a Mac.');
    %if strcmpi(config.GUI_mac.ChangeFont,'yes');
    %    disp('Changing GUI style.');
    %    set(0,'DefaultUIControlFontName',config.GUI_mac.FontName);
    %    set(0,'DefaultUIControlFontSize',config.GUI_mac.FontSize);
    %end;
end;
if and(isunix==1,ismac==0);
    disp('This is a Unix system.');
    %if strcmpi(config.GUI_unix.ChangeFont,'yes');
    %    disp('Changing GUI style.');
    %    set(0,'DefaultUIControlFontName',config.GUI_unix.FontName);
    %    set(0,'DefaultUIControlFontSize',config.GUI_unix.FontSize);
    %end;
end;

%letswave
letswave_gui;
end

