% permutation testing

function [pval] = permutation_2tailed(Control,Case,n)

% Control is a vector of values for controls that you'd like to compare to
% a vector of values from cases (called Case).

% n is the number of permutations you'd like to do. This should be at least
% 1000 usually.

% the output pval is the p-value for the difference between the groups as
% measured by permutation testing.

nControl = numel(Control');

diff = abs(mean(Control')-mean(Case'));

Data = [Control' Case'];

diffp = zeros(n,1);
for i = 1:n;
    p = randperm(numel(Data));
    diffp(i,1) = abs(mean(Data(p(1:nControl)))-mean(Data(p((nControl+1):end))));    
end

    pval = numel(find(diffp>diff))./n;
