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
    attr_accessor :service
  end

end