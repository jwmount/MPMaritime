# #!/usr/local/bin/ruby
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby create_LPG_datasets.rb (CR)
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

  # ATTRIBUTES FOR CREATES AND EDITS
  code            = 'VLGC_FR'
  data            = []
  source_code     = 'LPG_R'
  attributes = {
    :source_code  => source_code,   # root of database name
    :code         => code,          # dataset modifier of database name
    :column_names => ['Date', '$/day'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Very Large Gas Carriers, Fully Refrigerated--Spot Market Rates',
    :private      => false,         # true do not show | false make visible
    :description  => "Vessels of 78,000 cbm or larger. The principal routes for LGC vessels are from the Black Sea to the USA and from West Africa to the USA. Most of the LGC fleet is employed for transporting ammonia.  See also 'Very Large Gas Carrier--Fleet History.'"
  }
  
  
  d = Dataset.find( "#{source_code}/#{code}")
  if d.name.nil?
    d = Dataset.create(attributes)
  else
    d.assign_attributes(attributes)
  end

# PUSH IT UP TO QUANDL
  begin
    d.save
    puts "Dataset #{d.code} created."
  rescue => e
    warn e.message
    puts "---update to #{d.code} failed."
  end

