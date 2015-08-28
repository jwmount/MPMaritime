#!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
#         $ curl "https://www.quandl.com/api/v3/datasets/OTKR_R/VLCC_TD3_TCE.csv?api_key=Z_FgEe3SYywKzHT7myYr"
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Usage:  Steps to load .csv files to Quandl
#         1.  Put *_data*.csv and *_metadata*.csv files in /DATA folder.
#         2.  Execute ruby load.rb (see model command above)
#         3.  Remove unwanted columns by removing hdr column names
#             Example:  names Alpha, Beta, Charley and you don't want Beta, use
#                       Alpha,,Charley
#         4.  To rename columns to work better as legends, rename them, e.g.
#             Example:  Alpha, $/bbl, Charley
#         5.  Load will always process contents of folder.  So o focus on a 
#             specific file, put it alone in a target directory,
#             Example:  $ load.rb -d SpecialData
#         6.  To see other command line parameters, load.rb -h or load.rb --help
# Features Needed:
#         1.  Some sort of logging facility, currently just writes qfl to QREADY folder.
#         2.  Skip if date in future.
#         3.  q_metadata class does not handle comments, just has @flag
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

include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

#
# Ruby Debug class,  to use, uncomment say and have at it.  
#
def say(word)
  require 'debug'
  puts word + ' to begin debugging.'
end
say 'Time'

# Remove embed dbl quotes, not allowed by Quandl

@data_count = 0
@meta_count = 0
@options    = OptparseArguments.parse(ARGV)

# Handle the Quandl file name files, this processes _metadata before _data files.
["_data", "_kids","_metadata"].each do |fstem|

  puts "\n\n#{fstem} files"

  # Prepare a filespec and process each file it covers  
  # if the user has provided a spec to the command line, use that.
  #fspec = [@options.directory, '/*', fstem, '*.csv'].join : 
  #fspec = @options[:file].nil? ? [@options.directory, '/', fstem, '*.csv'].join : \
  #        [@options.directory, '/', fstem, '*', @options[:file], '*.csv'].join
  # show user if requested
  #pp fspec                        if @options[:verbose]
  
  fspec = File.join("../SECTOR STATISTICS/**", "*.csv")
  Dir.glob(fspec).each do |f|
    puts f                        if @options[:verbose]

    qftp = Q_FTP.new f
    
    # next file in /DATA reservoir of _data and _metadata files
    qftp.set_filename( f )

      # Process file being prepared for Quandl, actual class will vary by file type
      qfl = qftp.process
      qfl.set_options(@options)

      next unless qfl.has_quandl_key?
      
      # compose the quandl file 
      qfl.compose (qftp.get_filename)
      
      # push to quandl
      qfl.push  if @options[:send]
      qfl.wrap_up
  
  end # read files
end # Qdl file name look

#
# Wrap up -- varies by arguments set
#




