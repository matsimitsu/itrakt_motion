class Episode
  attr_reader :season, :number, :title, :overview, :url, :first_aired, :image_url
  attr_accessor :image

  def initialize(dict)
    @season = dict['season']
    @number = dict['number']
    @title = dict['title']
    @overview = dict['overview']
    @url = dict['url']
    @first_aired = dict['first_aired']
    @image_url = dict['images']['screen']
    @image = nil
  end

  def season_and_episode_number
    "#{self.season}X#{self.number}"
  end

  def air_date
    Time.at(@first_aired).strftime("%Y-%m-%d")
  end

end
