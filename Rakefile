task :console do
  require 'irb'
  require 'irb/completion'
  def reload!
    Dir['lib/**/*.rb'].each {|_| load _ }
  end
  reload!
  ARGV.clear
  IRB.start
end
