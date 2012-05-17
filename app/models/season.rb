class Season
  attr_reader :number, :episodes

  def initialize(dict)
    @number = dict['number']
    @episodes = dict['episodes']
  end

end
