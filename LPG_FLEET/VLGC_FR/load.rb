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
require 'date'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

def convert_date( str )
  dt = Date.parse( str )
  puts dt
  dt
end

  source_code = 'LPG_F'
  code        = 'VLGC_FR'
  data        = []
  d           = Dataset.find("#{source_code}/#{code}")

# READ CSV VERSION OF DATA AND LOAD TO DATASET
  CSV.foreach('data.csv') do |row|
    break if row[0].nil?
    row[0] = convert_date(row[0])
    data << row.slice(0,7)
  end

  d.data = data
  d.save
  puts d.errors
  puts d.error_messages

  puts "Loaded #{d.data.count} into #{d.source_code}/#{d.code}."
  puts "--done."