require File.dirname( __FILE__ ) + '/helper'

class VideoTest < BrightcoveTest

  def test_find_raises_on_invalid_id
    assert_raise Brightcove::NotFound do
      Video.find( -1 )
    end
  end

  def test_find_returns_video
    sought = find_video
    video = Video.find( sought.id )
    assert video.is_a?( Video )
    assert_equal sought.id, video.id
  end

  def test_find_first_returns_video
    video = Video.find_first
    assert video.is_a?( Video )
  end

  def test_find_all_returns_all
    videos = Video.find_all
    assert videos.is_a?( Array )
    assert videos.length > 0
  end

  def test_each_yields_video
    Video.each do |video|
      assert video.is_a?( Video )
      break
    end
  end

  def test_each_and_find_all_yield_same_count
    assert_equal Video.find_all.length, Video.enum_for( :each ).to_a.length
  end

  def test_each_modified_since
    time = Time.utc 1980

    Video.each_modified_since( time ) do |video|
      assert video.is_a?( Video )
      assert video.last_modified_date > time
    end
  end

end