# #!/usr/local/bin/ruby
# edit.rb -- load the dataset with data
# Purpose:  Edit UI elements of fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby edit.rb (CR)
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

code        = 'VSGC_SR_F'
d           = Dataset.find code

  puts "d.code will be edited."
  #
  # EDIT attributes here
  #
  d.name = "Very Small Gas Carrier, Semi Refrigerated--Fleet History"
  d.description = 'Vessels in the xxx,600 cbm range.'
  d.description += " See also 'Very Small Gas Carrier, Semi Refrigerated--Spot Contract Rates.' "
  d.name = 'Very Small Gas Carrier, Semi Rerigerated'
  d.name += '--Fleet History'
  #  
  d.save
  puts "Loaded #{d.source_code}/#{d.code}."
  puts "--done."