# Quandl test bed
# Note, can use command line pyy command using lines 7-13
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby pry.rb
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/<dbname>
# 
# Find by Database name, as in www.quandle.com/data/LPG_R
# db = Quandl::Client::Source.find('LPG_F')

require 'quandl/client'
require 'pry'

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

include Quandl::Client

desc = ""

vlgc   = Dataset.find('LPG_R/VLGC_FR')
lgc    = Dataset.find('LPG_R/LGC_FR')
mgc_fr = Dataset.find('LPG_R/MGC_FR')
mgc_sr = Dataset.find('LPG_R/MGC_SR')
smgc   = Dataset.find('LPG_R/SMGC_SR')
ethgc  = Dataset.find('LPG_R/ETHGC')
#d.description = desc
#cols = ['Date', '$/day']
binding.pry

d.save

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