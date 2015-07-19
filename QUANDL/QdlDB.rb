class QdlDB

  AVG_DSs = 8
  QUANDL_FILE_PREFIX = '_data_'
  QUANDL_DATA_PREFIX = "Quandl Code|Date|Value"


  def aqps
    "%3.0f" %  (@count/(Time.new - @started_at)).to_f
  end

  def initialize ( file_in, file_out, limit)
    @count = 0
    @dbhsh = {}
  end

end # class QdlDB