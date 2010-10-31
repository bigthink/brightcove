module Brightcove

  class Rendition < Model
    attr_accessor :url,
      :controller_type,
      :encoding_rate, #bits per second
      :frame_height,
      :frame_width,
      :size,
      :remote_url,
      :remote_stream_name,
      :video_duration,
      :video_codec
  end

end