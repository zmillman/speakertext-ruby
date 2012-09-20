require 'speakertext/configuration'

module SpeakerText
  
  class << self
      # A SpeakerText configuration object. Must like a hash and return sensible values for all
      # SpeakerText configuration options. See SpeakerText::Configuration
      attr_accessor :configuration
      
      # Call this method to modify the configuration in your initializers
      def configure
        self.configuration ||= Configuration.new
        
        yield(configuration) if block_given?
      end
  end
  
end