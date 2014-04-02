class MultivariateGaussian
  def estimate(observations)
    row_size = observations.shape.last
    summing_matrix = NMatrix.float(1, row_size) 
    row_size.times {|i| summing_matrix[0,i] = 1 }

    means = Rational(1, row_size) * (observations.transpose * summing_matrix).transpose

    covariance_matrix = NMatrix.float(row_size, row_size)
    observations.each do |observation|
      dminus_mean = observation - means

      n,m = covariance_matrix.shape
      m.times do |i|
        n.times do |j|
          covariance_matrix[i,j] = covariance_matrix[i,j] + dminus_mean[i] * dminus_mean[j]
        end
      end
    end

    covariance_matrix *= Rational(1, observations.length)
  end
end
