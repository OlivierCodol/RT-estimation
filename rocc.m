function latency = rocc(signal, labels)

n_samples = size(signal,2);
labels = repmat( labels', 1 , n_samples );

AUC = auc(labels , signal);
latency = segmented_linear(AUC);

end
