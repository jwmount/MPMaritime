# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
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

  source_code  = 'LPG_R'
  code         = 'VLGC_FR'
  data         = []
  d            = Dataset.find("#{source_code}/#{code}")

  puts "d.code will be loaded from data.csv."

# READ CSV VERSION OF DATA AND LOAD TO DATASET
  CSV.foreach('data.csv') do |row|
    data << row 
  end
  puts data.to_s
  d.data = data
   
  d.save

  puts "Loaded #{d.data.count} into #{d.source_code}/#{d.code}."
  puts "--done."