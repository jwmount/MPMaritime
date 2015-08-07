# qftp.rb -- Quandl FTP Load objects.
# File types determined by '_data' or '_metadata' strings in filename
# If _data:  look for Quandl: key, if present, use as Quandl Code
# If _metadata: 'Quandl Code' s/b in 1st row, rest is content
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

require 'date'
require 'pry'

# Remove embed dbl quotes, not allowed by Quandl
class String
  def to_Qdl
    gsub /\"/,"'"
  end
end
#
# CLASS Q_FTP ===========================================
#
class Q_FTP

  @filename = ''

  def initialize( f )

    set_filename( f )
    @count = 0
    @ftps = DoubleBagFTPS.new
    @ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
    @ftps.connect('ftp.quandl.com')
    @ftps.login('mpm', 'LRvq2uncjce4Uw')
    @ftps.passive = true

    puts "\n\n\nCreate Quandl Demo\t\t\t#{$0}\n________________________________________________________"
    puts "(c) Copyright 2009 VenueSoftware Corp. All Rights Reserved. \n\n"
  end

  def get_ftps
    @ftps
  end

  # local file name, resides in DATA and is .csv.
  def set_filename( f )
    @filename = f
    puts "\t#{f}"
  end

  def get_filename
    @filename
  end

  def get_qfilename
    f  = get_filename
    fn = f.gsub(/DATA\//,'data/')
    fn = fn.gsub!(/.csv/,'.txt')
  end

  def get_ready_filename
    f  = get_filename
    fn = f.gsub(/DATA\//,'QREADY/')
    fn = fn.gsub!(/.csv/,'.txt')
  end

  def process
    f = get_filename
    puts "\n\tProcess: #{f}\n"
    return Q_data.new(f)          if f.include?( '_data' )
    return Q_metadata.new(f)      if f.include?( '_metadata' )
    nil
  end

  # original file is @filename now, e.g. 
  # "DATA/_dataETHGC Rates Master Sheet.csv"
  def push

    begin
      # send to quandle.ftp.com, from_file, to_file
      ftps = get_ftps
      ftps.puttextfile( get_ready_filename, get_qfilename )  
      puts "\tPushed: #{get_ready_filename} to #{get_qfilename}"
    rescue Exception => e
      puts "\n\tFAILED to push #{get_ready_filename} to #{get_qfilename} on Quandl.\t\t\t#{$0}\n\n_____________________________________________________"
      puts e
    end
  end

end # class Q_FTP

#
# CLASS Q_Metadata ==========================================
#
class Q_metadata < Q_FTP

  @filename = ''

  def initialize( f )
    super( f )
  end

  def push
    super 
  end

  def compose( fn )

    @quandl_metadata_hdr = "Quandl Code|Name|Description"  

    # filename to write
    qrfn   = fn.gsub(/DATA\//,'QREADY/')
    qrfn   = qrfn.gsub!(/.csv/,'.txt')
    # file to write
    fout   = File.open( qrfn, 'w' )
 
    CSV.foreach( fn ) do |row| 
      next if row.empty? or row[0].include?('#')  # Skip blank row or comments
      puts "\t" + row.to_s
      fout.puts (row).join('|') + "\n"
     end #CSV

    fout.close
  end

  def wrap_up
  end

end # Q_metadata

#
# Q_data =========================================
# 
class Q_data < Q_FTP

  @filename = ''

  def initialize( f )
    set_filename f
    super f
  end

  def set_filename f
    @filename = f
  end

  def push
    super
  end

  # Composes the Quandle formated version of the DATA/*.csv file
  def compose( fn )

    @flag = false
    @quandl_data_hdr = "Quandl Code|Date|Value"  

    qc = []
    qfilename = @filename.gsub(/DATA\//,'QREADY/')
    qfilename = qfilename.gsub!(/.csv/,'.txt')
  
    fl = File.open(qfilename, 'w')
    fl.puts @quandl_data_hdr 
  
    # Read and handle each row of the file
    CSV.foreach(fn) do |row| 
      next if row.empty? or row.include?('#')   # Skip blank or comment row
      puts "\t" + row.to_s
      # strip out double quote characters 
      row.each do |r|
        r.to_Qdl unless r.nil?
      end

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
        dt = row[0].gsub('/','-')
      rescue
        puts "\tInvalid date: #{dt}; skipped row."
        next
      end
    
      # construct line as array joined with '|'
      line = [ qc, dt, row[1..row.count] ]
      fl.puts (line).join('|') + "\n" #     if !qc.empty? and @flag and row[0] != 'Date'

    end #CSV
    fl.close
  end

  def wrap_up
  end

end
