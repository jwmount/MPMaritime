# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# CREATE THE DATASET OTNK/CRUDE
# How to run this script:
#         $ #!/usr/bin/env ruby -wKU
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

  code           = 'VLCC_TD3_DFPT'
  d              = nil
  source_code    = "OTNK"
  attributes = {
    :source_code  => source_code,   # root of database name
    :code         => code,          # dataset modifier of database name
    :column_names => ['Date', 'VLCC_TD3_TCE'],
    :data         => [],
    :frequency    => 'daily',
    :name         => 'VLCC’s - Arabian Gulf to Japan - Freight Expressed in $/ton carried',
    :private      => false,         # true do not show | false make visible
    :description  => "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations. These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America. These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan)."
  }
  # CREATE THE DATASET
  d              = Dataset.find("#{source_code}/#{code}")
  if d.name.nil?
    # NO NAME?  THEN IT DID NOT EXIST SO CREATE IT AND SAVE IT
    d            = Dataset.create(attributes)
    puts "\nCreated dataset #{attributes[:source_code]}/#{attributes[:code]}."
  else
    puts "\nWARNING:  Create dataset #{attributes[:source_code]}/#{attributes[:code]}--FAILED.\n"
    puts "#{d.errors}"
  end
  d.save
  puts "--done."