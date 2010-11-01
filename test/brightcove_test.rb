require 'test/unit'
require File.dirname( __FILE__ ) + '/../lib/brightcove'

class BrightcoveTest < Test::Unit::TestCase

  include Brightcove

  # enter Brightcove tokens to run tests
  def setup
    tokens = {
      :read_token => "",
      :write_token => ""
    }

    @service = Brightcove.service = Service.new( tokens )
  end

  # Test::Unit requires at least one test in a test class
  def default_test
  end

private

  def find_video
    @service.find_all_videos( :page_size => 1 ).first
  end

  def random_string
    "Random string number #{ rand( 1000000 ) }"
  end

end