function [U, labels] = icm2(unary, pairwise, labels, sites)
%%%%%%%%%%%%%%%%%%%%
% icm.m 
% computes the map estimate via Iterated Conditional Modes
% Maximize local conditional probabilities P(f_i | d, f_s/i)
% sequentially until convergence
%
% Angjoo Kanzawa 4/30/'12
%%%%%%%%%%%%%%%%%%%%
    % U = getAllEnergy(unary, pairwise, labels);
    N = size(pairwise, 1);
    fprintf('starting ICM\n');
    numChanged = Inf;
    while numChanged ~= 0 %diff > 1e-13
        numChanged = 0;
        for i = 1:N
            [u0 u1] = getEnergy(unary, pairwise, i, labels, sites);
            if u1 < u0 % no improvement
                labels(i)= ~labels(i); % swap
                numChanged = numChanged + 1;
            end
        end
        % UNew = getAllEnergy(unary, pairwise, labels);
        % diff = abs(UNew - U);
        % fprintf('\tUold: %g Unew: %g diff: %g\n', U, UNew, diff);
        % U = UNew;
    end
    U = getAllEnergy(unary, pairwise, labels);       
end

% get single and pairwise potential for single site as u0
% and u1 as the potential for that site with label switched
function [u0 u1] = getEnergy(unary, pairwise, ind, labels, sites)
    neigh = sites{ind}.neighbors;
    notSame = find(labels(neigh)~= labels(ind));
    notSameChanged = find(labels(neigh)== labels(ind));
    u0 = unary(labels(ind)+1, ind) + ...
         sum(pairwise(ind, neigh(notSame)));
    u1 = unary(~labels(ind)+1, ind) + ...
         sum(pairwise(ind, neigh(notSameChanged)));
end
