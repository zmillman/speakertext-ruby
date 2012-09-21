require 'httparty'
require 'json'

module SpeakerText
  class Source
    include HTTParty
    
    VALID_PLATFORMS = %w(blip.tv brightcove ooyala soundcloud ustream vimeo wistia youtube)
    
    attr_accessor :transcript_id
    attr_accessor :platform
    attr_accessor :video_id
    attr_accessor :url
    attr_accessor :title
    attr_accessor :ref_id
    attr_accessor :thumb_url
    attr_accessor :annotation
    
    attr_accessor :transcribe_response
    
    # Initialize a new Source. See http://speakertext.com/api/source-objects for more information on defining source objects
    #
    # attributes - The Hash attributes used to define the source (default: {}):
    #              * From a saved transcript id
    #              :transcript_id - a String containing the transcript's id
    #              * Video or audio from a platform
    #              :platform      - name of the hosting platform
    #              :video_id      - a string containing the unique id of the video or audio. See http://speakertext.com/api/supported-platforms
    #                               for information on how to determine the video_id for each platform
    #              * Video or audio from from a URL
    #              :url           - the url of the source file
    #              :title         - the title of the source (optional)
    #              :ref_id        - a custom value that will be passed via the pingback url (optional)
    #              :thumb_url     - the url of a thumbnail image for the source (optional)
    #              * Comman transcription options
    #              :annotation    - a note for the transcriber (optional)
    def initialize(attributes = {})
      attributes.each do |attr, value|
        instance_variable_set("@#{attr}", value) unless value.nil?
      end
    end
    
    # Sends data to the API and gets the transcript_id
    #
    # options - The Hash used to define additional parameters for the request
    #           :pingback_url - if present, SpeakerText will make a POST request to this url when the
    #                           transcription is complete. Default value is set in configuration See http://speakertext.com/api/transcripts-post for more info
    def transcribe!(options = {})
      if validate_for_transcription!
        query_opts = options.merge({
          :sources => [self.source_object_hash].to_json
        })
        query_opts[:pingback_url] ||= SpeakerText.configuration.default_pingback_url
        self.transcribe_response = Transcript.post("/transcripts", :query => query_opts)
      end
    end
    
    # Helper method to handle the HTTP response from a POST request    
    def transcribe_response=(http_response)
      # Example response: #<HTTParty::Response:0x7fc75526f240 @parsed_response={"credits_used"=>2, "transcript_ids"=>["TnXuza158n"], "status_code"=>201, "message"=>"Transcription jobs created.", "balance"=>2}, @response=#<Net::HTTPCreated 201 Created readbody=true>, @headers={"cache-control"=>["no-cache"], "content-type"=>["application/json; charset=utf-8"], "date"=>["Thu, 20 Sep 2012 06:49:31 GMT"], "server"=>["nginx/0.7.67"], "status"=>["201 Created"], "x-runtime"=>["1.150827"], "x-ua-compatible"=>["IE=Edge,chrome=1"], "content-length"=>["120"], "connection"=>["Close"]}> 
      @transcribe_response = http_response
      case http_response.code
      when 201 # Created
        raise 'No transcipt ids were returned' unless http_response.parsed_response["transcript_ids"]
        self.transcript_id = http_response.parsed_response["transcript_ids"].first
      when 400 # Bad Request
        raise 'HTTP 400: Bad Request'
      when 401 # Unauthorized
        raise 'HTTP 401: Unauthorized'
      when 402 # Payment Required
        raise 'HTTP 402: Payment Required'
      when 500 # Internal Server Error
        raise 'HTTP 500: An unknown server error occurred'
      else
        raise 'Unrecognized response: ' + http_response.inspect
      end
    end
    
    # Fetches data from the api and loads the content and status
    #
    # options - The Hash options used to choose the format (default: {}):
    #           :format - the file format of this transcript. Valid values are 'dfxp', 'txt', 'xml', or 'html' (default is 'txt')
    def transcript(options = {})
      raise 'Must have a transcript_id in order to fetch from the server' unless transcript_id
      response = self.class.get("/transcripts/#{transcript_id}", :query => options)
    end
    
    protected
    
    # Returns a hash object used for the POST request's query parameters
    def source_object_hash
      if platform
        return Hash[%w(platform video_id annotation).collect{|name| [name.to_sym, instance_variable_get("@#{name}")]}]
      elsif url
        return Hash[%w(url title ref_id thumb_url annotation).collect{|name| [name.to_sym, instance_variable_get("@#{name}")]}]
      else
        raise 'Invalid source object configuration -- must be configured for a platform or url'
      end
    end
    
    # Internal: Returns true if this is a valid source object, raises an error otherwise
    def validate_for_transcription!
      if transcript_id
        raise "This source has already been submitted for transcription."
      elsif self.platform
        raise "Not a valid platform: #{self.platform}" unless VALID_PLATFORMS.includes?(self.platform)
        raise "This is an invalid platform source. Please specify a video_id" unless video_id
      elsif self.url
        # TODO: validate url format
        # raise "Not a valid url: #{self.url}" unless # check here
      else
        raise "This is an invalid source. Please specify a platform or url."
      end
      return true
    end
  end
end