function [cfsThrsOut] = controlChart(cfsThrs)
%%%Control chart to remove outliers
%   Use as:
%       [cfsThrsOut] = controlChart(cfsThrs)
%   Input:
%       - cfsThrs, original coefficients sequence
%   Output:
%       - cfsThrsOut, coefficients sequence without outliers
%
%
%   Author   : Xuanjun Guo
%   Created  : Jan 30, 2024
%   Modified : Feb 1, 2024

% Control chart
    flag = 0;
    ControlChartNumber = 0;
    while(flag == 0)
    ControlChartNumber = ControlChartNumber+1;
    meancfsThrs  = mean(cfsThrs);
    sigmacfsThrs = std(cfsThrs);
    cfsThrsNew = cfsThrs(cfsThrs<meancfsThrs+2.58*sigmacfsThrs & cfsThrs>meancfsThrs-2.58*sigmacfsThrs);
    % 1%-2.58 2%-2.33
    if length(cfsThrsNew) == length(cfsThrs)
        cfsThrs = cfsThrsNew;
        flag = 1;
        cfsThrsOut = cfsThrsNew;
    else
        cfsThrs = cfsThrsNew;
    end
    
    end
end

