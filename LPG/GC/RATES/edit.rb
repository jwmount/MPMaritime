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


  code           = 'GC_SR'
  d              = Dataset.find("LPG/#{code}")

  puts             "LPG/#{d.code} will be edited."

  #
  # EDIT attributes here
  #
  d.description  = 'Vessels of around 20 - 39,999 cbm. '
  d.description += 'The MGCs primarily navigate intra-European routes and in the Gulf of Mexico, but also operate from the Arabian Gulf to Asia. '
  d.description += "See also 'Gas Carrier--Fleet History.'"

  d.name         = 'Gas Carrier, Semi Refrigerated--'
  d.name        += "Spot Contract Rates"
  
  d.save

  puts             "Edited #{d.source_code}/#{d.code}."
  puts             "#{@messages}" unless @messages.nil?
  puts             "--done."

#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
