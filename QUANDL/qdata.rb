
# D E P R E C A T E D  09/09/15
#qdata.rb -- Quandl Load _data files.
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
class Q_data < Q_FTP

  # Instance variables
  @options = nil
  @sent = 0
  
  def initialize( f )
    set_filename f
    inc_sent
    super f
  end

  # for each item in hdr that's not nil, save the index in @selection
  def set_selection_list r
    @selection = []
    r.each_with_index do |item, i|
      @selection << i unless item.nil?    
    end
  end

  def inc_sent
    @sent ||= +1
  end

  def get_sent
    @sent
  end

  def set_filename f
    @filename = f
  end

  # from load.rb @options for use here
  def set_options o
    @options = o
  end

  def get_options
    @options
  end

  # Composes the Quandle formated version of the DATA/*.csv file
  def compose( fn )

    @flag = false

    qc = []
    dir = get_options.directory
  
    #qfilename = @filename.gsub( "#{dir}",'QREADY' )
    #qfilename = qfilename.gsub!( ".csv", ".txt" )

    # Open the output file
    fl = File.open(@collection_location, 'w')
  
    # Read and handle each row of the file
    CSV.foreach(@current_location) do |row| 

      next if row.empty? or row.include?('#')   # Skip blank or comment row
      puts row.to_s if get_options[:verbose]
      # strip out double quote characters 
      row.each do |r|
        r.to_Qdl unless r.nil?
      end

      # capture the Quandl code and skip line
      if row[0].is_a? String and row[0].include? "Quandl:"
        qc << row[1]           
        next
      end
      
      # HDR row (MASK)
      # turn on flag if a string and value of first word is 'Date'
      # Remove nil elements in row using .compact!
      # Then compose the output line as '|' columns
      if row[0].is_a? String and row[0] == "Date"
        @flag = !@flag
        set_selection_list row
        row.compact!
        fl.puts ["Quandl Code", "Date", row[1..row.count]].join('|')
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
        puts "Invalid date: #{dt}; skipped row."
        next
      end
    
      # construct output row as array joined with '|'
      # we have Date, nil, nil, PMT, ... TCE, nil, ... nil, nil...
      # we want 0,3,9
      # to get  Date|PMT|TCE

      @line = []
      @selection.each_with_index { |i| @line << row[i] }
      fl.puts [qc, @line].join("|")
      #fl.puts [qc,row[0..row.count]].join('|')

    end #CSV
    fl.close
  end

  def has_quandl_key?
    true                   # actually doesn't need it
  end

  # If we have ARGV values, setup column selector array
  # imagine, [1,3,6] are the ones we want

  def wrap_up
    puts "Sent #{get_sent} _data files."
    super
  end

end
