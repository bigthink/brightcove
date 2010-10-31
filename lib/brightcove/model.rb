module Brightcove
  class Model

    def initialize( attrs = {} )
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

  end
end