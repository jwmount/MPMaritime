# #!/usr/local/bin/ruby
# load.rb -- load the dataset with data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb (CR)
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

  code         = 'CAGC_FR'
  data         = []
  d            = Dataset.find(code)

  puts "\nLoading #{d.code}..."

# READ CSV VERSION OF DATA AND LOAD TO DATASET
  CSV.foreach('data.csv') do |row|
    data << [ row[0], row[1] ]
  end

  d.data = data
  puts d.data.to_s
  d.save

  puts "Loaded #{d.data.count} points into #{d.source_code}/#{d.code}."
  puts "--done."