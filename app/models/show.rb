class Show
  attr_reader :title, :year, :overview, :runtime, :network, :air_time, :poster_url, :image_url, :tvdb_id
  attr_accessor :poster, :image

  def initialize(dict)
    @title = dict['title']
    @year = dict['year']
    @title = dict['title']
    @overview = dict['overview']
    @network = dict['network']
    @runtime = dict['runtime']
    @air_time = dict['air_time']
    @tvdb_id = dict['tvdb_id']
    @poster_url = dict['images']['poster'].gsub('.jpg', '-138.jpg')
    @image_url = dict['images']['fanart']
    @poster = nil
  end

end
