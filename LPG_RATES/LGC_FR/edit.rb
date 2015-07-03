# #!/usr/local/bin/ruby
# edit.rb -- load the dataset with data.  NOTE:  edits do not seem to fire evetns.  
# Purpose:  Edit UI elements of fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby edit.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_R
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

  source_code    = 'LPG_R'
  code           = 'LGC_FR'            # Dataset, EDIT this
  d              = Dataset.find("#{source_code}/#{code}")
  
  if d.exists?

    # IF Dataset exists, edit as requested below and save it.
    puts "d.code will be edited."

    d.description  = 'Vessel capacity of around 55,000 cbm. '
    d.description += 'The principal routes for LGC vessels are from the Black Sea to the USA and from West Africa to the USA. Most of the LGC fleet is employed for transporting ammonia' 
    d.description += 'See also Large Gas Carrier--Fleet Statistics.'

    d.name         = 'Large Gas Carriers, Fully Refrigerated--'
    d.name        += "Spot Market Rates"
    d.private      = false
  
    d.save
    puts "Edited #{d.source_code}/#{d.code}."
  else
    puts "Edit #{d.source_code}/#{d.code}--FAILED."
  end

  puts "--done."
