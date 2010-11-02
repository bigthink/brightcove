require File.dirname( __FILE__ ) + '/helper'

class ServiceTest < BrightcoveTest

  def test_invocation_without_token_raises
    assert_raise RuntimeError do
      Service.new.find_all_videos
    end
  end

  def test_port_set_on_init
    service = Service.new
    assert_equal 80, service.port

    service = Service.new :ssl => true
    assert_equal 443, service.port

    service = Service.new :ssl => false
    assert_equal 80, service.port

    service = Service.new :port => 81, :ssl => true
    assert_equal 81, service.port
  end

  def test_host_set_on_init
    service = Service.new
    assert_equal Brightcove::Service::DEFAULT_HOST, service.host

    service = Service.new :host => 'arbuckle'
    assert_equal 'arbuckle', service.host
  end

  #
  # Read API
  #

  def test_invalid_token_raises_error
    service = Service.new :read_token => 'invalid_token'

    assert_raise Brightcove::APIError do
      service.find_all_videos
    end

    begin
      service.find_all_videos
    rescue Brightcove::APIError => e
      assert_equal 301, e.code
      assert_equal "One or more validation errors have occurred [token OUT_OF_RANGE]", e.message
      assert_equal 1, e.inner_errors.length
      assert e.inner_errors.first.is_a?( Brightcove::APIError )
    end
  end

  def test_find_all_videos
    videos = @service.find_all_videos
    assert videos.is_a?( Array )
    assert videos.length > 0
    assert videos.first.is_a?( Video )
  end

  def test_find_modified_videos
    time = Time.utc( 2010 )
    videos = @service.find_modified_videos( time )
    assert videos.is_a?( Array )
    assert videos.length > 0
    assert videos.first.is_a?( Video )
    assert videos.all? { |video| video.last_modified_date >= time }
  end

  def test_find_video_by_id_success
    id = find_video.id
    video = @service.find_video_by_id( id )
    assert video.is_a?( Video )
    assert_equal id, video.id
  end

  def test_find_video_by_id_raises_on_nonexistent_id
    assert_raise Brightcove::NotFound do
      @service.find_video_by_id( 1 ).inspect
    end
  end

  #
  # Write API
  #

  def test_update_video_attrs
    name = random_string
    desc = random_string
    video = find_video

    video = @service.update_video_partial video.id,
      :name => name,
      :short_description => desc

    assert_equal name, video.name
    assert_equal desc, video.short_description
  end

end