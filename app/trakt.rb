module Trakt

  API_KEY = 'f05a4d93a7b0838ea46b12a6e86c6cdb'

  class Base

    def base_path
      "http://api.trakt.tv"
    end

    def get_json
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)
      unless data
        presentError error_ptr[0]
        return
      end
      json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
      unless json
        presentError error_ptr[0]
        return
      end
      json
    end

  end

  class Calendar < Trakt::Base

    def url
      "#{base_path}/calendar/shows.json/#{Trakt::API_KEY}"
    end

  end

end
