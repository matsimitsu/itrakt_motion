module Trakt

  API_KEY = 'f05a4d93a7b0838ea46b12a6e86c6cdb'

  class Base

    class << self
      attr_accessor :result
    end

    def self.ensuring_json(&block)
      block.call(self.result) if self.result
      request = self.new
      request.get_json do |result|
        self.result = result
        block.call(result)
      end
    end

    def base_path
      "http://api.trakt.tv"
    end

    def credentials
      "{'username': '#{username}', 'password': '#{user_cache['password_hash']}'}"
    end

    def username
      user_cache['username']
    end

    def get_json(default=[], show_errors=true, &block)
      BubbleWrap::HTTP.post(url, {payload: credentials}) do |response|
        if response.ok?
          block.call(BubbleWrap::JSON.parse(response.body.to_str))
        else
          alert('error', response.error_message) if show_errors
          block.call(default)
        end
      end
    end
  end

  class Authentication < Trakt::Base

    def url
      "#{base_path}/account/test/#{Trakt::API_KEY}"
    end

    def validate(&block)
      get_json({}, false) do |json|
        if json['status'] && json['status'] == 'success'
          return block.call(true)
        else
          return block.call(false)
        end
      end
    end
  end

  class Calendar < Trakt::Base

    def url
      "#{base_path}/user/calendar/shows.json/#{Trakt::API_KEY}/#{username}"
    end

  end

  class Library < Trakt::Base

    def url
      "#{base_path}/user/library/shows/all.json/#{Trakt::API_KEY}/#{username}/extended"
    end

  end

  class Show < Trakt::Base
    attr_reader :tvdb_id

    def initialize(tvdb_id)
      @tvdb_id = tvdb_id
    end

    def url
      "#{base_path}/show/summary.json/#{Trakt::API_KEY}/#{@tvdb_id}/extended"
    end

  end

end

