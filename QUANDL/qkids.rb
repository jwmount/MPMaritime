# kdata.rb -- Quandl Load _kids files.
# If _kids:  look for Quandl: key, if present, use as Quandl Code
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

require 'quandl/client'
require 'date'
require 'pry'
require 'csv'

def say(word)
  require 'debug'
  puts word + ' to begin debugging.'
end
say 'Time'

class String
  # create a Quandl conforming date from Kidsat format135
  def to_Qdt
    a = self.split('/')
    mm = "%02d" % a[0]
    dd = "%02d" % a[1]
    yyyy = ["20", a[2]].join
    [yyyy,mm,dd].join('-')
  end
end #String

#
# Q_kids =========================================
# 
class Q_kids < Q_FTP

  # Instance variables
  @filename = ''
  @options = nil
  @sent = 0
  
  def initialize( f )
    set_filename f
    inc_sent
    super f
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

  def push
    super
  end
  
  # Composes the Quandle formated version of the DATA/*.csv file
  def compose( fn )

    @flag = false

    qc = []
    dir = get_options.directory
  
    qfilename = @filename.gsub( "#{dir}",'QREADY' )
    qfilename = qfilename.gsub!( "_kids", "_data")
    qfilename = qfilename.gsub!( ".csv", ".txt" )

    # Open the output file
    fl = File.open(qfilename, 'w')
  

    # Read and handle each row of the file
    CSV.foreach(fn) do |row| 
      
      # Skip blank or comment row
      next if row.empty?
      next if row[0].include?( '#' )
        
      puts "\t" + row.to_s if get_options[:verbose]
      # strip out double quote characters 
      row.each do |r|
        r.to_Qdl unless r.nil?
      end

      # capture the Quandl code and skip line
#      if row[0].is_a? String && row[0].include?( "Quandl:" )
      if row[0].include?( "Quandl:" )
        qc = row[1]           
        next
      end
      
      # turn flag on if a string and value of first word is 'file'
      # skip line until either 'Quandl:' or 'Date'
      # then construct the Quandl HDR
      if row[0] == "file"
        @flag = !@flag

        d = Dataset.find( qc )
        d.destroy

        # Ensure column names are present and correct
        # Using _metadata does not create column_names      
        attributes = {
          :source_code => 'MPM_04',
          :code        => 'Geneva715',
          :name        => 'All School Wide Observations',
          :column_names=> ["Date", 
            "Shared Attention", "Engagement", 
            "Circles of Comm","Check Box", 
            "Elab. Ideas", "Bridges",
            "Ideas & Emotions"],
          :frequency   => "monthly",
          :from_date   => "2015-03-01",
          :to_date     => "2015-08-31",
          :description => 't.b.a.',
          :private     => false,
          :premium     => true
          }

        # Create the Quandl Dataset and save it
        d = Dataset.create(attributes)
        d.save
        pp d
        puts d.errors
        puts d.error_messages

        fl.puts ["Quandl Code", attributes[:column_names]].join('|')

        next
      end #if


      # this is data so construct the Quandl structured row and put in fl
      begin
        #dt in row[2] is mm/dd/yyyy not padded, convert 
        # 5/12/15 to 2015-05-12
        dt = row[2].to_Qdt
      rescue
        puts "\tInvalid date: #{dt}; skipped row."
        next
      end
    
      # construct line as array joined with '|'
      line = [ qc, dt ]
      # Shared Attention [1..4]
      line << [ 1 ]       if row[5] == "Yes"
      line << [ 2 ]       if row[6] == "Yes"
      line << [ 3 ]       if row[7] == "Yes"
      line << [ 4 ]       if row[8] == "Yes"
      line << [ 5 ]       if row[9] == "Yes"

      # Engagement
      line << [ 1 ]       if row[10] == "Yes"
      line << [ 2 ]       if row[11] == "Yes"
      line << [ 3 ]       if row[12] == "Yes"
      line << [ 4 ]       if row[13] == "Yes"
      line << [ 5 ]       if row[14] == "Yes"

      # Circle of Communication
      line << [ 1 ]       if row[15] == "Yes"
      line << [ 2 ]       if row[16] == "Yes"
      line << [ 3 ]       if row[17] == "Yes"
      line << [ 4 ]       if row[18] == "Yes"
      line << [ 5 ]       if row[19] == "Yes"

      # Check Box
      line << [ 0 ]
      line << [ 1 ]       if row[20] == "Yes"
      line << [ 2 ]       if row[21] == "Yes"
      line << [ 3 ]       if row[22] == "Yes"
      line << [ 4 ]       if row[23] == "Yes"
      line << [ 5 ]       if row[24] == "Yes"

      # Elaborating Ideas
      line << [ 1 ]       if row[25] == "Yes"
      line << [ 2 ]       if row[26] == "Yes"
      line << [ 3 ]       if row[27] == "Yes"
      line << [ 4 ]       if row[28] == "Yes"
      line << [ 5 ]       if row[29] == "Yes"

      # Building Bridges
      line << [ 1 ]       if row[30] == "Yes"
      line << [ 2 ]       if row[31] == "Yes"
      line << [ 3 ]       if row[32] == "Yes"
      line << [ 4 ]       if row[33] == "Yes"
      line << [ 5 ]       if row[34] == "Yes"

      fl.puts (line).join('|') + "\n" #     if !qc.empty? and @flag and row[0] != 'Date'

    end #CSV
    fl.close
  end

  def has_quandl_key?
    true                   # actually doesn't need it
  end

  # If we have ARGV values, setup column selector array
  # imagine, [1,3,6] are the ones we want

  def wrap_up
    puts "Sent #{get_sent} _kids files."
    super
  end

end
