# to run this script, 
# $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby client_example.rb (CR)
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'

Quandl::Client.use 'http://quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

include Quandl::Client

attributes = {
  :source_code => 'LPG',
  :code => 'Code goes here',
  :name => 'Very Large LPG Carrier',
  :private => true,
  :description => 'This is the description of this dataset.'
}
d = Dataset.create(attributes)
d.data = [['2015-01-02', 3], ['2015-01-09', 4]]
d.save

# 
# In this case, find the databsase and rename the dataset
#
d = Dataset.find('LPG/TEST')
puts d.name
d.name = 'Very Large Liquid Propane Gas Carrier, Spot Contracts'
d.data = [['2015-01-02', 30], ['2015-01-09', 40], ['2015-01-16', 34], ['2015-01-23', 50]]

d.save

#d.destroy