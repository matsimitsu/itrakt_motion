class Show
  attr_reader :title, :year, :overview, :runtime, :network, :air_time, :poster_url
  attr_accessor :poster

  def initialize(dict)
    @title = dict['title']
    @year = dict['year']
    @title = dict['title']
    @overview = dict['overview']
    @network = dict['network']
    @runtime = dict['runtime']
    @air_time = dict['air_time']
    @poster_url = dict['images']['poster']
    @poster = nil
  end

end
