class BroadcastDay
  attr_reader :date, :broadcasts

  def initialize(dict)
    @date = dict['date']
    @broadcasts = load_broadcasts(dict['episodes'])
  end

  def load_broadcasts(broadcasts_hash)
    [].tap do |result_array|
      broadcasts_hash.each do |broadcast_hash|
        result_array << {
          :episode => Episode.new(broadcast_hash['episode']),
          :show => Show.new(broadcast_hash['show'])
        }
      end
    end
  end

end
