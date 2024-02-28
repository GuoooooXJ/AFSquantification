function [lambda] = Estimation(cfsThrs,frequencyBand)
    normfac = -sqrt(2)*erfcinv(2*0.75);
    sigmaest = median(abs(cfsThrs))*(1/normfac);
    sigmaest(sigmaest<realmin('double')) = realmin('double');
    thr = thselect(cfsThrs/sigmaest,'minimaxi');
    %alpha = sqrt(median(abs(cfsThrs))/abs(Signal((startPointTemp)+(iStep-1)*step)));
    lambda = sigmaest*thr*(1/log(frequencyBand+1));
end

