%% simple function to ensure an adjacency matrix is symmetric and absolute
%% occasionally corrcoef will give some rounding error
%% this prevents creating a sparse matrix needed to compute the minimal spanning tree

function [Out] = rb_makeSymmetric(In)

    dwt = In;
%symmetry
    disp(sprintf('Making correlation matrix symmetric')); 
    %Take absolute value of Correlations and set diagonal to ones:
    n=size(dwt,1);
    dwt=abs(dwt);     
    dwt(1:n+1:n*n)=1; %ones on diagonal
    
    %make ConnMat symmetric
    E = triu(dwt); %upper diagonal, rest 0
    F = E.'; %invert, so upper diagonal is now 0
    E = triu(dwt,1); %makes diagonal 0, so becomes 1 in next step
    dwt = E + F; %adds the two half matrices 
    
    %just to check if this manipulation worked -- CAN BE REMOVED
    if isequal(dwt, dwt')==0
        disp('WARNING: Correlation matrix is not symmetric');
    end 
    
    Out = dwt;
end
