function ramp = sigmoid(x, latency, slope)
ramp = 1 ./ (1 + exp(- slope * (x-latency)));
