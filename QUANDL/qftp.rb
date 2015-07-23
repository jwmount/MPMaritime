# qftp.rb -- Quandl FTP Load objects.
# File types determined by '_data' or '_metadata' strings in filename
# If _data:  look for Quandl: key, if present, use as Quandl Code
# If _metadata: 'Quandl Code' s/b in 1st row, rest is content
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
require 'pry'

class Q_data

  @fn = ''
  @qfilename = ''

  def initialize
  end

  def compose(fn)
    @flag = false
    @quandl_data_hdr = "Quandl Code|Date|Value"  

    qc = []
    @qfilename = fn.gsub(/DATA\//,'./QREADY/')
    @qfilename = @qfilename.gsub!(/.csv/,'.txt')

    fl = File.open(@qfilename, 'w')
    fl.puts @quandl_data_hdr 
  
    CSV.foreach(fn) do |row| 
      if !@flag and row[0] == 'Date'
        @flag = !@flag                           
        next unless @flag
      end
      puts "\t" + row.to_s
      qc << row[1]                             if row[0].is_a? String and row[0].include? "Quandl:"
      fl.puts (qc + row).join('|') + "\n"      if !qc.empty? and @flag and row[0] != 'Date'
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
  @fn = ''
  @flag = false
  @qfilename = ''

  def initialize
  end

  def compose(fn)
    @flag = false

    qc = []
    @qfilename = fn.gsub(/DATA\//,'./QREADY/')
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
    puts 'Close _data'
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
    puts "\nProcess #{@fn}\n"
    return Q_data.new()          if @fn.include?( '_data' )
    return Q_metadata.new()      if @fn.include?( '_metadata' )
    nil
  end

  def push( qfl )
    begin
      @ftps.puttextfile(qfl, "data/#{qfl}") # keep a copy and send one to Quandl
      puts "\tpushed #{qfl}"
    rescue
      puts e.name
    end
  end

  def wrap_up
    puts "\nCompleted Quandl Load\t\t\t#{$0}\n\n________________________________________________________"
  end
    

end # class QdlDB
