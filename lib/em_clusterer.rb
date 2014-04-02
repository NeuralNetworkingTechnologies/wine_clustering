require 'ai4r'

class EMClusterer
  def initialize(data_set, k)
    @data_set = data_set
    @k = k
  end

  def estimate!
    @kmeans = Ai4r::Clusterers::KMeans.new
    @kmeans.build(@data_set, @k)
    
    prior = Hash.new(0)
    weight_sum = 0
    counts = Hash.new(0) 
    classifications = [] 
    @data_set.data_items.each do |point|
      mapping = @kmeans.eval(point)
      classifications << mapping
      counts[mapping] += 1
      prior[mapping] += 1
      weight_sum += 1
    end

    instances = {}
    @k.times do |i|
      instances[i] = Array.new(counts[i])
    end

    counts = Hash.new(0)

    @data_set.data_items.each_with_index do |point, i|
      instances[classifications[i]][counts[classifications[i]]] = point
      counts[classifications[i]] += 1
    end

    initial_distributions = []
    @k.times do |i|
      gaussian = MultivariateGaussian.new
      gaussian.estimate(instances[i])
      prior[i] /= weight_sum
      initial_distributions << MultivariateGaussian
    end

    mixture = MixtureDistribution.new(initial, prior)
    done = false
    last_log_liklihood = 0
    iterations = 0

    until done
      puts "On iteration #{iterations}" 
      puts mixture

      mixture.estimate(@data_set)
      log_liklihood = @data_set.reduce(0.0) {|point, logli| logli += mixture.logp(point) }
      log_liklihood /= @data_set.size

      done = (iterations > 0 && (log_liklihood - last_log_liklihood).abs < tolerance) || (iterations + 1 >= max_iterations)
      last_log_liklihood = log_liklihood
      iterations += 1
    end
  end
end
