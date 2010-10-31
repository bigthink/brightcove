module Brightcove

  class Image < Model
    attr_accessor :id,
      :reference_id,
      :type,
      :remote_url,
      :display_name
  end

end