# #!/usr/local/bin/ruby
# loadDemos.rb -- load the demo DB set with Datasets via ftps
# Purpose:  Create simiulated product.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby loadDemos.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# Features Needed:
#
require 'quandl/client'
require 'double_bag_ftps'
require 'uri'
require 'pry'
require './QdlDBClass.rb'

include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

class QDB < QdlDBClass  

  @count = 0
  #@db_name = ''

  def initialize( avg_no_dss)
    super( avg_no_dss)
  end

  def getDB_list
    db_list = {}
    File.readlines("_meta_DB_list.txt").each do |line|
    	a = line.split(',')
    	@db_name = a[0] 
    	db_list.merge!( Hash[ a[1] , a[2] ] )
    end
    puts db_list
  end

end # class QDB

qdb = QDB.new( 6 )
qdb.getDB_list

