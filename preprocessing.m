
%% Basic pre-processing steps for resting state funtcional connectivitiy analysis of BIOSEMI EEG data
%% globals
epochLength = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data, triggers and define trials
filename = '' % set the filename without extension (to enable automatic saving afterwards)
cfg = [];
cfg.dataset = strcat(filename,'.bdf');
cfg.trialdef.eventtype = 'STATUS';
cfg.trialdef.eventvalue = [102 103]; % define eyes open (100 101), eyes closed (102 103), but check manually
cfg.trialdef.prestim = -5; %don't take the whole one minute
cfg.trialdef.poststim = 55;
cfg = ft_definetrial(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% preprocessing settings
cfg.channel = [1:64] % don't think I need to exclude this here, but do it anyway
cfg.continuous = 'yes';
cfg.demean    = 'yes';
cfg.detrend = 'yes';
cfg.lpfreq = 60;
cfg.reref = 'EXG6'; %rereference to mastoid reference
cfg.bsfilter = 'yes' % use the bs filter
cfg.bsfilter = '48 52' % filter out potential line noise
cleandata = ft_preprocessing(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OPTIONAL: resample
cfg_res = [];
cfg_res.resamplefs = 1024;
cleandata = ft_resampledata(cfg_res, cleandata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OPTIONAL visual inspection (easier to see before reslicing trials)
cfg_vis = [];
cfg_vis.method = 'channel';
%cfg_vis.alim = 5e-5;
dummy = ft_rejectvisual(cfg_vis,cleandata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
%% OPTIONAL: channel repair if on visual inspection any bad channels are obvious
% try to avoid as much as possible since channel repairs effect ICA efficacy
% Get nearest neighbours
cfg_rep                  = [];
cfg_rep.method           = 'template'
cfg_rep.layout           = 'biosemi64.lay';
[neighbours]             = ft_prepare_neighbours(cfg_rep,cleandata)
% Interpolate and put into new data structure
cfg_int                      = [];
cfg_int.badchannel           = {'Lz'};
cfg_int.layout               = 'biosemi64.lay';
cfg_int.method               = 'nearest';
cfg_int.neighbours           = neighbours;
cfg_int.neighbourdist        = 0.13; %not too sure about this?
artifact_cleandata           = ft_channelrepair(cfg_int,cleandata)
% or, if no channels are to be repaired
artifact_cleandata           = cleandata;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% redefine segments
cfg_cut = [];
cfg_cut.length = epochLength;
cfg_cut.overlap = 0;
artifact_cleandata = rmfield(artifact_cleandata,'trialinfo'); % clear the original trialinfo to be able to redefine
epocheddata = ft_redefinetrial(cfg_cut, artifact_cleandata); % cut it into little pieces

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPTIONAL visual inspection of trials
cfg_vis = [];
cfg_vis.method = 'trial';
%cfg_vis.alim = 5e-5;
dummy = ft_rejectvisual(cfg_vis,epocheddata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ICA denoising settings
cfg_ica = [];
cfg_ica.method  = 'runica';
cfg_ica.channel = 1:64; %EEG channels only, 64 minus the number of repaired channels (e.g. the fixed channel can not be independent)
datacomp = ft_componentanalysis(cfg_ica, epocheddata);

%%  plot components
cfg_icapl = [];
cfg_icapl.channel = [1:15]; %components to be plotted
cfg_icapl.viewmode = 'component';
cfg_icapl.layout = 'biosemi64.lay';
cfg_icapl.continuous = 'yes';
cfg_icapl.blocksize = 30;
ft_databrowser(cfg_icapl, datacomp);

%% apply ica
%components = inputdlg('Enter components to be removed:','Components');
%components = str2num(cell2mat(components));
%cfg_ica.component = [component]
cfg_ica.component = [31, 44, 46, 53, 58, 59, 60, 62]; %exact numbers will vary per individual
data_iccleaned = ft_rejectcomponent(cfg_ica, datacomp, epocheddata); %clean and backpropagate clean data to 64-channels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPTIONAL visual inspection of trials
cfg_vis = [];
cfg_vis.method = 'trial';
%cfg_vis.alim = 5e-5;
dummy = ft_rejectvisual(cfg_vis,data_iccleaned);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% reset the time-axis for the segmented epochs to avoid issues later on
stepSize = 1/1024;
timeVector = 0:stepSize:(epochLength-stepSize);
for i = 1:size(data_iccleaned.time,2)
   data_iccleaned.time{:,i} = timeVector; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do some clean-up
savename = strcat('pp_',filename,'.mat');
save(savename, 'data_iccleaned');
clearvars -except epochLength
clc
