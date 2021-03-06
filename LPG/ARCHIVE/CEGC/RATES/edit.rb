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

code        = 'CEGC_FR'
d           = Dataset.find code

  puts "d.code will be edited."

  #
  # EDIT attributes here
  #
  d.description = 'Vessels of xx,000 cbm or larger. '
  d.description += 'See also Coastal European Gas Carrier, Fully Refrigerated--Fleet History.'

  d.name = 'Coastal European Gas Carrier, Fully Refrigerated--'
  d.name += "Spot Contract Rates"
  
  d.save

  puts "Loaded #{d.source_code}/#{d.code}."
  puts "--done."