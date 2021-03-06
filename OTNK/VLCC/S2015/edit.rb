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
  code         = 'S2015'
  d            = Dataset.find "#{source_code}/#{code}"

  # REMOVE FOR NOW, July 2
  d.destroy
  code = 'CRUDE'
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy
  binding.pry #exit via this

  #
  # EDIT attributes below here
  #
  d.description = 'Selected crude oil price metrics from 2000.'

  d.name = 'Crude Oil Price Metrics'
  d.private = false
  
  d.save

  puts "Edited #{d.source_code}/#{d.code}."
  puts "--done."