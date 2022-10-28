function latency = teasdaleb(signal, labels)

trace = signal(labels, :);
peaks = max(trace, [], 2);
thres1 = 0.25 * peaks;
thres2 = std(trace(:, 1:100), 1, 2);

n_trials = size(trace, 1);
lat = nan(n_trials, 1);

for t = 1:n_trials
    
    L = find(trace(t,  :) == peaks(t), 1);
    L = find(trace(t,1:L) > thres1(t), 1);
    L = find(trace(t,1:L) > thres2(t), 1);

    if isempty(L)
        lat(t) = nan;
    else
        lat(t) = L;
    end
    
end

latency = median(lat);

end