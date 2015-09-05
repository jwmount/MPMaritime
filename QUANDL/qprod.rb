# qprod.rb -- Quandl Load .csv files found in DropBox/PRODUCTION
# Look for Quandl: key, if present, use as Quandl Code, else drop file.
# Only invoked if -p(rod) option is set.
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb -v -s -p -d /Users/John/DropBox/PRODUCTION
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
# Q_prod ====================================================================
# 
class Q_prod < Q_FTP

  # Instance variables
  @filename = ''
  @options = nil
  @sent = 0
  @existsDS = 0

  #say 'Time'
  
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

    # @qfilename is the file going to Quandl, must contain '_data' and be .csv
    @qfilename = fn.gsub( ".csv", "_data.txt" )

    # Open the output file
    fl = File.open( @qfilename, 'w' )
  
    # Read and handle each row of the file
    CSV.foreach(fn) do |row| 

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
      
      # Safety Precaution:  make sure Dataset exists
      @existsDS = createDS( qc ) unless @existsDS

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

  end

  # What file are we pushing to Quandl?
  def get_local_filename
    @qfilename
  end


  # If necessary, create the dataset, once, by setting @existsDS
  def createDS qc
    source_code = "OTKR_R"
    code = "VLCC_TD3_DBBL"
    attributes = {
      :source_code  => source_code,   # root of database name
      :code         => code,          # dataset modifier of database name
      :column_names => ['Date', '$/BBL'],
      :data         => [],
      :from_date    => "2000-01-04",
      :to_date      => "2015-06-04",
      :frequency    => 'daily',
      :name         => 't.b.s.',
      :private      => false,         # true do not show | false make visible
      :description  => 't.b.s.'
    }
    # FIND OR CREATE DATASET AND PUSH IT UP TO QUANDL
    d = Dataset.find("#{source_code}/#{code}")
    if d.name.nil?
      d = Dataset.create(attributes) 
      pp d
      pp d.errors
      pp d.error_messages
    end
    true
  end

  def has_quandl_key?
    true                   # actually doesn't need it
  end


end