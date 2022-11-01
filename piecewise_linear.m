function ramp = piecewise_linear(x, latency, slope)
    intercept = - latency * slope;
    ramp = max(slope * x + intercept, 0);
    ramp = min(ramp, 1);
end
