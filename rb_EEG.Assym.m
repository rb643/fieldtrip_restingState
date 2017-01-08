function [] = rb_EEG_Assym(directory)

cd(directory);
subs = ls('*.mat');
nsubs = size(subs,1);

if exist('subids.mat','file')==2
    disp('Output folder exists');
    load('subids.mat')
else
    disp('Creating subject IDs file');
    subids = subs;
    save('subids.mat','subs');
end

donedir = fullfile(directory,'done')
if exist(donedir,'dir')
    disp('Output folder exists');
else
    disp('Creating output folder');
    mkdir(donedir);
end

h = waitbar(0,'Running Asymmetry Analysis');
for i = 1:nsubs

     waitbar(i/nsubs);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% LOAD THE DATA
    [path, filename, extension] = fileparts(subs(i,:));
    load(strcat(fullfile(directory,subs(i,:))));
    
    disp(strcat('Working on file ', filename));
    
    % get the powerspectra
    deltaPow = squeeze(mean(mean(freq_data.delta.powspctrm,3),1));
    thetaPow = squeeze(mean(mean(freq_data.theta.powspctrm,3),1));
    alphaPow = squeeze(mean(mean(freq_data.alpha.powspctrm,3),1));
    betaPow = squeeze(mean(mean(freq_data.beta.powspctrm,3),1));
    gammaPow = squeeze(mean(mean(freq_data.gamma.powspctrm,3),1));
    allPow = squeeze(mean(mean(freq_data.all.powspctrm,3),1));
    
    % compute frontal assymetry
    % left(Fc1>11,Fc3>10, Fc5>9, F1>4, F3>5, F5>6, F7>7, AF3>3, AF7>2, Fp1>1)
    leftE = [1 2 3 4 5 6 7 9 10 11];
    % right(Fc2>46, Fc4>45, Fc6>44, F2>39, F4>40, F6>41, F8>42, AF4>36, AF8>35, Fp2>34
    rightE = [34 35 36 39 40 41 42 44 45 46];
    
    Result.delta.Frontal(i) = (mean(deltaPow(rightE))-mean(deltaPow(leftE)))/(mean(deltaPow(rightE))+mean(deltaPow(leftE)));
    Result.theta.Frontal(i) = (mean(thetaPow(rightE))-mean(thetaPow(leftE)))/(mean(thetaPow(rightE))+mean(thetaPow(leftE)));
    Result.alpha.Frontal(i) = (mean(alphaPow(rightE))-mean(alphaPow(leftE)))/(mean(alphaPow(rightE))+mean(alphaPow(leftE)));
    Result.beta.Frontal(i) = (mean(betaPow(rightE))-mean(betaPow(leftE)))/(mean(betaPow(rightE))+mean(betaPow(leftE)));
    Result.gamma.Frontal(i) = (mean(gammaPow(rightE))-mean(gammaPow(leftE)))/(mean(gammaPow(rightE))+mean(gammaPow(leftE)));
    Result.all.Frontal(i) = (mean(allPow(rightE))-mean(allPow(leftE)))/(mean(allPow(rightE))+mean(allPow(leftE)));
    
    % compute left anterior-posterior balance
    % Fp1, AF3, AF7, F1, F3, F5, F7, Fp2. AF4, AF8, F2, F4, F6, F8
    postEl = [1 2 3 4 5 6 7 ];
    % O1, PO3, PO7, P1, P3, P5, P7, P9, O2, PO4, PO8, P2, P4, P6, P8, P10
    antEl = [20:27];
    
    Result.delta.IntraLeft(i) = (mean(deltaPow(postEl))-mean(deltaPow(antEl)))/(mean(deltaPow(postEl))+mean(deltaPow(antEl)));
    Result.theta.IntraLeft(i) = (mean(thetaPow(postEl))-mean(thetaPow(antEl)))/(mean(thetaPow(postEl))+mean(thetaPow(antEl)));
    Result.alpha.IntraLeft(i) = (mean(alphaPow(postEl))-mean(alphaPow(antEl)))/(mean(alphaPow(postEl))+mean(alphaPow(antEl)));
    Result.beta.IntraLeft(i) = (mean(betaPow(postEl))-mean(betaPow(antEl)))/(mean(betaPow(postEl))+mean(betaPow(antEl)));
    Result.gamma.IntraLeft(i) = (mean(gammaPow(postEl))-mean(gammaPow(antEl)))/(mean(gammaPow(postEl))+mean(gammaPow(antEl)));
    Result.all.IntraLeft(i) = (mean(allPow(postEl))-mean(allPow(antEl)))/(mean(allPow(postEl))+mean(allPow(antEl)));
    
        % compute right anterior-posterior balance
    % Fp1, AF3, AF7, F1, F3, F5, F7, Fp2. AF4, AF8, F2, F4, F6, F8
    postEr = [34 35 36 39 40 41 42];
    % O1, PO3, PO7, P1, P3, P5, P7, P9, O2, PO4, PO8, P2, P4, P6, P8, P10
    antEr = [57:64];
    
    Result.delta.IntraRight(i) = (mean(deltaPow(postEr))-mean(deltaPow(antEr)))/(mean(deltaPow(postEr))+mean(deltaPow(antEr)));
    Result.theta.IntraRight(i) = (mean(thetaPow(postEr))-mean(thetaPow(antEr)))/(mean(thetaPow(postEr))+mean(thetaPow(antEr)));
    Result.alpha.IntraRight(i) = (mean(alphaPow(postEr))-mean(alphaPow(antEr)))/(mean(alphaPow(postEr))+mean(alphaPow(antEr)));
    Result.beta.IntraRight(i) = (mean(betaPow(postEr))-mean(betaPow(antEr)))/(mean(betaPow(postEr))+mean(betaPow(antEr)));
    Result.gamma.IntraRight(i) = (mean(gammaPow(postEr))-mean(gammaPow(antEr)))/(mean(gammaPow(postEr))+mean(gammaPow(antEr)));
    Result.all.IntraRight(i) = (mean(allPow(postEr))-mean(allPow(antEr)))/(mean(allPow(postEr))+mean(allPow(antEr)));
end

close(h)

save(fullfile(donedir,'Results.mat'), 'Result');

end
