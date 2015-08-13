# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb colname1, colname2, ...
#         $ curl "https://www.quandl.com/api/v3/datasets/OTKR_R/VLCC_TD3_TCE.csv?api_key=Z_FgEe3SYywKzHT7myYr"
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Usage:  Steps to load .csv files to Quandl
#         1.  Put *_data*.csv and *_metadata*.csv files in /DATA folder.
#         2.  Execute ruby load.rb (see model command above)
# Features Needed:
#         1.  Some sort of logging facility, currently just writes qfl to QREADY folder.
#         2.  Skip if date in future.
#         3.  Capability to shift input folder or perhaps allow multiple folders, e.g. Quandl Master Folder in DropBox.
#         4.  q_metadata class does not handle comments, just has @flag
#
require 'quandl/client'
require 'double_bag_ftps'
require 'csv'
require 'uri'
require 'pry'

require './qftp.rb'
require './optex.rb'

include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

@data_count = 0
@meta_count = 0
@options = OptparseArguments.parse(ARGV)

# Handle the Quandl file name files, this processes _metadata before _data files.
["_metadata", "_data"].each do |fstem|
  puts "\n\n#{fstem} files"

  # prepare a filespec and process each file it covers  
  fspec = [@options.directory, '/*', fstem, '*.csv'].join
  Dir.glob(fspec).each do |f|

    qftp = Q_FTP.new f
    
    # next file in /DATA reservoir of _data and _metadata files
    qftp.set_filename( f )

      # Process file being prepared for Quandl, actual class will vary by file type
      qfl = qftp.process
      qfl.set_options(@options)

      next unless qfl.has_quandl_key?
      
      # compose the quandl file 
      qfl.compose (qftp.get_filename)
      
      # push the quandlfile to quandl
      qfl.push  if qfl.get_options[:send]
      qfl.wrap_up
  
  end # read files
end # Qdl file name look

#
# Wrap up -- varies by arguments set
#




