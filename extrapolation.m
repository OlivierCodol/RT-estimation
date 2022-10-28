function latency = extrapolation(signal, labels)

trace = median(signal(labels, :));
peak = max(trace);

y25 = peak * 0.25;
y75 = peak * 0.75;
x25 = find(trace > y25, 1);
x75 = find(trace > y75, 1);

slope = (y25 - y75) / (x25 - x75);
intercept = y25 - x25 * slope;
latency = - intercept / slope;

end