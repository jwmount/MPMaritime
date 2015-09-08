# kdata.rb -- Quandl Load _kids files.
# If _kids:  look for Quandl: key, if present, use as Quandl Code
# QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby load.rb
# http://ruby-doc.org/stdlib-2.2.2/libdoc/net/ftp/rdoc/Net/FTP.html#method-i-puttextfile

require 'quandl/client'
require 'date'
require 'pry'
require 'csv'


#
# to_Qdt -- used to clean up date format produced by Adobe
#           Adobe date syntax breaks the Quandl import process
#
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
  @options = nil
  @sent = 0
  @observations = {}

  def initialize( f )
    inc_sent
    super( f )
  end

  def inc_sent
    @sent ||= +1
  end

  def get_sent
    @sent
  end

  # from load.rb @options for use here
  def set_options o
    @options = o
  end

  def get_options
    @options
  end
  
  # Composes the Quandle formated version of the DATA/*.csv file
  def compose f

    # 
    #  @flag         - Set to true once we locate the data which begins with
    #                - the line below the one with 'Data' in it.
    #  @observations - Collection of lines (from the rows read) used to accumulate
    #                - the file data in order to identify and average duplicates.
    #                - When a duplicate ocurs the number of observations is incremented 
    #                - by 1 and the values are simply summed up.  The averages are 
    #                - computed after the data are read and before the qfile is written.
    # qc             - Quandl Code for this DATABASE, this comes in from the .csv file.
    # dir            - location of data files.  Defaults to 'DATA'.
    #
    # example        - if file-in is _kidsTony.csv then out file is _dataTony.txt
    
    @flag            = false
    @observations    = {}
    qc               = []
    dir              = get_options.directory
    @qdl_filespec    = qdl_filespec= filename.gsub(".csv", ".txt").gsub("_kids","_data")

    # Open the output file, MUST be <stem>/*{_data | _metadata}*.txt
    # file is actually qdl_filename
    
    fout = File.open(@qdl_filespec, 'w')

    # Read and handle each row of the file
    CSV.foreach(f) do |row| 

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
          :source_code => (qc.split('/'))[0],
          :code        => (qc.split('/'))[1],
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
        pp d                  if get_options.verbose
        puts d.errors         if d.errors.any?
        puts d.error_messages if d.error_messages.any?

        fout.puts ["Quandl Code", attributes[:column_names]].join('|')

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

      #
      # In the _kids .csv file each question has multiple checkboxes
      # and each box has a value.  First we map these values in line.
      # construct line as array joined with '|'
      #
      line = [ 0, qc, dt ]
      # Shared Attention [1..4]
      line << 1       if row[5] == "Yes"
      line << 2       if row[6] == "Yes"
      line << 3       if row[7] == "Yes"
      line << 4       if row[8] == "Yes"
      line << 5       if row[9] == "Yes"

      # Engagement
      line << 1       if row[10] == "Yes"
      line << 2       if row[11] == "Yes"
      line << 3       if row[12] == "Yes"
      line << 4       if row[13] == "Yes"
      line << 5       if row[14] == "Yes"

      # Circle of Communication
      line << 1       if row[15] == "Yes"
      line << 2       if row[16] == "Yes"
      line << 3       if row[17] == "Yes"
      line << 4       if row[18] == "Yes"
      line << 5       if row[19] == "Yes"

      # Check Box
      line << 0
      line << 1      if row[20] == "Yes"
      line << 2      if row[21] == "Yes"
      line << 3      if row[22] == "Yes"
      line << 4      if row[23] == "Yes"
      line << 5      if row[24] == "Yes"

      # Elaborating Ideas
      line <<  1       if row[25] == "Yes"
      line <<  2       if row[26] == "Yes"
      line <<  3       if row[27] == "Yes"
      line <<  4       if row[28] == "Yes"
      line <<  5       if row[29] == "Yes"

      # Building Bridges
      line << 1       if row[30] == "Yes"
      line << 2       if row[31] == "Yes"
      line << 3       if row[32] == "Yes"
      line << 4       if row[33] == "Yes"
      line << 5       if row[34] == "Yes"

      # Figure out if this date duplicates one we have and if it is
      # retain the number of observations on this date and sum the 
      # question values.  From these we can get average observations.
      # The range values used here are HIGHLY DEPENDENT ON THE FORM USED.
      # dedup = { count, k==date, array of totals] }
      # dedup = { 2, 2015-6-15,  2, 4, 8, 6, 7, 5, 4  }
      
      if @observations.has_key?(dt)

        # A duplicate has occured
        puts "#{dt} key value exists, dedup them" if get_options.verbose
        
        # 1.  increment the number of duplicates
        @observations[dt][0] += 1
      
        # 2. Sum the duplicate observations and hold in @observations
        #    Some lines may be short, then don't sum them.  May cause averaging fails.
        (3..9).each_with_index do |ix| 
          @observations[dt][ix] += line[ix] unless line[ix].nil?
        end

      else
        # Not a duplicate
        puts "#{dt} key does NOT exist, will be merged in." if get_options.verbose

        # merge the new observation into @observations for now
        @observations.merge!( {dt => line } )

        # count them
        @observations[dt][0] += 1
      end
      
    end #CSV
    
    # Average the observation values and write them to fl
    # iterate over them
    @observations.each do |obs|
      duplicates = obs[1][0].to_f

      # drop the first two elements which are no longer needed
      o = obs.flatten.drop(2)

      # calculate the averages
      (2..8).each_with_index {|ix| o[ix] /= duplicates }

      # write to file
      fout.puts (o).join('|')
      
    end # iteration
    
    fout.close
  end # compose

  def has_quandl_key?
    true                   # actually doesn't need it
  end

  # If we have ARGV values, setup column selector array
  # imagine, [1,3,6] are the ones we want

  def wrap_up
    puts "Sent #{get_sent}.\n\n"
    super                           if get_options.verbose
  end

end
