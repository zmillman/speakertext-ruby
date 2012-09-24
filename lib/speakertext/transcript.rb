# A wrapping class for GET responses from the API
require 'tempfile'
require 'httparty'

module SpeakerText
  class Transcript
    include HTTParty
    
    # Stores the response
    attr_accessor :response
    
    attr_accessor :format
    
    attr_accessor :content
    attr_accessor :transcript_id
    attr_accessor :message
    attr_accessor :status
    
    attr_accessor :content_file
    
    # Initialize a new Transcript
    #
    # args - Hash of attributes to initialize this Transcript with
    #        :format - the file format of this transcript. Valid values are 'dfxp', 'txt', 'xml', or 'html' (default is 'txt')
    def initialize(args = {})
      self.format = args[:format] || 'txt'
      self.transcript_id = args[:transcript_id]
      self.response = args[:http_response] if args[:http_response]
    end
    
    def download!
      raise 'Must have a transcript_id in order to fetch from the server' unless self.transcript_id
      
      self.response = self.class.get("/transcripts/#{self.transcript_id}", :query => self.to_query_options)
    end
    
    # Helper method for reading values from an HTTP response
    def response=(http_response)
      # Example = <HTTParty::Response:0x7fc724c65438
      # @parsed_response={
      #   "code"=>"200",
      #   "content"=>"", 
      #   "transcript_id"=>"TnXuza158n",
      #   "message"=>"Transcript id found successfully.",
      #   "status"=>"in_progress"
      # }
      # @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"cache-control"=>["max-age=0, private, must-revalidate"], "content-type"=>["application/json; charset=utf-8"], "date"=>["Thu, 20 Sep 2012 16:41:50 GMT"], "etag"=>["\"4e469adb2e0f172bf18f1dc7e8bb8e5c\""], "server"=>["nginx/0.7.67"], "status"=>["200 OK"], "x-runtime"=>["0.045737"], "x-ua-compatible"=>["IE=Edge,chrome=1"], "content-length"=>["125"], "connection"=>["Close"]}> 
      @response = http_response
      case http_response.code
      when 200 # OK
        self.content        = http_response.parsed_response["content"]
        self.transcript_id  = http_response.parsed_response["transcript_id"]
        self.message        = http_response.parsed_response["message"]
        self.status         = http_response.parsed_response["status"]
      when 401 # Unauthorized
        raise 'HTTP 401: Unauthorized. Your credentials are incorrect. Check your API key.'
      when 403 # Forbidden
        raise 'HTTP 403: Forbidden. You provided the wrong credentials to access this transcript.'
      when 404 # Not Found
        raise 'HTTP 404: Not Found. The transcript ID you specified was not found in the system.'
      when 406 # Not Acceptable
        raise 'HTTP 406: Not Acceptable. The format you requested is not available.'
      when 500 # Internal Server Error
        raise 'HTTP 500: Internal Server Error. An unknown server error occurred.'
      else
        raise 'Unrecognized response: ' + http_response.inspect
      end
    end
    
    # Returns a TempFile containing the content of the transcript
    def to_file
      if content_file.nil?
        content_file = Tempfile.new(['transcript', ".#{format}"])
        content_file.write(self.content)
      end
      return content_file
    end
    
    def to_query_options
      {:format => self.format}
    end
    
    def in_progress?
      status == 'in_progress'
    end
    
    def completed?
      status == 'completed'
    end
  end
end