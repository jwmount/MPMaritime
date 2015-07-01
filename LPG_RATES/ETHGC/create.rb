# #!/usr/local/bin/ruby
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby create.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
#         https://www.quandl.com/documentation#!/api
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

source_code  = 'LPG'
code         = 'ETHGC'
data         = []

# CREATE THE DATASET LPG/VLGC_FR
# if it exists, destroy it because this version creates it entirely.
# RAYMOND--is there a construct that does a create_if_not_exists? 
# NOTE:  a d.destroy costs a half hour delay to recreate the entry in the index
#d = Dataset.find(code)
#d.destroy

# CREATE THE DATASET LPG/VLGC_FR
  attributes = {
    :source_code  => source_code,   # root of database name
    :code         => code,          # dataset modifier of database name
    :column_names => ['Date', 'Spot Rates($/mo)'],
    :data         => [],
    :frequency    => 'weekly',
    :name         => 'Ethanol Gas Carriers--Spot Market Rates',
    :private      => false,         # true do not show | false make visible in LPG_R index page
    :description  => 'Vessels of 10,000 cbm.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy
  d = Dataset.create(attributes)
  puts "#{d.code} with #{d.class.name}"
  puts d.data.class

# PUSH IT UP TO QUANDL
  begin
    d.save
    puts "Dataset #{d.code} created."
  rescue => e
    warn e.message
    puts "---update to #{d.code} failed."
  end

#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
