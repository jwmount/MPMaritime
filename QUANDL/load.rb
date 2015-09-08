#!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb -p -d /Users/John/DropBox/PRODUCTION -s -v
#         $ curl "https://www.quandl.com/api/v3/datasets/OTKR_R/VLCC_TD3_TCE.csv?api_key=Z_FgEe3SYywKzHT7myYr"
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Usage:  Steps to load .csv files to Quandl
#         1.  Put *_data*.csv and *_metadata*.csv files in collection folder.  
#             -d to change the source folder
#             -p put them in -d, and use -d /Users/John/DropBox/PRODUCTION in load command
#         2.  Execute ruby load.rb (see model command above)
#         3.  Remove unwanted columns by removing hdr column names
#             Example:  names Alpha, Beta, Charley and you don't want Beta, use
#                       Alpha,,Charley
#         4.  To rename columns to work better as legends, rename them, e.g.
#             Example:  Alpha, $/bbl, Charley
#             Rename columns in *_metadata*.csv and or using -c option on command line
#         5.  Load will always process contents of folder.  So focus on a 
#             specific file, put it alone in a target directory,
#             Example 1:  $ load.rb -d SpecialData
#             Example 2:  $ load.rb -d PRODUCTION -p 
#         6.  Process files of a type, e.g. VLCC
#             Example 1:  $ load.rb -f VLCC
#             Example 2:  $ load.rb -d /Users/John/DropBox/PRODUCTION -p -f VLCC 
#         7.  To see other command line parameters, load.rb -h or load.rb --help
#         8.  To sweep collection folder every 10 minutes, -i 600
# Features Needed:
#         1.  Skip if date in future.
# Definitions
#         @filename            Name of file being processed, e.g. _dataSomeFile.csv
#                              Class or Format identifiers, e.g. _kids, _data_kidsBill715.csv
#         @qfilespec           Quandl formatted filespec, e.g. /Users/John/DropBox/_dataSomeFile.txt
#         @rfilespec           Name delivered to Quandl, e.g. data/_dataSomeFile.txt
#
require 'quandl/client'
require 'double_bag_ftps'
require 'csv'
require 'uri'
require 'pry'

require './qftp.rb'
require './qdata.rb'
require './optex.rb'
require './qkids.rb'
require './qmeta.rb'
require './qprod.rb'

include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

#
# Ruby Debug class,  to use, uncomment say() and have at it.  
#
def say(word)
  require 'debug'
  puts word + ' to begin debugging.'
end
#say 'Time'



# Remove embed dbl quotes, not allowed by Quandl

@data_count   = 0
@meta_count   = 0
@identified_sources = ["_data", "_kids","_metadata"]
@prod_sources = ["prod"]
@options      = OptparseArguments.parse(ARGV)
@sources      = @options["production"] ? @prod_sources : @identified_sources

# Ask user to confirm options are set correctly
puts "\n\tReady? (Yes|n):"
answer = gets.chomp
exit unless answer == "Yes"
# Handle the Quandl file name files, this processes _metadata after _data files.

@sources.each do |fstem|

  puts "\n\n#{fstem} files"

  # Prepare a filespec and process each file it covers  
  # if the user has provided a spec to the command line, use that.
  #fspec = [@options.directory, '/*', fstem, '*.csv'].join : 
  
  # if -p is set use .csv files in PRODUCTION folder.
  # Process everything as _data.  Fail on anything that does not conform.
  if @options[:production]
    fspec = File.join(@options[:directory], "*.csv")

  # if -p is not set use files in /DATA and stems _data and _metadata.
  else
    fspec = @options[:file].nil? ? [@options.directory, '/', fstem, '*.csv'].join : \
          [@options.directory, '/', fstem, '*', @options[:file], '*.csv'].join
  end
  pp fspec                        if @options[:verbose]

    # File loop
    Dir.glob(fspec).each do |f|

      puts f                      if @options[:verbose]

      qftp = Q_FTP.new f
      
      # next file in /DATA reservoir of _data and _metadata files
      qftp.filename= f

        # Process file being prepared for Quandl, actual class will vary by file type
        qfl = qftp.process
        qfl.set_options(@options)

        next unless qfl.has_quandl_key?
      
        # compose the quandl file 
        qfl.compose f
      
        # push to quandl
        qfl.push  if @options[:send]

    end # File loop
  end # Qdl file name look

  wrapup
  exit
