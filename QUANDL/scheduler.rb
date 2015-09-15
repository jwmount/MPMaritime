#!/usr/local/bin/ruby
# Interval handler
# scheduler.rb -- load the dataset data
# Purpose:  Schedule load.rb cycles
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb

require 'uri'
require 'pry'

require './optex.rb'

#
# Ruby Debug class,  to use, uncomment say() and have at it.  
#
def say(word)
  require 'debug'
  puts word + ' to begin debugging.'
end
#say 'Time'

def repeat_every(interval)
  loop do
    start_time = Time.now
    yield
    elapsed = Time.now - start_time
    puts "#{elapsed.to_s} elapsed since #{start_time.strftime("%H:%M:%S")}"
    sleep([interval - elapsed, 0].max)
  end
end

@options            = OptparseArguments.parse(ARGV)

# META LOOP, repeats the sweep in :interval seconds
repeat_every(@interval) do
  puts Time.now.strftime("Sweep at %H:%M:%S")
  t = Time.new(10)
  system("QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb -i #{t} ")
end

=begin
      # directory where files will be read from
      opts.on("-i", "--int INTEGER",
              "Interval in seconds between sweeps, default: #{options[:interval]}") do |d|
              options[:interval] = i
      end
=end