# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

  source_code  = 'OTNK'
  code         = 'S2015'
  d            = Dataset.find("#{source_code}/#{code}")
  data         = []
  mons         = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

  if d.code.nil?
    puts "Dataset 'OTNK/SINCE2015' is empty or nil."
  else
    # Dataset exists
    # READ CSV VERSION OF DATA AND LOAD TO DATASET
    # Convert from "2000-Jan-04",... to 1/4/2000,...
    puts "data before loading:\n#{d.data.count}\n"
    CSV.foreach('data.csv') do |row|
      dt = row[0].split('-')
      month = mons.index(dt[1]) + 1
      day = dt[2]
      year = dt[0]
      date = month.to_s + '/' + dt[1] + '/' + dt[2]  #{}"#{m}/#{dt[1]}/#{dt[2]}"
      data << [ date, row[1], row[2], row[3] ] 
    end
    d.data = data

    begin 
      d.save
      puts "Loaded #{d.data.count} into #{d.source_code}/#{d.code}."
    rescue
      puts "\n\nLoad #{d.source_code}/#{d.code} FAILED."
      puts "#{d.errors}\n\n#{@messages}\n\n"
    end
  end #if d.name.nil?

  puts "--done."