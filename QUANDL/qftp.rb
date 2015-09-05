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

  # Input file being processed for any of the file type objects
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

  # File being processed, any type but must end in .csv
  def get_filename
    @filename
  end

  # File prepared for Quandl, contains either _data or _metadata, ends .txt
  def get_qfilespec
    f  = get_filename
    fn = f.gsub(/DATA\//,'data/')
    fn = fn.gsub!(/.csv/,'.txt')
  end

  # File actually put to Quandl ftp server, is /data/<qfilename>
  def Xget_ready_filename
    f  = get_filename
    #fn = f.gsub(/DATA\//,'QREADY/')
    fn = fn.gsub!(/.csv/,'.txt')
  end

  # Find the file spec to push to on Quandl side, ie remote
  # Remove overburden which here is: /Users/John/DropBox/PRODUCTION/
  # HACK:  breaks if @options[:directory is NOT SET]
  def get_rfilespec
    #f = @qfilename.gsub("/Users/John/DropBox/PRODUCTION/", '')
    f = get_qfilespec.gsub(@options[:directory], '')
    ["data", f].join
  end

  def process
    f = get_filename
    puts "#{f}"
    return Q_data.new(f)          if f.include?( '_data' )
    return Q_metadata.new(f)      if f.include?( '_metadata' )
    return Q_kids.new(f)          if f.include?( '_kids' )
    # no stem, use default 
    return Q_prod.new(f)
  end

  # Log what happened when file was pushed
  # Extract the filename and make it a constant or something
  def addToLog flag
    result = flag ? 'Succeeded' : 'Failed'
    File.open("/Users/John/DropBox/datasets_processed.log", 'a') do |f| 
      dt = DateTime.now.strftime("%Y-%b-%d %H:%M:%S")
      fn = get_filename.gsub!("/Users/John/DropBox/PRODUCTION", "")
      result = flag ? 'Suceeded' : 'Failed'
      line = [dt, fn, result].join(',')
      f.write("#{line}\n") 
    end
  end

  # original file is @filename now, e.g. 
  # "VLCC_TD3_DBBL_data.txt"
  def push 
    begin
      # send to quandle.ftp.com, from_file, to_file
      ftps = get_ftps
      ftps.puttextfile( get_qfilespec, get_rfilespec )  
      puts "Push From:\t #{get_qfilespec}"
      puts "Push To:\t #{get_rfilespec}\n"
      addToLog true
    rescue Exception => e
      puts "\nFAILED to push #{get_qfilespec} to #{get_rfilespec} on Quandl.\t\t\t#{$0}\n\n_____________________________________________________"
      puts "Reason: #{e}"
      addToLog false
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
    puts "\nDone. \n_________________________________________________\n"
    puts "(c) Copyright 2015 VenueSoftware Corp. All Rights Reserved. \n\n"

  end

end # class Q_FTP

