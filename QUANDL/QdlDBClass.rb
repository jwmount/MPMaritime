class QdlDBClass

  AVG_DSs = 8
  QUANDL_FILE_PREFIX = '_data_'
  QUANDL_DATA_PREFIX = "Quandl Code|Date|Value"

  def aqps
    "%3.0f" %  (@count/(Time.new - @started_at)).to_f
  end

  def initialize ( limit )

    puts "\n\n\nCreate Quandl Demo\t\t\t#{$0}\n________________________________________________________"
    puts "(c) Copyright 2009 VenueSoftware Corp. All Rights Reserved. \n\n"
  end

    

end # class QdlDB