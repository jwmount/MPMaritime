# qftp.rb -- Quandl FTP Load objects.
# File types determined by '_data' or '_metadata' strings in filename
# If _data:  look for Quandl: key, if present, use as Quandl Code
# If _metadata: 'Quandl Code' s/b in 1st row, rest is content
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

require 'Date'
require 'pry'

class Q_data

  #@fn = ''
  @qfilename = ''
  
  def get_qfilename
    @qfilename
  end

  def compose(fn)

    @flag = false
    @quandl_data_hdr = "Quandl Code|Date|Value"  

    qc = []
    @qfilename = fn.gsub(/DATA\//,'QREADY/')
    @qfilename = @qfilename.gsub!(/.csv/,'.txt')

    fl = File.open(@qfilename, 'w')
    fl.puts @quandl_data_hdr 
  
    CSV.foreach(fn) do |row| 
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

  def get_qfilename
    @qfilename
  end

  def wrap_up
    puts fl.get.to_s
    puts 'Close _data'
  end

end
#
# CLASS Q_Meta ==========================================
#
class Q_metadata
  #@fn = ''
  @qfilename = ''

  def initialize
  end

  def compose(fn)
    @flag = false

    @qfilename = fn.gsub(/DATA\//,'QREADY/')
    @qfilename = @qfilename.gsub!(/.csv/,'.txt')

    fl = File.open(@qfilename, 'w')
  
    CSV.foreach(fn) do |row| 
      puts "\t" + row.to_s
      @flag = !@flag                      if row[0] == 'Quandl Code'
      fl.puts (row).join('|') + "\n"      if @flag #and row[0] != 'Date'
     end #CSV

    fl.close
  end

  def get_qfilename
    @qfilename
  end

  def wrap_up
    puts 'Close _metadata'
    super
  end
end # Q_metadata

#
# CLASS Q_FTP ===========================================
#
class Q_FTP

  @fn = ''
  @f = ""
  @ft = ''
  @ftps = nil

  def initialize
    @ftps = DoubleBagFTPS.new
    @ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
    @ftps.connect('ftp.quandl.com')
    @ftps.login('mpm', 'LRvq2uncjce4Uw')
    @ftps.passive = true
#    @ftps.debug_mode = true

    puts "\n\n\nCreate Quandl Demo\t\t\t#{$0}\n________________________________________________________"
    puts "(c) Copyright 2009 VenueSoftware Corp. All Rights Reserved. \n\n"
  end

  def set_filename( fn )
    @fn = fn
  end

  def get_filename
    @fn
  end

  def process
    puts "\n\tProcess: #{@fn}\n"
    return Q_data.new()          if @fn.include?( '_data' )
    return Q_metadata.new()      if @fn.include?( '_metadata' )
    nil
  end

  def push( qfl )

    begin
#      @ftps.puttextfile(qfl, "data/#{qfl}") # keep a copy and send one to Quandl
      # push from loalfile to remote_file
      @fn.gsub!(/DATA/,'data')
      @ftps.puttextfile( qfl, @fn )  # keep a copy and send one to Quandl"
      puts "\tPushed #{qfl}"
    rescue Exception => e
      puts "\nFAILED on push #{qfl} to #{@fn} on Quandl.\t\t\t#{$0}\n\n_____________________________________________________"
      puts e
    end
  end

  def wrap_up
    puts "\nCompleted Quandl Load\tat #{Time.now.to_s}\t\t#{$0}\n________________________________________________________\n\n"
  end
    

end # class QdlDB
