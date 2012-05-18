class Season
  attr_reader :number, :episodes

  def initialize(dict)
    @number = dict['season']
    @episodes = dict['episodes'].map { |episode| Episode.new(episode) }
  end

end
