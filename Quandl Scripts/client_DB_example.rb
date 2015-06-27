# to run this script, 
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby client_DB_example.rb (CR)
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'

Quandl::Client.use 'http://quandl.com/api/'
Quandl::Client.token = ENV['Z_FgEe3SYywKzHT7myYr']


include Quandl::Client

# Find by Database name, as in www.quandle.com/data/LPG
database = Source.find('LPG')
puts 'Old name: ' + database.name # Mpm LPG Placeholder
database.name = 'Liquid Propane Gas Carriers'
database.description = 'Spot and Longer term Charter Rates for Gas Carrying vessels, updated weekly.' 
database.save
puts 'New name: ' + database.name

