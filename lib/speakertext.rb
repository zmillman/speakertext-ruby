require 'speakertext/configuration'
require 'speakertext/transcript'
require 'speakertext/source'

module SpeakerText

  class << self
    # A SpeakerText configuration object. Must like a hash and return sensible values for all
    # SpeakerText configuration options. See SpeakerText::Configuration
    attr_accessor :configuration

    attr_accessor :transcript_resource

    # Call this method to modify the configuration in your initializers
    def configure
      self.configuration ||= Configuration.new

      yield(configuration) if block_given?

      # Use the configuration to set up HTTParty        
      Source.base_uri     configuration.base_uri
      Source.basic_auth   configuration.api_key, 'x' # using a dummy password
    end    
  end

end