# #!/usr/local/bin/ruby
# CREATE THE DATASET OTNK/CRUDE
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby create.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Original attribute names
#         Date,TCE,PMT,$/bbl,Brent $,% Freight Cost

require 'quandl/client'
require 'csv'
require 'pry'

include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']


source_code = 'OTNK'
code        = 'S2015'

# if it exists, destroy it because this version creates it entirely.
# NOTE:  a d.destroy costs a half hour delay to recreate the entry in the index

  attributes = {
    :source_code  => source_code,   # root of database name
    :code         => code,          # dataset modifier of database name
    :column_names => ['Date', 'TCE','PMT','$/bbl','Brent($)', '%Freight($)'],
    :data         => [],
    :frequency    => 'daily',
    :name         => 'Crude Oil Metrics',
    :private      => false,          # true do not show | false make visible
    :description  => 'Crude oil price metrics.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy

# CREATE DATASET AND PUSH IT UP TO QUANDL
  d = Dataset.create(attributes)
  begin
    d.save
    puts "\n\nDataset #{d.source_code}/#{d.code} created."
  rescue => e
    puts "\n\n---update to #{d.code} failed."
    puts "\n#{d.errors}\n#{@message}"
  end
