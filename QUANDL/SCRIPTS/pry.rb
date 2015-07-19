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


desc = "Vessels nominally sized around 10,000 cbm. 
        <p>\n\nEthane is produced on an industrial scale from natural gas, and as a by-product of petroleum refining. Global ethane production was estimated at 55 million tons in 2013, the overwhelming majority in the Middle East and US.
        <p>The primary use of ethane is in the chemical industry in the production of ethylene, which in turn is used to produce polyethylene, PVC, ethylene glycol and styrene.
        <p>Historically, ethane has been transported in small liquefied ethane/ethylene carriers (LECs) designed and constructed to carry ethylene (boiling point -104°C) as well as ethane and other <i>normal</i> LPG cargoes. Currently there are only 29 LECs larger than 10,000 cbm, with the largest having a capacity of 22,000 cbm. 
        <p>See also <a href='www.quandl.com/data/LPG_R/ETHGC'>Liquified Ethane Carrier Fleet Statistics"

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