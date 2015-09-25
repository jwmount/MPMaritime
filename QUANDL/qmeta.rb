# qmeta.rb -- Quandl _metadata files.
# If _metadata:  look for Quandl: key, if present, use as Quandl Code
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

# Notes for _medatdata file handling

require 'date'
require 'pry'

# Remove embed dbl quotes, not allowed by Quandl
class String
  def to_Qdl
    gsub /\"/,"'"
  end
end #String
class Array
  def to_q
    compact!
  end
end #Array

#
# Q_data =========================================
# 
#
# CLASS Q_Metadata ==========================================
#
class Q_metadata < Q_FTP

  @rows = 0
  @options = nil

  def initialize( f )
    super( f )
  end

  def set_options o
    @options = o
  end

  def get_options
    @options
  end
  
  def compose f

    @quandl_metadata_hdr = "Quandl Code|Name|Description"  

    
    # file to write
    @qdl_filespec = f.gsub(".csv", ".txt")
    fout = File.open( @qdl_filespec, 'w' )
 
    CSV.foreach( f ) do |row| 

      # Skip blank row or comments
      next if row.empty? or row[0].include?('#')  
      puts row.to_s if get_options[:verbose]
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

