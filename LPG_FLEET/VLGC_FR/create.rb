# #!/usr/local/bin/ruby
# Purpose:  Create dataset VLGC_FR_F fleet data.
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

  source_code    = 'LPG_F'
  code           = 'VLGC_FR'
  d              = Dataset.find("#{source_code}/#{code}")
  
  # FIND OR CREATE THE DATASET 
  attributes = { 
    :source_code  => source_code,
    :code         => code,
    :column_names => ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Very Large Gas Carrier Fleet',
    :private      => false,         # true do not show | false make visible
    :description  => 'Very Large Gas Carrier fleet, vessels of 82,000 cbm or larger.'
  }
  if d.name.nil?
    d            = Dataset.create(attributes)
  end

  d.save
  
  puts "created and saved dataset #{attributes[:source_code]}/#{attributes[:code]}."
  puts "--done."