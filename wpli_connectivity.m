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
    
    if Example_figure == 1
        figure;
        
        cfg = [];
        cfg.layout = 'biosemi64.lay';
        %cfg.xlim   = [9 11];
        subplot(2,3,1); ft_topoplotER(cfg, freq_data.delta);
        title('delta')
        subplot(2,3,2); ft_topoplotER(cfg, freq_data.theta);
        title('theta')
        subplot(2,3,3); ft_topoplotER(cfg, freq_data.alpha);
        title('alpha')
        subplot(2,3,4); ft_topoplotER(cfg, freq_data.beta);
        title('beta')
        subplot(2,3,5); ft_topoplotER(cfg, freq_data.gamma);
        title('gamma')
        subplot(2,3,6); ft_topoplotER(cfg, freq_data.all);
        title('all')        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% connectivity analysis
    %% this is not the most elegant way, but it seems to work... Once we have the subject*freq matrices, just use the BCT
    cfg_conn = [];
    cfg_conn.method = 'wpli';
    conn.delta = ft_connectivityanalysis(cfg_conn, freq_data.delta);
         conn.delta.dimord = 'chan_freq_time';
         conn.delta = ft_checkdata(conn.delta, 'cmbrepresentation', 'full','datatype','freq');
            %cfg.method = 'degrees';
            %stat = ft_networkanalysis(cfg, conn.delta);
         conn.delta.wplispctrm = squeeze(mean(conn.delta.wplispctrm,4));
         conn.delta.dimord = 'chan_chan_freq'; 
         network_delta(i,:,:) = squeeze(mean(conn.delta.wplispctrm,3));
         
    conn.theta = ft_connectivityanalysis(cfg_conn, freq_data.theta);
         conn.theta.dimord = 'chan_freq_time';
         conn.theta = ft_checkdata(conn.theta, 'cmbrepresentation', 'full','datatype','freq');
            %cfg.method = 'degrees';
            %stat = ft_networkanalysis(cfg, conn.theta);
         conn.theta.wplispctrm = squeeze(mean(conn.theta.wplispctrm,4));
         conn.theta.dimord = 'chan_chan_freq'; 
         network_theta(i,:,:) = squeeze(mean(conn.theta.wplispctrm,3));
         
    conn.alpha = ft_connectivityanalysis(cfg_conn, freq_data.alpha);
         conn.alpha.dimord = 'chan_freq_time';
         conn.alpha = ft_checkdata(conn.alpha, 'cmbrepresentation', 'full','datatype','freq');
            %cfg.method = 'degrees';
            %stat = ft_networkanalysis(cfg, conn.alpha);
         conn.alpha.wplispctrm = squeeze(mean(conn.alpha.wplispctrm,4));
         conn.alpha.dimord = 'chan_chan_freq'; 
         network_alpha(i,:,:) = squeeze(mean(conn.alpha.wplispctrm,3));
         
    conn.beta = ft_connectivityanalysis(cfg_conn, freq_data.beta);
         conn.beta.dimord = 'chan_freq_time';
         conn.beta = ft_checkdata(conn.beta, 'cmbrepresentation', 'full','datatype','freq');
            %cfg.method = 'degrees';
            %stat = ft_networkanalysis(cfg, conn.beta);
         conn.beta.wplispctrm = squeeze(mean(conn.beta.wplispctrm,4));
         conn.beta.dimord = 'chan_chan_freq'; 
         network_beta(i,:,:) = squeeze(mean(conn.beta.wplispctrm,3));
         
    conn.gamma = ft_connectivityanalysis(cfg_conn, freq_data.gamma);
         conn.gamma.dimord = 'chan_freq_time';
         conn.gamma = ft_checkdata(conn.gamma, 'cmbrepresentation', 'full','datatype','freq');
            %cfg.method = 'degrees';
            %stat = ft_networkanalysis(cfg, conn.gamma);
         conn.gamma.wplispctrm = squeeze(mean(conn.gamma.wplispctrm,4));
         conn.gamma.dimord = 'chan_chan_freq'; 
         network_gamma(i,:,:) = squeeze(mean(conn.gamma.wplispctrm,3));
         
    conn.all = ft_connectivityanalysis(cfg_conn, freq_data.all);
         conn.all.dimord = 'chan_freq_time';
         conn.all = ft_checkdata(conn.all, 'cmbrepresentation', 'full','datatype','freq');
            %cfg.method = 'degrees';
            %stat = ft_networkanalysis(cfg, conn.all);
         conn.all.wplispctrm = squeeze(mean(conn.all.wplispctrm,4));
         conn.all.dimord = 'chan_chan_freq'; 
         network_all(i,:,:) = squeeze(mean(conn.all.wplispctrm,3));    
    
    %% Do some clean-up and save
    savename = strcat(filename,'_conn');
    save(savename, 'conn');
    clearvars -except subs nsubs directory network_delta network_theta network_alpha network_beta network_gamma network_all;
    
end
end

