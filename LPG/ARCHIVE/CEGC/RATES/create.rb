# #!/usr/local/bin/ruby
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby edit_C-EGC_FR.rb (CR)
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG    -- index
#         https://www.quandl.com/LPG/GC_FR  -- direct
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'csv'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']


# ATTRIBUTES will be created or set
  @code        = 'CEGC_FR'
  @column_names= ['Date', 'Spot Rates($/mo)']
  @data        = []
  @description = 'Coastal European Gas Carrier--Fully? Refrigerated? vessels, xx,600 cbm.'
  @file_in     = 'C-EGC_FR.csv'
  @frequency   = 'weekly'
  @name        = 'Coastal European Gas Carrier, Spot Rates'
  @source_code = 'LPG'

# CREATE THE DATASET LPG/VLGC_FR
  attributes = {
    :source_code  => @source_code,   # root of database name
    :code         => @code,          # dataset modifier of database name
    :column_names => @column_names,
    :data         => @data,
    :frequency    => @frequency,
    :name         => @name,
    #:private      => false,         # true do not show | false make visible
    :description  => @description #'Large Gas Carrier-- Fully Refrigerated vessels carrying 57,000 cbm to 84,000 cbm.'
  }
  d = Dataset.find("#{source_code}/#{code}")
  d.destroy

  begin
    @d = Dataset.create(@code)
    puts "---Found #{@d.code}."
  rescue
    puts "#{@code} not found, Create it."
    @d = Dataset.create(@attributes)
    puts "Created #{@d.code}."
  end
# CREATE THE DATASET LPG/VLGC_FR
# If does NOT exist, create it and then edit it.
# NOTE:  a create costs a half hour delay to recreate the entry in the index, go to the URL directly

# EDIT attribute values
  @d.source_code  = @source_code
  @d.code         = @code
  @d.column_names = @column_names
  @d.frequency    = @frequency
  @d.name         = @name
  @d.description  = @description

# READ CSV VERSION OF DATA AND LOAD TO DATASET
  CSV.foreach(@file_in) do |row|
    @data << [ row[0], row[1] ]
  end

  binding.pry

  @d.data = @data
# CONFIRM WHAT'S NOW IN DATASET
  @d.data.each {| a | puts "#{a[0]}, #{a[1]}" }
  puts "@code:        \t Saved #{@d.data.count}."
  puts 
  puts "source_code:  \t #{@d.source_code}."
  puts "code:         \t #{@d.code}."
  puts "column_names: \t #{@d.column_names}."
  puts "frequency:    \t #{@d.frequency}."
  puts "name:         \t #{@d.name}."
  puts "private:      \t #{@d.private}."
  puts "description:  \t #{@d.description}."


# SAVE IT TO QUANDL
  begin
    @d.save
    puts "Dataset:      \t #{@d.code} edited."
    puts
  rescue => e
    warn e.message
    puts "---update to #{@d.code} failed."
  end


#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
#
