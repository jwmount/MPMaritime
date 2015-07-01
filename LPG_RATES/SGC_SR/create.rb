# #!/usr/local/bin/ruby
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby create.rb
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

source_code = 'LPG_R'         # EDIT Database
code = 'SGC_SR'             # EDIT Dataset

# CREATE THE DATASET LPG/SGC_SR
  attributes = {
    :source_code  => source_code,
    :code         => code,
    :column_names => ['Date', 'Spot Rates($/mo)'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Small Gas Carrier, Semi Refrigerated--Spot Market Rates',
    :private      => false,         # true do not show | false make visible
    :description  => 'Vessels of 6,000 cbm.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy

  d = Dataset.create(attributes)
  puts "#{d.code} with #{d.class.name}"
  puts d.data.class
  
  d.save
  
  puts "created and saved dataset #{attributes[:source_code]}/#{attributes[:code]}."
  puts "--done."