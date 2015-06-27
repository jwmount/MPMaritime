# to run this script, 
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby editDB.rb
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'
require 'pry'
Quandl::Client.use 'https://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

include Quandl::Client

# Find by Database name, as in www.quandle.com/data/LPG
database = Source.find('Oil Tankers')
puts "Old name:  #{database.name}" # Mpm LPG Placeholder
database.name = 'OTNK'
database.description = 'Crude and related  tankers, updated daily.' 
database.save
puts 'New name: ' + database.name

