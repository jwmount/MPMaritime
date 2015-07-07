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

source_code       = 'LPG_R'
code              = 'MGC_SR'

# CREATE THE DATASET LPG_R/MGC_FR
  attributes = {
    :source_code  => source_code,             
    :code         => code,              
    :column_names => ['Date', '$/day'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Medium Gas Carriers, Semi Refrigerated--Spot Market Rates',
    :private      => false,         # true do not show, does not appear in API calls
    :description  => "Vessels of 35,000 cbm or larger.  See also 'Medium Gas Carriers, Semi Refrigerated--Fleet Statistics.'"
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

