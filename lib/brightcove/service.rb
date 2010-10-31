module Brightcove

  HOST = 'api.brightcove.com'
  PORT = 80

  class Service
    def initialize( account )
      @account = account
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

    def invoke_write_api( method, params = {} )
      payload = {
        :method => method,
        :params => params.merge( :token => @account.write_token )
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
      query = QueryString.build( @account.read_token, method, params )

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
      response = Net::HTTP.start( HOST, PORT ) do |session|
        yield session
      end

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