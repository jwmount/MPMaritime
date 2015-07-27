# qftp.rb -- Quandl FTP Load objects.
# File types determined by '_data' or '_metadata' strings in filename
# If _data:  look for Quandl: key, if present, use as Quandl Code
# If _metadata: 'Quandl Code' s/b in 1st row, rest is content
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

require 'Date'
require 'pry'

#
# CLASS Q_FTP ===========================================
#
class Q_FTP

  @ftps = nil
  @filename = ''

  def initialize
    @count = 0
    @ftps = DoubleBagFTPS.new
    @ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
    @ftps.connect('ftp.quandl.com')
    @ftps.login('mpm', 'LRvq2uncjce4Uw')
    @ftps.passive = true

    puts "\n\n\nCreate Quandl Demo\t\t\t#{$0}\n________________________________________________________"
    puts "(c) Copyright 2009 VenueSoftware Corp. All Rights Reserved. \n\n"
  end

  # local file name, resides in DATA and is .csv.
  def set_filename( f )
    @filename = f
    puts "\t" + @filename
  end

  def get_filename
    @filename
  end

  def get_qfilename
    fn = @filename.gsub(/DATA\//,'data/')
    fn = fn.gsub!(/.csv/,'.txt')
  end

  def get_ready_filename
    fn = get_filename
    fn = fn.gsub!(/DATA\//,'READY/')
    fn = fn.gsub!(/.csv/,'.txt')
  end

  def process
    fn = get_filename
    puts "\n\tProcess: #{fn}\n"
    return Q_data.new(fn)          if fn.include?( '_data' )
    return Q_metadata.new(fn)      if fn.include?( '_metadata' )
    nil
  end

  # original file is @filename now, e.g. 
  # "DATA/_dataETHGC Rates Master Sheet.csv"
  def push
    begin
      # send qfilename file to quandl, d
      @ftps.puttextfile( get_qfilename, get_ready_filename)  
      puts "\tPushed: #{fn}"
    rescue Exception => e
      puts "\nFAILED on push #{get_qfilename} to #{get_qfilename} on Quandl.\t\t\t#{$0}\n\n_____________________________________________________"
      puts e
    end
  end

  def wrap_up count
    puts "\nCompleted #{count} Quandl Loads\tat #{Time.now.to_s}\t\t#{$0}\n________________________________________________________\n\n"
  end

end # class Q_FTP

#
# CLASS Q_Meta ==========================================
#
class Q_metadata < Q_FTP

  @filename = ''

  def initialize( filename )
    @filename = filename
  end


  def push
    super 
  end

  def compose(fn)

    qrfn = fn.gsub(/DATA\//,'QREADY/')
    qrfn = @qfilename.gsub!(/.csv/,'.txt')

    fl = File.open( qrfn, 'w' )
  
    CSV.foreach(fl) do |row| 
      puts "\t" + row.to_s
      @flag = !@flag                      if row[0] == 'Quandl Code'
      fl.puts (row).join('|') + "\n"      if @flag #and row[0] != 'Date'
     end #CSV

    fl.close
  end

  def wrap_up count
    puts "\tCompleted #{@qfilename}."
  end
end # Q_metadata

#
# Q_data =========================================
# 
class Q_data < Q_FTP

  @filename = ''

  def initialize( filename )
    @filename = filename
  end

  def push
    super
  end

  # Composes the Quandle formated version of the DATA/*.csv file
  def compose(fn)

    @flag = false
    @quandl_data_hdr = "Quandl Code|Date|Value"  

    qc = []
    qfilename = @filename.gsub(/DATA\//,'QREADY/')
    qfilename = qfilename.gsub!(/.csv/,'.txt')
  
     fl = File.open(qfilename, 'w')
    fl.puts @quandl_data_hdr 
  
    # Read and handle each row of the file
    CSV.foreach(fn) do |row| 
      # put row on command line as visual record
      puts "\t" + row.to_s

      # capture the Quandl code and skip line
      if row[0].is_a? String and row[0].include? "Quandl:"
        qc << row[1]               
        next
      end
      
      # turn flag on if a string and value of first word is 'Date'
      if row[0].is_a? String and row[0] == "Date"
        @flag = !@flag
        next
      end

      # skip line until either 'Quandl:' or 'Date'
      unless @flag
        next
      end

      # this is data so construct the Quandl structured row and put in fl
      begin
        dt = Date.parse( row[0] )
      rescue
        puts 'Invalid date, skipped row'
        next
      end

      # construct line as array joined with '|'
      line = [ qc, dt, row[1..row.count] ]
      fl.puts (line).join('|') + "\n" #     if !qc.empty? and @flag and row[0] != 'Date'

    end #CSV
    fl.close
  end

  def wrap_up count
    super count
  end

end
