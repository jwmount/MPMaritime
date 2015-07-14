# Quandl test bed
# Note, can use command line pyy command using lines 7-13
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby pry.rb
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/<dbname>
# 
require 'quandl/client'
require 'pry'

Quandl::Client.use 'https://www.quandl.com/api/'
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