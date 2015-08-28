# qdata.rb -- Quandl Load _data files.
# If _data:  look for Quandl: key, if present, use as Quandl Code
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

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
    @options = o
  end

  def get_options
    @options
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

