# #!/usr/local/bin/ruby
# edit.rb -- load the dataset with data
# Purpose:  Edit UI elements of fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby edit.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

  source_code  = 'OTNK'
  code         = 'CRUDE'
  d            = Dataset.find "#{source_code}/#{code}"

  #
  # EDIT attributes here
  #
  d.description = 'West Texas Intermediate (WTI) and the Brent indeces of crude oil prices.'

  d.name = 'Crude Oil Indexes'
  d.private = false;              # private determines if the database thumbnail appears or not.  No effect on permalink.
  d.save

  puts "Loaded #{d.source_code}/#{d.code}."
  puts "--done."