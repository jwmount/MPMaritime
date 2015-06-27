# #!/usr/local/bin/ruby
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby edit.rb (CR)
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG    -- index
#         https://www.quandl.com/LPG/ETHGC   -- direct
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

  # ETHANOL GAS CARRIER--ETHGC
  code           = 'ETHGC'
  d              = Dataset.find(code)

  puts             "d.code edit..."

  #
  # EDIT attributes here
  #
  d.description  = 'Vessels of around xx,000 cbm. '
  d.description += "See also 'Ethanol Gas Carrier--Fleet History'."

  d.name         = 'Ethanol Carrier--'
  d.name        += "Spot Contract Rates"
  
  d.save

  puts             "Loaded #{d.source_code}/#{d.code}."
  puts             "--done."

#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
