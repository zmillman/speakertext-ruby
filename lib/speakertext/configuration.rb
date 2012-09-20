require 'addressable/uri'

module SpeakerText
  class Configuration
    require 'speakertext/version'
    
    # SpeakerText credentials
    attr_accessor :api_key
    
    # The URL of the API server
    attr_accessor :scheme
    attr_accessor :host
    attr_accessor :base_path
    
    def initialize
      @scheme = 'https'
      @host = 'api.speakertext.com'
      @base_path = '/v1'
      
      @user_agent = "ruby-#{SpeakerText::VERSION}"
    end
    
    def base_url
      Addressable::URI.new(
        :scheme => self.scheme,
        :host => self.host,
        :path => self.base_path
      )
    end
  end
end