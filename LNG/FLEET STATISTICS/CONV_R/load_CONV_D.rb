# load_CONV_D.rb
# #!/usr/local/bin/ruby
# $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load_CONV_D.rb
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

  source_code  = 'LNG'
  code         = 'CONV_D'
  data         = []
  d            = Dataset.find("#{source_code}/#{code}")

  puts "d.code will be loaded from data.csv."

# READ CSV VERSION OF DATA AND LOAD TO DATASET
# ORDERBOOK is column 5
  CSV.foreach('data.csv') do |row|
    data << [row[0]] + [row[6]]
  end
  puts data
  d.data = data
  puts d.errors
  puts d.error_messages
  d.save
  puts d.errors
  puts d.error_messages

  puts "Loaded #{d.data.count} points into #{d.source_code}/#{d.code}."
  puts "--done."