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
def say(word)
  require 'debug'
  puts word + ' to begin debugging.'
end
#say 'Time'

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
    return Q_kids.new(f)          if f.include?( '_kids' )
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

