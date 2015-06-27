# #!/usr/local/bin/ruby
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby create_LPG_datasets.rb (CR)
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

source_code = 'LPG'
code        = 'VLGC_FR'
data        = []

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
    :name         => 'Very Large Fully Refrigerated Gas Carrier Spot Rates',
    #:private      => false,         # true do not show | false make visible
    :description  => 'Very large Fully Refrigerated Gas Carrier vessels with capacity of 82,000 cbm or more.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy
  
  d = Dataset.create(attributes)
  puts "#{d.code} with #{d.class.name}"
  puts d.data.class

# READ CSV VERSION OF DATA AND LOAD TO DATASET
  CSV.foreach('data.csv') do |row|
    data << [ row[0]  ,row[1] ]
  end
  d.data = data

# CONFIRM WHAT'S NOW IN DATASET
  d.data.each {| a | puts "#{a[0]}, #{a[1]}" }
  puts "#{d.code} has #{d.data.count} rows in it, saving it."

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
