function latency = max5p(signal, labels)

trace = signal(labels, :);
peaks = max(trace, [], 2);
thres = 0.05 * peaks;

n_trials = size(trace, 1);
lat = nan(n_trials, 1);

for t = 1:n_trials
    lat(t) = find(trace(t,:) > thres(t), 1);
end

latency = median(lat);

end