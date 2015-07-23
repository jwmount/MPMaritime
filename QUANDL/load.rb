# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Features Needed:
#         1.  Message if there are no files to process; number of files processed
#         2.  Quandl key 'Quandl:' not found; message and drop file, count as not processed; malformed
#         3.  Some sort of logging facility
#         4.  Skip if date in future
#         5.  Add capability to do multi-column loads needed for LPG_F Datasets.
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

# quandl ftp object, argument is average number of datasets to create, future feater
qftp = Q_FTP.new

  Dir.glob("DATA/*.csv").each do |filename|

    # next file in /DATA reservoir of _data and _metadata files
    qftp.set_filename( filename )

      # quandl file, actual class will vary by file type
      qfl = qftp.process
      # compose the quandl file 
      qfl.compose(qftp.get_filename)

    # push the quandlfile to quandl
    puts qfl.get_qfilename
    qftp.push(qfl.get_qfilename)

  end # files

qftp.wrap_up

