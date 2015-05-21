clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data and triggers
cfg = [];
cfg.dataset = 'Sub0001.bdf';
%cfg.trialfun = ft_trialfun_general;
cfg.trialdef.eventtype = 'STATUS';
cfg.trialdef.eventvalue = 103; % define eyes open (101), eyes closed (103)
cfg.trialdef.prestim = -5; %don't take the whole one minute
cfg.trialdef.poststim = 55;
cfg.viewmode = 'vertical';
cfg.ylim ='maxmin';
cfg = ft_definetrial(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% preprocessing settings
cfg.channel = [1:64];
cfg.continuous = 'yes';
cfg.demean    = 'yes';
cfg.detrend = 'yes';
cfg.lpfreq = 60;
cfg.reref = 'yes';
cfg.refchannel = 'all';
cfg.bsfilter = 'yes';
cfg.bsfreq = [49 51]; %filter out 50Hz
cleandata = ft_preprocessing(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OPTIONAL visual inspection (easier to see before reslicing trials)
cfg_vis = [];
cfg_vis.method = 'channel';
%cfg_vis.alim = 5e-5;
dummy = ft_rejectvisual(cfg_vis,cleandata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%.
%% OPTIONAL: channel repair if on visual inspection any bad channels are obvious
% Get nearest neighbours
cfg_rep                  = [];
cfg_rep.method           = 'template'
cfg_rep.layout           = 'biosemi64.lay';
[neighbours]             = ft_prepare_neighbours(cfg_rep,cleandata)
% %% Interpolate and put into new data structure
cfg_int                      = [];
cfg_int.badchannel           = 'PO8';
cfg_int.layout               = 'biosemi64.lay';
cfg_int.method               = 'nearest';
cfg_int.neighbours           = neighbours;
cfg_int.neighbourdist        = 0.13; %not too sure about this?
artifact_cleandata           = ft_channelrepair(cfg_int,cleandata)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% redefine segments
cfg_cut = [];
%cfg_cut.trials = [1 2];
cfg_cut.length = 4;
cfg_cut.overlap = 0;
% clear the original trialinfo
artifact_cleandata = rmfield(artifact_cleandata,'trialinfo');
% cut it into little pieces
epocheddata = ft_redefinetrial(cfg_cut, artifact_cleandata);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ICA denoising settings
cfg_ica = [];
cfg_ica.method  = 'runica';
cfg_ica.channel = 1:64; %EEG channels only
datacomp = ft_componentanalysis(cfg_ica, epocheddata);

%%  plot components
cfg_icapl.channel = [1:15]; %components to be plotted
cfg_icapl.viewmode = 'component';
cfg_icapl.layout = 'biosemi64.lay';
cfg_icapl.continuous = 'yes';
cfg_icapl.blocksize = 30;
ft_databrowser(cfg_icapl, datacomp)

%% apply ica
%components = inputdlg('Enter components to be removed:','Components');
%components = str2num(cell2mat(components));
%cfg_ica.component = [component]
cfg_ica.component = [35 64]; %exact numbers will vary per individual
data_iccleaned = ft_rejectcomponent(cfg_ica, datacomp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do some clean-up
clearvars -except data_iccleaned

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% frequency split
cfg_freq = [];
cfg_freq.method = 'wavelet';
cfg_freq.output = 'powandcsd';
cfg_freq.channel = 1:64;
cfg_freq.keeptrials ='yes'; %do not return an average of all trials for subsequent wpli analysis
cfg_freq.toi = [0:0.05:4];
cfg_freq.foi = [0.5:0.02:4];
[freq_data.delta] = ft_freqanalysis(cfg_freq, data_iccleaned);
cfg_freq.foi = [4:0.02:7];
[freq_data.theta] = ft_freqanalysis(cfg_freq, data_iccleaned);
cfg_freq.foi = [7:0.02:13];
[freq_data.alpha] = ft_freqanalysis(cfg_freq, data_iccleaned);
cfg_freq.foi = [13:0.02:30];
[freq_data.beta] = ft_freqanalysis(cfg_freq, data_iccleaned);
cfg_freq.foi = [30:0.02:60];
[freq_data.gamma] = ft_freqanalysis(cfg_freq, data_iccleaned);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% connectivity analysis
cfg_conn = [];
cfg_conn.method = 'wpli';
stat.delta = ft_connectivityanalysis(cfg_conn, freq_data.delta); 
stat.theta = ft_connectivityanalysis(cfg_conn, freq_data.theta); 
stat.alpha = ft_connectivityanalysis(cfg_conn, freq_data.alpha); 
stat.beta = ft_connectivityanalysis(cfg_conn, freq_data.beta); 
stat.gamma = ft_connectivityanalysis(cfg_conn, freq_data.gamma); 
