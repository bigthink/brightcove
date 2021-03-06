module Brightcove

  class Service

    DEFAULT_HOST = 'api.brightcove.com'

    attr_accessor :read_token,
      :write_token,
      :host,
      :port,
      :ssl

    # == Options
    # * read_token
    # * write_token
    # * host (default "api.brightcove.com")
    # * port (default 443 if ssl; 80 otherwise)
    # * ssl (default true)
    #
    def initialize( options = {} )
      @read_token = options[ :read_token ]
      @write_token = options[ :write_token ]
      @ssl = options[ :ssl ].nil? ? true : options[ :ssl ]
      @host = options[ :host ] || DEFAULT_HOST
      @port = options[ :port ] ||
        ( ssl ? Net::HTTP.https_default_port : Net::HTTP.http_default_port )
    end

    # == Params
    # * video_fields
    # * custom_fields
    # * media_delivery
    #
    def find_video_by_id( id, params = {} )
      begin
        dto = invoke_read_api :find_video_by_id, params.merge( :video_id => id )
        raise NotFound if dto.nil?
        DTOParser.parse_video( dto )
      rescue APIError => e
        if e.inner_errors.length == 1 &&
          e.inner_errors.first.code == APIError::Codes::ObjectNotFound
          raise NotFound
        end
        raise
      end
    end

    # == Params
    # * page_size
    # * sort_by
    # * sort_order
    # * get_item_count
    # * fields
    # * video_fields
    # * custom_fields
    # * media_delivery
    #
    def find_all_videos( params = {} )
      dto = invoke_read_api :find_all_videos, params
      DTOParser.parse_item_collection dto, :video
    end

    # == Params
    # * filter - 
    # * page_size
    # * page_number
    # * sort_by
    # * sort_order
    # * get_item_count
    # * video_fields
    # * custom_fields
    # * media_delivery
    #
    def find_modified_videos( from_date, params = {} )
      params = params.merge( :from_date => from_date )
      dto = invoke_read_api( :find_modified_videos, params )
      DTOParser.parse_item_collection dto, :video
    end

    #
    #
    def update_video_partial( video_id, attrs = {} )
      formatted = DTOFormatter.format_partial_object( Video, attrs )

      params = {
        :video => formatted.merge( 'id' => video_id )
      }

      DTOParser.parse_video invoke_write_api( :update_video, params )
    end

  private

    def ensure_read_token
      read_token ||
        raise( "No read token" )
    end

    def ensure_write_token
      write_token ||
        raise( "No write token" )
    end

    def invoke_write_api( method, params = {} )
      payload = {
        :method => method,
        :params => params.merge( :token => ensure_write_token )
      }.to_json

      body = http_post( "/services/post", 'json' => payload )
      retval = JSON.parse( body )

      if write_api_error?( retval )
        raise parse_write_api_error( retval )
      end

      # a DTO
      retval[ "result" ]
    end

    def invoke_read_api( method, params = {} )
      query = QueryString.build( ensure_read_token, method, params )

      body = http_get( "/services/library?#{ query }" )

      # Brightcove returns "null" to represent null. This is not valid JSON,
      # so we need a special case.
      if body == "null"
        nil
      else
        retval = JSON.parse( body )

        if read_api_error?( retval )
          raise parse_read_api_error( retval )
        end

        # a DTO
        retval
      end
    end

    def http_get( path )
      http_session { |session| session.get path }
    end

    def http_post( path, params )
      http_session do |session|
        request = Net::HTTP::Post.new( path )
        request.set_form_data params
        session.request request
      end
    end

    def http_session
      session = Net::HTTP.new( host, port )
      session.use_ssl = ssl
      session.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = session.start { |session| yield session }

      unless response.is_a?( Net::HTTPOK )
        raise Error, "Server error: #{ http_response.code } #{ http_response.message }"
      end

      response.body
    end

    def read_api_error?( retval )
      !retval[ "error" ].nil? && !retval[ "code" ].nil?
    end

    def parse_read_api_error( retval )
      inner_hashes = retval[ "errors" ]

      inner_errors = inner_hashes ?
        inner_hashes.collect { |inner_hash| parse_read_api_error( inner_hash ) } :
        []

      APIError.new retval[ "error" ], retval[ "code" ], inner_errors
    end

    # {"result"=>nil, "id"=>nil, "error"=>{"name"=>"MalformedParametersError", "code"=>205, "message"=>"Error deserializing JSON for property geoFilterExclude - expected to get type boolean from value: null"}}
    def write_api_error?( retval )
      !retval[ "error" ].nil?
    end

    def parse_write_api_error( retval )
      APIError.new retval[ "error" ][ "message" ], retval[ "error" ][ "code" ]
    end

  end
end