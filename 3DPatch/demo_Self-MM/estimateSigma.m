function sigma = estimateSigma(input, noisyY, sigma0, lambda)

sigma = lambda * sqrt(abs(sigma0^2 - mean((input(:) - noisyY(:)).^2)));

end

