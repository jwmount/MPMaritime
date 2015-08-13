# ruby optionparser class
# http://ruby-doc.org/stdlib-2.2.2/libdoc/optparse/rdoc/OptionParser.html
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class OptparseArguments

  CODES = %w[iso-2022-jp shift_jis euc-jp utf8 binary]
  CODE_ALIASES = { "jis" => "iso-2022-jp", "sjis" => "shift_jis" }

  #
  # Return a structure describing the options.
  #
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.send       = false                # No, do not send
    options.directory  = 'DATA'               # Can be anywhere if overridden
    options.columns    = 'Value'              # key as csv list, e.g. 'TCE, PMT'
    options.verbose    = false                # Say as little as necessary

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: load.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # directory where files will be read from
      opts.on("-d", "--dir DIRECTORY",
              "Directory where to find files to load, default: #{options.directory}") do |d|
              options[:directory] = d
      end

      # nosend: do not transmit to Quandl
      opts.on("-f", "--file FILESPEC", 
              "File to send to Quandl") do |f|
              options[:file] = f
      end

      # nosend: do not transmit to Quandl
      opts.on("-s", "--[no-]send NOSEND",
              "Send file to Quandl") do |s|
              options.send = s
      end
              
      # List of columns.
      opts.on("-c", "--columns COLUMNS", "Selected columns, requires -f, Example: TCE PMT") do |c|
        options[:columns] = c 
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
    options
  end  # parse()

end  # class OptparseArguments



