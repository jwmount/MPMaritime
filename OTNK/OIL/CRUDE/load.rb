# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
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
  code         = 'CRUDE'
  d            = Dataset.find("#{source_code}/#{code}")
  data         = []

  puts "d.code will be loaded from data.csv."

# READ CSV VERSION OF DATA AND LOAD TO DATASET
  CSV.foreach('data.csv') do |row|
    data << row
  end
  d.data = data
  puts d.data.to_s   

  d.save
  puts "Loaded #{d.data.count} into #{source_code}/#{d.code}."
=begin
  begin 
    d.save
    puts "Loaded #{d.data.count} into #{source_code}/#{d.code}."
  rescue
    puts "\n\nLoad #{source_code}/#{d.code} FAILED."
    puts "#{@messages}\n\n"
  end
=end
  puts "--done."