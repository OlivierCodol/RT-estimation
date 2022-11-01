function [i_knee, varargout] = segmented_linear(roc)

i_knee = NaN;
window_width = 2;

[LB,UB] = deal(.25, .75);
n_samples = numel(roc);
knee_range = [1, n_samples];
first_reliable_departure_from_chance = find((roc(knee_range(1):knee_range(2)) >= UB) | (roc(knee_range(1):knee_range(2)) <= LB),1);
if isempty(first_reliable_departure_from_chance)
    return
end

i7525 = knee_range(1) + first_reliable_departure_from_chance - 1;
window = i7525 : (i7525+window_width-1);
found = false;

while (found==false && window(end)<(knee_range(2)))
    
    window = i7525 : (i7525+window_width-1);
    
    if ( all(roc(window)>UB) || all(roc(window)<LB) )
        found = true;
    else
        i7525 = i7525 + 1;
    end
end
if (found==false)
    return
end

tstart = knee_range(1);             % the first possible knee point
tstop = i7525;                      % the last possible knee point
bestline_y = zeros(1,tstop-tstart+1);% initialize segmented fit to vector of zeroes
SSE = zeros(1,tstop-tstart);        % initialize a vector to store SSEs to zeroes
for i = 1:(tstop-tstart+1)          % for every potential knee point
    bestline_y(1:i) = mean(roc(tstart:tstart+i));
    bestline_y(i:end) = linspace(bestline_y(i), roc(tstop), length(bestline_y(i:end)));
    SSE(i) = sum((roc(tstart:tstop) - bestline_y).^2);
end

[~,i_min] = min(SSE);
bestline_y(1:i_min) = mean(roc(tstart:tstart+i_min));
bestline_y(i_min:end) = linspace(bestline_y(i_min), roc(tstop), length(bestline_y(i_min:end)));

i_knee = i_min + tstart - 1;
varargout = {bestline_y};

end