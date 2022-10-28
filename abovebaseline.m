function latency = abovebaseline(signal, labels)

trace = signal(labels, :);
thres = 3 * std(trace(:, 1:100), 1, 2);

n_trials = size(trace, 1);
lat = nan(n_trials, 1);

for t = 1:n_trials
    L = find(trace(t,:) > thres(t), 1);
    if isempty(L)
        lat(t) = nan;
    else
        lat(t) = L;
    end
end

latency = median(lat);

end
