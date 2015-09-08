#!/usr/local/bin/ruby
# Interval handler
# scheduler.rb -- load the dataset data
# Purpose:  Schedule load.rb cycles
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb

def repeat_every(interval)
  loop do
    start_time = Time.now
    yield
    elapsed = Time.now - start_time
    puts "#{elapsed.to_s} elapsed since #{start_time.strftime("%H:%M:%S")}"
    sleep([interval - elapsed, 0].max)
  end
end

  # META LOOP, repeats the sweep in :interval seconds
  repeat_every(@options[:interval]) do
    puts Time.now.strftime("Sweep at %H:%M:%S")
  end

      # directory where files will be read from
      opts.on("-i", "--int INTEGER",
              "Interval in seconds between sweeps, default: #{options[:interval]}") do |d|
              options[:interval] = i
      end
