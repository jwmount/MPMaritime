# #!/usr/local/bin/ruby
# Purpose:  Create dataset VLGC_FR_F fleet data.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby create.rb (CR)
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

source_code = 'LPG'              # EDIT Database
code        = 'LGC_FR_F'         # EDIT Dataset

# CREATE THE DATASET
# if it exists, destroy it because this version creates it entirely.
# NOTE:  a d.destroy costs a half hour delay to recreate the entry in the index
# TEST:  www.quandle.com/data/LPG/VLGC_FR_F  


# CREATE THE DATASET
attributes = { 
    :source_code  => source_code,
    :code         => code,
    :column_names => ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Large Gas Carriers, Fully Refrigerated--Spot Contract Rates',
    :private      => false,         # true do not show | false make visible
    :description  => 'Vessels of xx - xx,000 cbm or larger.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy

  d = Dataset.create(attributes)
  puts "#{d.code} with #{d.class.name}"
  puts d.data.class
  
  d.save
  
  puts "Created #{d.data.count} rows and saved dataset #{attributes[:source_code]}/#{attributes[:code]}."
  puts "--done."