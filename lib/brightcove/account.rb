module Brightcove
  class Account
    attr_accessor :read_token,
      :write_token

    def initialize( read_token = nil, write_token = nil )
      @read_token = read_token
      @write_token = write_token
    end
  end
end