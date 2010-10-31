require 'rubygems'
require 'cgi'
require 'net/http'
require 'json'

%w{
  version
  errors
  model
  video
  rendition
  image
  cue_point
  logo_overlay
  account
  service
  dto_maps
  dto_parser
  dto_formatter
  query_string
}.each do |file|
  require "#{ File.dirname( __FILE__ ) }/brightcove/#{ file }"
end

module Brightcove

  class << self
    attr_accessor :read_token,
      :write_token

    def account
      if @read_token.nil? || @write_token.nil?
        raise Error, "Set Brightcove.read_token and Brightcove.write_token"
      end
      Account.new @read_token, @write_token
    end

    def service
      Service.new account
    end
  end

end