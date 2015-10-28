# Quandl test bed
# Note, can use command line pyy command using lines 7-13
# 
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/<dbname>
#         QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby pry.rb
# 
# Find by Database name, as in www.quandle.com/data/LPG_R
# db = Quandl::Client::Source.find('LPG_F')

require 'quandl/client'
require 'pry'

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

include Quandl::Client
d = Dataset.find('MPM_04/VLCC_TD3_TEST')
puts d.description
d.save

if d.errors.any?
	puts d.errors
    puts d.error_messages
else
	puts "No errors."
end

