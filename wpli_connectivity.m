%% standard functions to load preprocessed fieldtrip mat-files and create WPLI matrices
function [] = rb_EEG_Connectivity (directory)

cd(directory);
subs = ls('*.mat');
nsubs = size(subs,1);

for i = 1:nsubs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% LOAD THE DATA
    [path, filename, extension] = fileparts(subs(i,:));
    load(subs(i,:));
    
    %% Set up frequency split using wavelet
    cfg_freq = [];
    cfg_freq.method = 'wavelet';
    cfg_freq.output = 'powandcsd';
    cfg_freq.channel = 1:64;
    cfg_freq.keeptrials ='yes'; %do not return an average of all trials for subsequent wpli analysis
    cfg_freq.toi = [0.5:0.05:3.5];
    %delta
    cfg_freq.foi = [2:0.02:4];
    cfg_freq.width = 3; %small width for low frequency
    [freq_data.delta] = ft_freqanalysis(cfg_freq, data_iccleaned);
    %theta
    cfg_freq.foi = [4:0.02:7];
    cfg_freq.width = 3; %small width for low frequency
    [freq_data.theta] = ft_freqanalysis(cfg_freq, data_iccleaned);
    %alpha
    cfg_freq.width = 7;
    cfg_freq.foi = [7:0.02:13];
    [freq_data.alpha] = ft_freqanalysis(cfg_freq, data_iccleaned);
    %beta
    cfg_freq.width = 7;
    cfg_freq.foi = [13:0.02:30];
    [freq_data.beta] = ft_freqanalysis(cfg_freq, data_iccleaned);
    %gamma
    cfg_freq.width = 7;
    cfg_freq.foi = [30:0.02:60];
    [freq_data.gamma] = ft_freqanalysis(cfg_freq, data_iccleaned);
    %all
    cfg_freq.width = 7;
    cfg_freq.foi = [2:0.05:60]; %slightly bigger step size for complete range
    [freq_data.all] = ft_freqanalysis(cfg_freq, data_iccleaned);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% TO-DO: figure out how to transpose back to 2D matrix from fieldtrip standard vectors.
    %% connectivity analysis
    cfg_conn = [];
    cfg_conn.method = 'wpli';
    conn.delta = ft_connectivityanalysis(cfg_conn, freq_data.delta);
    conn.theta = ft_connectivityanalysis(cfg_conn, freq_data.theta);
    conn.alpha = ft_connectivityanalysis(cfg_conn, freq_data.alpha);
    conn.beta = ft_connectivityanalysis(cfg_conn, freq_data.beta);
    conn.gamma = ft_connectivityanalysis(cfg_conn, freq_data.gamma);
    conn.all = ft_connectivityanalysis(cfg_conn, freq_data.all);
    
    %% Do some clean-up and save
    savename = strcat(filename,'_conn');
    save(savename, 'conn');
    clearvars -except subs nsubs directory;
    
end
end
