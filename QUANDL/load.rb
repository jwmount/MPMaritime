# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Usage:  Steps to load .csv files to Quandl
#         1.  Put *_data*.csv and *_metadata*.csv in /DATA folder.
#         2.  Execute ruby load.rb (see model command above)
# Features Needed:
#         1.  Message if there are no files to process; number of files processed
#         2.  Quandl key 'Quandl:' not found; message and drop file, count as not processed; malformed
#         3.  Some sort of logging facility, currently just writes qfl to QREADY folder.
#         4.  Skip if date in future.
#         5.  Add capability to do multi-column loads needed for LPG_F Datasets.
#         6.  Capability to shift input folder or perhaps allow multiple folders, e.g. Quandl Master Folder in DropBox.
#         7.  q_metadata class does not handle comments, just has @flag
#
require 'quandl/client'
require 'double_bag_ftps'
require 'csv'
require 'uri'
require 'pry'

require './qftp.rb'

include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']


@count = 0

# Handle the Quandl file name files, this processes _metadata before _data files.
["_metadata", "_data"].each do |fstem|
  puts "\n\n#{fstem} files --------------------------\n"

  Dir.glob("DATA/*#{fstem}*.csv").each do |f|

    qftp = Q_FTP.new f
    @count += 1
    # next file in /DATA reservoir of _data and _metadata files
    qftp.set_filename( f )

      # Process file being prepared for Quandl, actual class will vary by file type
      qfl = qftp.process
     
      # compose the quandl file 
      qfl.compose (qftp.get_filename)
      
      # push the quandlfile to quandl
      qfl.push
      qfl.wrap_up
  
  end # files
end # Qdl file name look

puts "\nCompleted load to Quandle, loaded #{@count} files\n_______________________________________\n"


