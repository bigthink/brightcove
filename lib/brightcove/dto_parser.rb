module Brightcove

  # DTO: "data transfer object"
  class DTOParser

    class << self

      # discards paging info
      #
      def parse_item_collection( dto, type )
        parse_array dto[ "items" ], type
      end

      def parse_video( dto )
        Video.new parse_with_map( dto, DTOMaps::VIDEO )
      end

      def parse_rendition( dto )
        Rendition.new parse_with_map( dto, DTOMaps::RENDITION )
      end

      def parse_cue_point( dto )
        CuePoint.new parse_with_map( dto, DTOMaps::CUE_POINT )
      end

      def parse_playlist( dto )
        Playlist.new parse_with_map( dto, DTOMaps::PLAYLIST )
      end

    private

      def parse_with_map( dto, map )
        result = {}

        map.each do |dto_name, name, type, opts|
          result[ name ] = parse_value( dto[ dto_name ], type, opts )
        end

        result
      end

      def parse_value( value, type, opts = {} )
        unless [ :hash, :array ].include?( type )
          return nil if value.nil?
        end

        case type
        when :string, :integer, :long, :boolean
          value
        when :time
          parse_date value
        when :array
          parse_array( value, opts[ :type ], opts[ :format ] )
        when :hash
          parse_hash( value )
        when :rendition
          parse_rendition( value )
        when :cue_point
          parse_cue_point( value )
        when :video
          parse_video value
        else
          raise "Can't parse #{ type }"
        end
      end

      def parse_array( value, type = nil, format = nil )
        return [] if value.nil?

        if format == :comma_list
          value = value.split( ',' ).collect( &:strip )
        end

        type ?
          value.collect { |element| parse_value( element, type ) } :
          value.dup
      end

      def parse_hash( value )
        value ? value.dup : {}
      end

      def parse_date( value )
        # for some reason, a String is returned
        msecs = value.to_i

        # Brightcove returns milliseconds; Time#at takes seconds, microseconds
        Time.at( msecs / 1000, msecs % 1000 * 1000 ).utc
      end
    end

  end
end