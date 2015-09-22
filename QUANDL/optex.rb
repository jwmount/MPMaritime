# ruby optionparser class
# http://ruby-doc.org/stdlib-2.2.2/libdoc/optparse/rdoc/OptionParser.html
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class OptparseArguments

  def self.validate(options)

    # Validations
    # File not specified
    #   use 'value' and column 2..count
    #   use header names and all columns
    #   use map, e.g. hash of selected columns
    # -names
    puts "\n\t OPTION SETTINGS"
    puts "\t   :column_names\t -c #{options[:columns]}"
    puts "\t   :directory \t\t -d #{options[:directory]}"
    puts "\t   :file      \t\t -f #{options[:file]}"
    puts "\t   :ignore    \t\t -i #{options[:ignore] ? 'No' : 'Yes'}"
    #puts "\t   :production\t\t -p #{options[:production]}"
    puts "\t   :send      \t\t -s #{options[:send]}"
    puts "\t   :verbose   \t\t -v #{options[:verbose]}"

    if options[:file].empty?
      puts "\n\t WARNING:  -f requires a string. Example:  VLCC\n"
      exit
    end
    unless options[:ignore]
      puts "\n\t Begin at:  #{Time.now.to_s}."
    end
    #if options[:production] && options[:directory] == 'DATA'
    #  puts "\n\t WARNING:  -p implies -d be a production folder, do you want to proceed with #{options[:directory]}?.\n"
    #end
    if options[:directory].empty?
      puts "\n\t WARNING: -d cannot be empty. It can be omitted.\n"
      exit
    end
    puts "\n\tSummary"
    puts "\t-c is set so these column names will be applied to #{options[:file]}(s)"
    puts "\t-f is set so only files that contain #{options[:file]} will be processed."
    puts "\t-i is #{options[:ignore]} so request user confirmation. BETA"
    #puts "\t-p is #{options[:production]} so datasets will be taken from #{options[:directory]}."
    puts "\t-s is #{options[:send]} so datasets will #{options[:send] ? '':'not '} be sent to Quandl."
  end

end

class OptparseArguments

  # Default argument values 

  CODES        = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

# name           default         tag example
  COLUMNS      = []             # -c ["Date", "$/bbl"]
  DIRECTORY    = 'DATA'         # -d /Users/John/DropBox/PRODUCTION
  FILE         = '*'            # -f VLCC
  IGNORE       = true           # -i request user conf if true
  #PRODUCTION   = false          # -p
  SEND         = false          # -s
  VERBOSE      = false          # -v


  #
  # Return a structure describing the options.
  #
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.columns    = COLUMNS              # Force a specific name
    options.send       = SEND                 # No, do not send
    options.directory  = DIRECTORY            # Can be anywhere if overridden
    options.file       = FILE                 # Process all files matching *<fn>*.csv
    options.ignore     = IGNORE               # Ignore confirmation from user
  #  options.production = PRODUCTION           # Use .csv files in DropBox/PRODUCTION
    options.verbose    = VERBOSE              # Say as little as necessary

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: load.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # column_names 
      opts.on("-c", "--cols ARRAY",
              "Column names, default: #{options.column_names}") do |c|
              options[:column_names] = c
      end

      # directory where files will be read from
      opts.on("-d", "--dir DIRECTORY",
              "Directory where to find files to load, default: #{options.directory}") do |d|
              options[:directory] = d
      end
      # confirm: if set do not request user to confirm options
      opts.on("-i", "--ign[no-]confirm", "Request user to confirm options are set correctly.") do |i|
              options[:ignore] = i
      end

      # :file -- process single file, or all files with string, e.g. VLCC
      opts.on("-f", "--file FILESPEC", 
              "File to send to Quandl; Required if -c is used.") do |f|
              options[:file] = f
      end

      # nosend: do not transmit to Quandl unless true
      opts.on("-s", "--[no-]send", "Send file to Quandl") do |s|
              options[:send] = s
      end
              
      # Keyword completion.  We are specifying a specific set of arguments (CODES
      # and CODE_ALIASES - notice the latter is a Hash), and the user may provide
      # the shortest unambiguous text.
      code_list = (CODE_ALIASES.keys + CODES).join(',')
      opts.on("--code CODE", CODES, CODE_ALIASES, "Select encoding",
              "  (#{code_list})") do |encoding|
        options.encoding = encoding
      end

      # Optional argument with keyword completion.
      opts.on("--type [TYPE]", [:text, :binary, :auto],
              "Select transfer type (text, binary, auto)") do |t|
        options.transfer_type = t
      end

      # Boolean switch.
      opts.on("-p", "--[no-]production", "Use production csv files") do |p|
        options.production = p
      end

      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options.verbose = v
      end

      opts.separator ""
      opts.separator "Common options:"

      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts ::Version.join('.')
        exit
      end
    end

    opt_parser.parse!(args)    
    validate(options)
    options
  end  # parse()


end  # class OptparseArguments



