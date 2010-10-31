module Brightcove

  class Error < StandardError
  end

  class NotFound < Error
  end

  class APIError < Error
    attr_reader :code,
      :inner_errors

    def initialize( message, code, inner_errors = [] )
      super message
      @code = code
      @inner_errors = inner_errors
    end

    def to_s
      inner_errors.empty? ?
        super :
        super + " [" + inner_errors.map( &:to_s ).join( ", " ) + "]"
    end

    module Codes
      InvalidParameters = 301
      ObjectNotFound = 307
    end

  end
end