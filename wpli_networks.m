% function to compute various BCT/graph metric on a set of adjacency matrices

function [Results] = rb_EEG_Network(matrices, subids, path2save, mask, costlimit, nRand, prefix, TAKEABS)
% matrices          -       3D matrix of subs*nodes*nodes
% subids            -       list of subject ID's (or filenames)
% path2save         -       directory where to store the output
% mask              -       1D vector of grouplabels/subject indices
%                           1=control 2=patient, might be useful later on
% costlimit         -       highest cost to loop over
% nRand             -       number of random matrices to create for normalization
% prefix            -       prefix for filenaming
% TAKEABS           -       use binary matrices

%[Results] = rb_EEG_Network(matrices, subids, '/Output/Nets/', mask, 0.3, 100, 'Net_', 1);


for isub = 1:length(matrices,1)
    
    [s.path, s.filename, s.extension] = fileparts(subids(isub,:));
    ConnMat = matrices(isub,:,:)
    
    %Declare the variables to store all measures that will be used
    s.cost=[]; s.k=[]; s.a=[]; s.arand=[]; s.M=[]; s.Mrand=[];
    s.C=[]; s.Crand=[]; s.L=[]; s.Lrand=[]; s.Sigma=[];
    s.E=[]; s.Erand=[]; s.CE=[]; s.CErand=[];
    s.Diam=[]; s.Diamrand=[]; s.Bass=[]; s.Bassrand=[];
    A=[]; R=[];
    
    
    %Take absolute value of Correlations and set diagonal to ones:
    n=size(ConnMat,1);
    if TAKEABS
        ConnMat=abs(ConnMat);      %%%%%%%%%%%%%%%%%%%%%%%%% TAKING ABS VALUE
    end
    ConnMat(1:n+1:n*n)=1; %%%%%%%%%%%%%%%%%%%%%%%%% ONES ON DIAGONAL
    Results.ConnMat = ConnMat; % store correlation matrix
    
    %Create MST (the minimum spanning tree of the network
    disp('Calculating MST');
    MST=kruskal_mst(sparse(sqrt(2*(1-ConnMat))));
    
    %Store Initial MST in the adjacency matrix A that defines the network
    A=full(MST);
    [i,j]=find(MST);
    for m=1:length(i)
        A(i(m),j(m))= 1; %ConnMat(i(m),j(m));  %(NOT) WEIGHTED VERSION
        A(j(m),i(m))= 1; %ConnMat(i(m),j(m));  %(NOT) WEIGHTED VERISON
    end % for m
    
    %find corresponding random matrix R
    R=randmio_und_connected(A, nRand);
    
    %Start Growing the network according to weights in ConnMat matrix and record Network Measures
    %after each edge addition
    
    %Initially, with just the MST: set counters and calculate cost and all measures
    t=1;
    enum=n-1;
    g = 1;
    s.cost(g)=enum/(n*(n-1));
    %% gmeasure;
    %calculate measures
    %%%%%%%%%%% Degrees
    deg=degrees_und(A);
    degr=degrees_und(R);
    s.k(g)=mean(deg);
    
    %%%%%%%%%%%% Assortativity
    s.a(g)=assortativity_bin(A,0); %weights are discarded even if they exist
    s.arand(g)=assortativity_bin(R,0);
    
    %%%%%%%%%%%% Modularity
    [Com s.M(g)]=modularity_und(A);
    [Comr s.Mrand(g)]=modularity_und(R);
    
    
    %%%%%%%%%%%% Clustering
    s.C(g)=mean(clustering_coef_bu(A));
    s.Crand(g)=mean(clustering_coef_bu(R));
    
    %%%%%%%%%%%% Betweeness-Centrality
    s.bc(g) = mean(betweenness_bin(A));
    s.bcrand(g) = mean(betweenness_bin(R));
    
    %%%%%%%%%%%% Distance matrix
    Dist=distance_bin(A);
    DistRand=distance_bin(R);
    %%%%%%%%%%%% Path Length
    s.L(g)=mean(mean(Dist))*n/(n-1);
    s.Lrand(g)=mean(mean(DistRand))*n/(n-1);
    
    %%%%%%%%%%%%% Small-World Coefficient
    s.Sigma(g)=(s.C(g)./s.Crand(g))./(s.L(g)./s.Lrand(g));
    
    %%%%%%%%%%%%% Efficiency
    s.E(g)=efficiency_bin(A);
    s.Erand(g)=efficiency_bin(R);
    
    %%%%%%%%%%%% Cost-Efficiency
    s.CE(g)=s.E(g)-s.cost(g);
    s.CErand(g)=s.Erand(g)-s.cost(g);
    %%%%%%%%%%%%
    
    %Now add edges in correct order until all possible edges exist
    disp('Starting with MST and adding edges over a range of Costs');
    while (enum < COSTLIMIT*n*(n-1)/2)
        enum;
        % if edge wasn't initially included in MST
        if A(row(t),col(t)) == 0
            %add edge
            A(row(t),col(t)) = 1; %ConnMat(row(t),col(t)); %NOT WEIGHTED VERSION
            A(col(t),row(t)) = 1; %ConnMat(row(t),col(t)); %NOT WEIGHTED VERSION
            enum=enum+1;
            if mod(enum, step) == 0
                %find corresponding R matrix
                R = randmio_und_connected(A, 10);
                %Increment counter
                g = g + 1;
                %calculate cost
                s.cost(g)=2*enum/(n*(n-1));
                disp(sprintf('Working on cost = %f',s.cost(g)));
                %Call function that calculates all measures
                %%gmeasure; %%THIS FUNCTION CALCULATES THE MEASURES WE WANT
                %calculate measures
                %%%%%%%%%%% Degrees
                deg=degrees_und(A);
                degr=degrees_und(R);
                s.k(g)=mean(deg);
                
                %%%%%%%%%%%% Assortativity
                s.a(g)=assortativity_bin(A,0); %weights are discarded even if they exist
                s.arand(g)=assortativity_bin(R,0);
                
                %%%%%%%%%%%% Modularity
                [Com s.M(g)]=modularity_und(A);
                [Comr s.Mrand(g)]=modularity_und(R);
                
                %%%%%%%%%%%% Clustering
                s.C(g)=mean(clustering_coef_bu(A));
                s.Crand(g)=mean(clustering_coef_bu(R));
                
                %%%%%%%%%%%% Betweeness-Centrality
                s.bc(g) = mean(betweenness_bin(A));
                s.bcrand(g) = mean(betweenness_bin(R));
                
                %%%%%%%%%%%% Distance matrix
                Dist=distance_bin(A);
                DistRand=distance_bin(R);
                %%%%%%%%%%%% Path Length
                s.L(g)=mean(mean(Dist))*n/(n-1);
                s.Lrand(g)=mean(mean(DistRand))*n/(n-1);
                
                %%%%%%%%%%%%% Small-World Coefficient
                s.Sigma(g)=(s.C(g)./s.Crand(g))./(s.L(g)./s.Lrand(g));
                
                %%%%%%%%%%%%% Efficiency
                s.E(g)=efficiency_bin(A);
                s.Erand(g)=efficiency_bin(R);
                
                %%%%%%%%%%%% Cost-Efficiency
                s.CE(g)=s.E(g)-s.cost(g);
                s.CErand(g)=s.Erand(g)-s.cost(g);
                %%%%%%%%%%%%
            end % if mod(enum, step) == 0
        end % if A(row(t),col(t)) == 0
        t=t+1;
    end % while
    
    %% Save
    %Transfer the structure containing the measures into a correctly named
    %variable for saving.
    disp('Saving Results');
    eval(sprintf('Results_%s = s;',prefix));
    
    %Save the structure in a .mat file
    fname = fullfile(path2save,strcat(prefix,filename,'mat'));
    save(fname,s);
    
end
