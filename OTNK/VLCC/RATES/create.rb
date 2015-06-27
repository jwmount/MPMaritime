# #!/usr/local/bin/ruby
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

source_code = 'OTNK'
code        = 'CRUDE'
data        = []

# CREATE THE DATASET LPG/VLGC_FR
# if it exists, destroy it because this version creates it entirely.
# RAYMOND--is there a construct that does a create_if_not_exists? 
# NOTE:  a d.destroy costs a half hour delay to recreate the entry in the index
#d = Dataset.find(code)
#d.destroy

# DESTROY, CREATE AND SAVE DB
  attributes = {
    :source_code  => source_code,   # root of database name
    :code         => code,          # dataset modifier of database name
    :column_names => ['Date', 'WTI', 'Brent'],
    :data         => [],
    :frequency    => 'daily',
    :name         => 'Crude Oil Prices',
    :private      => false,         # true do not show | false make visible
    :description  => 'Crude Oil Price index.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy
  d = Dataset.create(attributes)
  
  begin
    d.save
    puts "Dataset #{d.code} created."
  rescue
    puts "\n\n---update to #{d.code} FAILED."
    puts "#{d.errors}\n#{@message}\n\n"
  end

#
# = = END = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
