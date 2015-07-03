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

  source_code    = 'LPG_R'
  code           = 'LGC_FR'
  attributes = {
    :source_code  => source_code,             
    :code         => code,              
    :column_names => ['Date', 'Spot Rates($/mo)'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Large Gas Carriers, Fully Refrigerated--Spot Market Rates',
    :private      => false,         # true do not show, so does not appear in API calls
    :description  => 'Vessels of around 55,000 cbm.'
  }
  # CREATE THE DATASET
  d              = Dataset.find("#{source_code}/#{code}")
  if !d.exists?
    # IT DID NOT EXIST SO CREATE IT AND SAVE IT
    d            = Dataset.create(attributes)
    d.save
    puts "\nCreated and saved dataset #{attributes[:source_code]}/#{attributes[:code]}."
  else
    puts "\nWARNING:  Create dataset #{attributes[:source_code]}/#{attributes[:code]}--FAILED.\n"
  end
  puts "--done."