# qftp.rb -- Quandl FTP Load objects.
# File types determined by '_data' or '_metadata' strings in filename
# If _data:  look for Quandl: key, if present, use as Quandl Code
# If _metadata: 'Quandl Code' s/b in 1st row, rest is content
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

require 'date'
require 'pry'

# Should do all the filenames this way!
class String
  
  def to_nuts
    '.nuts'
  end

  # Remove embed dbl quotes, not allowed by Quandl
  def to_Qdl
    gsub /\"/,"'"
  end
  # Reduce length of filespec for logging
  def to_unspec
    gsub "/Users/John", ""
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
    
    # instance variables
  
  def initialize( f )
    #puts "\n\n\nLoad Quandl Dataset\t\t\t#{$0}\n________________________________________________________"
    @filename=( f )      # file being read, e.g. /<path>/_dataSomeFile.csv

    @ftps = DoubleBagFTPS.new
    @ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
    @ftps.connect('ftp.quandl.com')
    @ftps.login('mpm', 'LRvq2uncjce4Uw')
    @ftps.passive = true
  end

# File being processed, any type but must end in .csv
  def filename=( f )
    @filename = f
  end

  def filename
    @filename
  end

  def get_ftps
    @ftps
  end

  # Find the file spec to push to on Quandl side, ie remote
  # Remove overburden which here is: /Users/John/DropBox/PRODUCTION/
  # HACK:  breaks if @options[:directory is NOT SET]
  def XXget_rfilespec
    f = get_qfilespec.gsub(@options[:directory], '')
    ["data", f].join
  end

  # SEQUENTIAL GLITCH HERE, must test for CSV type before qdl file type
  def process
    return Q_kids.new(@filename)          if @filename.include?( '_kids' )
    #return Q_data.new(@filename)          if @filename.include?( '_data' )
    return Q_metadata.new(@filename)      if @filename.include?( '_metadata' )
    # no stem, use default 
    return Q_prod.new(@filename)          if @filename.include?( '_data' )
    # none of the above
    return nil
  end

  # Log what happened when file was pushed
  # Extract the filename and make it a constant or something
  def addToLog flag
    result = flag ? 'Succeeded' : 'Failed'
    File.open("/Users/John/DropBox/datasets_processed.log", 'a') do |f| 
      dt = DateTime.now.strftime("%Y-%b-%d %H:%M:%S")
      result = flag ? 'Succeeded' : 'Failed'
      line = [dt, filename.to_unspec, @qc, @rows, result].join(', ')
      f.write("#{line}\n") 
    end
  end

  # original file is @filename now, e.g. 
  # "VLCC_TD3_DBBL_data.txt"
  def push
    puts "Push From:\t #{@qdl_filespec}"  if @options[:verbose]
    #qdl_ready_filespec = @qdl_filespec.gsub("DATA","data").gsub(".csv",".txt")
    qdl_ready_filespec = @qdl_filespec.gsub(@options[:directory],"data").gsub(".csv",".txt")
    begin
      # send to quandle.ftp.com, from_file, to_file
      ftps = get_ftps
      ftps.puttextfile( @qdl_filespec, qdl_ready_filespec )  
      puts "Push To:\t #{qdl_ready_filespec}\n"
      addToLog true
    rescue Exception => e
      puts "\nFAILED to push #{@qdl_filespec} to #{qdl_ready_filespec} on Quandl.\t\t\t#{$0}\n\n_____________________________________________________"
      puts "Reason: #{e}"
      addToLog false
    end

  end #push

  # Verify that file contains a Quandl: key, FAIL & next if not.
  def has_quandl_key? f=get_filename
    s = File.new( @filename ).gets
    flag = s.include?('Quandl:')
    puts "\nFAIL, NO QUANDL KEY FOUND in #{f}.  Not processed.\n\n" unless flag
    flag
  end

  def wrap_up
    puts "\nDone. \n_________________________________________________\n"
    puts "(c) Copyright 2015 VenueSoftware Corp. All Rights Reserved. \n\n"

  end

end # class Q_FTP

