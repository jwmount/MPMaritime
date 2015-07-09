# to run this script, 
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby client_DB_example.rb
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'
require 'pry'

Quandl::Client.use 'https://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']


include Quandl::Client

binding.pry

# Find by Database name, as in www.quandle.com/data/LPG_R
database = Source.find('LPG_R')
database.name = 'Liquid Propane Gas Carriers'
database.description = 'Spot and Longer term Charter Rates for Gas Carrying vessels, updated weekly x.' 
database.save
puts 'New name: ' + database.name

