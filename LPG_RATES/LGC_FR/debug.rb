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


# CREATE THE DATASET LPG/VLGC_FR
# if it exists, destroy it because this version creates it entirely.
# NOTE:  a d.destroy costs a half hour delay to recreate the entry in the index
# TEST:  www.quandle.com/data/LPG/VGC_SR  

source_code = 'LPG'
code        = 'LGC_FR'

# CREATE THE DATASET LPG/VLGC_FR
  attributes = {
    :source_code  => source_code,             
    :code         => code,              
    :column_names => ['Date', 'Spot Rates($/mo)'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Large Gas Carrier, Semi Refrigerated--Spot Contract Rates',
    :private      => false,         # true do not show | false make visible
    :description  => 'Vessels of around xx - xx,000 cbm.'
  }

  d = Dataset.find(code)
  puts d.errors

  d.destroy
  puts d.errors

  d = Dataset.create(attributes)
  puts d.errors

  d.save
  puts d.errors

  puts "created and saved dataset #{attributes[:source_code]}/#{attributes[:code]}."
  puts "--done."