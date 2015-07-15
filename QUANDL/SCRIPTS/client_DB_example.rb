# to run this script, 
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby client_DB_example.rb
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'
require 'pry'

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']
include Quandl::Client

#binding.pry

# Find by Database name, as in www.quandle.com/data/LPG_R
db = Quandl::Client::Source.find('LPG_F')
	
#binding.pry

db.name = 'Liquified Petroleum Gas (LPG) Fleet Statistics'
db.description = "Fleet Statistics by vessel class, updated weekly."

db.save
puts db.name + ' Found and modified.'

