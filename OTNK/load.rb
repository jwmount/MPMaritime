# #!/usr/local/bin/ruby
# load.rb -- load the dataset data
# Purpose:  Create dataset for small gas carrier, semi-refrigerated fleet.
# How to run this script:
#         $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
# 
require 'quandl/client'
require 'double_bag_ftps'
require 'csv'
require 'uri'
require 'pry'
include Quandl::Client
Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

  quandl_file = '_data.txt'

  ftps = DoubleBagFTPS.new
  ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
  ftps.connect('ftp.quandl.com')
  ftps.login('mpm', 'LRvq2uncjce4Uw')
  ftps.passive = true


  Dir.glob("DATA/*.csv").each do |filename|
    qc = []
    flag = false
    fl = File.open(quandl_file, 'a')

    CSV.foreach(filename) do |row| 
      flag = !flag                             if row[0] == 'Date'
      qc << row[1]                             if row[0].is_a? String and row[0].include? "Quandl:"
      puts "#{qc[0]} found and uploaded."      if row[0].is_a? String and row[0].include? "Quandl:"
      fl.puts (qc + row).join('|') + "\n"      if !qc.empty? and flag and row[0] != 'Date'
    end #CSV

    fl.close
    ftps.puttextfile(quandl_file, "data/#{quandl_file}") # keep a copy and send one to Quandl
   
  end #glob
  
  puts "--done."

