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
Quandl::Client.token = ['QUANDL_TOKEN']

  source_code  = 'OTNK'
  code         = 'CRUDE'
  d            = Dataset.find("#{source_code}/#{code}")
  data         = []
  mons         = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

  puts "data before loading:\n#{d.data.count}\n"
# READ CSV VERSION OF DATA AND LOAD TO DATASET
# Convert from "Jan 04, 2000",25.56,23.95, to 1/4/2000,25.56,23.95
  CSV.foreach('data.csv') do |row|
    dt = row[0].gsub(/,/, '').split 
    m = mons.index(dt[0]) + 1
    row[0] = "#{m}/#{dt[1]}/#{dt[2]}"
    data << row 
  end
  d.data = data

  begin 
    d.save
    puts "Loaded #{d.data.count} into #{d.source_code}/#{d.code}."
  rescue
    puts "\n\nLoad #{d.source_code}/#{d.code} FAILED."
    puts "#{d.errors}\n\n#{@messages}\n\n"
  end
  puts "--done."