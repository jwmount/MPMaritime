# #!/usr/local/bin/ruby
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby edit.rb (CR)
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG    -- index
#         https://www.quandl.com/LPG/GC_FR  -- direct
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

  source_code    = 'LPG_R'
  code           = 'SGC_SR'
  d              = Dataset.find("#{source_code}/#{code}")

  puts             "d.code will be edited."

  #
  # EDIT attributes here
  #
  d.description  = 'Vessels of around 6,000 cbm. '
  d.description += 'See also Small Gas Carrier--Fleet Statistics.'

  d.name         = 'Small Gas Carrier, Semi Refrigerated--'
  d.name        += "Spot Market Rates"
  
  d.save

  puts             "Loaded #{d.source_code}/#{d.code}."
  puts             "--done."

#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
