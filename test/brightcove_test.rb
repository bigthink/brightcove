require 'test/unit'
require File.dirname( __FILE__ ) + '/../lib/brightcove'

class BrightcoveTest < Test::Unit::TestCase

  include Brightcove

  # enter Brightcove tokens to run tests
  def setup
    Brightcove.read_token = nil
    Brightcove.write_token = nil

    @account = Brightcove.account
    @service = Brightcove.service
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