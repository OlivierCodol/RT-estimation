clearvars

%----------------------
% simulation parameters
%----------------------
n_trials_per_cond = 50;
n_samples = 400;
slope = 0.01;
latency_var = 0;


%-------------------------
% create synthetic signals
%-- We use a sigmoid signal because it is closer to
%-- empirical signals from EMG recordings.
%-------------------------
condition = [-1, 1];
condition = repmat(condition, 1, n_trials_per_cond);
condition = condition(randperm(numel(condition)));

n_trials = numel(condition);
x = 1:n_samples;
noises = linspace(0, 1, 50);
mid = latency_var * randn(n_trials, 1) + n_samples / 3;

ramp = piecewise_linear(x, mid, slope);

%-------------------------
% plot example signal
%-------------------------
signal = condition' .* ramp + 0.2 * randn(n_trials, n_samples);
figure(1); clf;
plot(signal')
xlabel('sample')
ylabel('signal [a.u.]')


%--------------------
% find "ground truth"
%--------------------
latency_true = mid;


%----------------
% allocate memory
%----------------
n_sim = 100;

rocc_estimate = nan(numel(noises), n_sim);
extr_estimate = nan(numel(noises), n_sim);
m5pc_estimate = nan(numel(noises), n_sim);
nstd_estimate = nan(numel(noises), n_sim);
tsdb_estimate = nan(numel(noises), n_sim);


%-------------------
% estimate latencies
%-------------------
for k = 1:n_sim
    iter = 1;
    eps = randn(n_trials, n_samples);
    for noise = noises
        
        signal = condition' .* ramp + noise * eps;
        
        rocc_estimate(iter, k) = rocc(signal, condition > 0);
        extr_estimate(iter, k) = extrapolation(signal, condition > 0);
        m5pc_estimate(iter, k) = max5p(signal, condition > 0);
        nstd_estimate(iter, k) = abovebaseline(signal, condition > 0);
        tsdb_estimate(iter, k) = teasdaleb(signal, condition > 0);

        iter = iter + 1;
    end
end


%-------------------------
% plot estimated latencies
%-------------------------
figure(2); clf; hold on

plot(noises, extr_estimate, 'r')
plot(noises, m5pc_estimate, 'g')
plot(noises, nstd_estimate, 'm')
plot(noises, tsdb_estimate, 'c')
plot(noises, rocc_estimate, 'k')

% legend
text(0.02, -65, 'true latency', 'color',[0.5 0.5 1])
text(0.02, -80, 'teasdale B', 'color','c')
text(0.02, -95, 'above baseline', 'color','m')
text(0.02, -110, '5% peak', 'color','g')
text(0.02, -125, 'extrapolate', 'color','r')
text(0.02, -140, 'ROC', 'color','k')

% plot true latency
true_x = [noises(1) noises(end)];
true_y = [median(latency_true) median(latency_true)];
plot(true_x, true_y, 'color', [0.5 0.5 1], 'linewidth', 2, 'linestyle', '-')
xlabel('noise standard deviation [a.u.]')
ylabel('estimated latency [a.u.]')

