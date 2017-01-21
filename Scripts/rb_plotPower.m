function [] = rb_plotPower(in, maskTotal, maskGroup,cfgStruct)
% function to visualize power spectral density from channel*channel matrix
% INPUTS:
% in            -   matrix that contains sub*chan*freq powerspectra
% maskTotal     -   logical to indicate which subjects to use
% maskGroup     -   logical to indicate which subjects from which group to use
% cfgStructure  -   fieldtrip cfg structure that is the same as the
%                   original output from the time frequency analyis. This
%                   is needed because the channel and frequency information
%                   are tied to the specific frequency band
% OUTPUT:
% return a topoplot figure if power spectral density across the scalp

    cfg = []
    cfg.layout = 'biosemi64.lay';
    layout = ft_prepare_layout(cfg);
    data = squeeze(median(in((maskTotal & maskGroup),:,:),1));
    
    cfgStruct.dimord = 'chan_freq';
    cfgStruct.powspctrm = data;
    
    figure;ft_topoplotER(cfg,cfgStruct);colorbar;
    


end