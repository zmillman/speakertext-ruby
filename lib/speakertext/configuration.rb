module SpeakerText
  class Configuration
    require 'speakertext/version'
    
    # SpeakerText credentials
    attr_accessor :api_key
    
    # Default option settings
    attr_accessor :default_pingback_url
    
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
    
    def base_uri
      "#{scheme}://#{host}#{base_path}"
    end

  end
end