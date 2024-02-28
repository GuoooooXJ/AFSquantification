function [lambda] = Estimation(cfsThrs,frequencyBand)
%%%AFS quantification Estimation
%   Use as:
%       [lambda] = Estimation(cfsThrs,frequencyBand)
%   Input:
%       - cfsThrs, coefficients sequence
%       - frequencyBand, jth layer in decomposition(4 in this study is low beta band)
%   Output:
%       - lambda, estimated value
%
%
%   Author   : Xuanjun Guo
%   Created  : Jan 30, 2024
%   Modified : Feb 1, 2024

    normfac = -sqrt(2)*erfcinv(2*0.75);
    sigmaest = median(abs(cfsThrs))*(1/normfac);
    sigmaest(sigmaest<realmin('double')) = realmin('double');
    thr = thselect(cfsThrs/sigmaest,'minimaxi');
    lambda = sigmaest*thr*(1/log(frequencyBand+1));
end

