module Brightcove

  class CuePoint < Model
    attr_accessor :name,
      :time, # milliseconds, an offset from the beginning of the video
      :force_stop,
      :type,
      :metadata
  end

end
