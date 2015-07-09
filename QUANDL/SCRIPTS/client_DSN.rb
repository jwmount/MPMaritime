# Change LPG dataset name
# to run this script, 
# $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby client_DSN.rb (CR)
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'
require 'quandl/pry'

Quandl::Client.use 'https://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

include Quandl::Client

binding.pry

=begin
# 
# In this case, find the databsase and rename the dataset
#
d = Dataset.find('LPG/LPG_M')
puts d.name
d.name = 'Spot Contracts'
puts d.name
d.save

#d.destroy
=end