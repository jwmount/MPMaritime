#!/usr/local/bin/ruby
# Interval handler
# scheduler.rb -- load the dataset data
# Purpose:  Schedule load.rb cycles
# How to run this script:
#   $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby scheduler.rb -d /Users/John/DropBox/PRODUCTION

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
    puts "#{elapsed.to_s} seconds, started at: #{start_time.strftime("%H:%M:%S")}"
    sleep([interval - elapsed, 0].max)
  end
end

@options = OptparseArguments.parse(ARGV)

# Start load.rb every nn seconds, pass in value of -d and default the others
# Using -i causes load.rb to ignore user confirmation on options.
repeat_every(600) do
  puts Time.now.strftime("Time is: %H:%M:%S")
  system("QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb -i -v -s -d #{@options[:directory]}")
end

