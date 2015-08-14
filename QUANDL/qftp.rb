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
  def to_mask
  end
end
#
# CLASS Q_FTP ===========================================
#
class Q_FTP

  @filename = ''

  def initialize( f )

    #puts "\n\n\nLoad Quandl Dataset\t\t\t#{$0}\n________________________________________________________"
    set_filename( f )
    @ftps = DoubleBagFTPS.new
    @ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
    @ftps.connect('ftp.quandl.com')
    @ftps.login('mpm', 'LRvq2uncjce4Uw')
    @ftps.passive = true

  end

  def get_ftps
    @ftps
  end

  # local file name, resides in DATA and is .csv.
  def set_filename( f )
    @filename = f
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
    puts "\nProcess: #{f}\n"
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

  # Verify that file contains a Quandl: key, FAIL & next if not.
  def has_quandl_key? f=get_filename
    s = File.new( get_filename ).gets
    flag = s.include?('Quandl:')
    puts "\nFAIL, NO QUANDL KEY FOUND in #{f}.  Not processed.\n\n" unless flag
    flag
  end

  def wrap_up
    puts "\nDone. \n_______________________________________\n"
    puts "(c) Copyright 2009 VenueSoftware Corp. All Rights Reserved. \n\n"

  end

end # class Q_FTP

#
# CLASS Q_Metadata ==========================================
#
class Q_metadata < Q_FTP

  @filename = ''
  @options = nil
  @sent = 0

  def initialize( f )
    super( f )
  end

  def inc_sent
    @sent += 1
  end

  def get_sent
    @sent
  end

  def set_options o
    @options = open
  end

  def get_options
    @options
  end
  
  def push
    super if get_options[:send]
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
      puts "\t" + row.to_s if get_options[:verbose]
      fout.puts (row).join('|') + "\n"
     end #CSV

    fout.close
  end

  def has_quandl_key?
    true                   # actually doesn't need it
  end

  def wrap_up
    puts "Sent #{get_sent} _metadata files."
    super
  end

end # Q_metadata

