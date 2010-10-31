module Brightcove
  class DTOFormatter

    class << self

      def format( value, opts = {} )
        case value

        when String, Numeric, Symbol, TrueClass, FalseClass, NilClass
          value

        when Time
          # milliseconds since UNIX epoch
          value.to_i * 1000

        when Array
          formatted = value.collect { |element| format( element ) }
          opts[ :format ] == :comma_list ? formatted.join( "," ) : formatted

        when Hash
          Hash[ value.collect { |name, value| [ name, format( value ) ] } ]

        when Video, CuePoint, Rendition
          format_with_map value, DTOMaps.for_class( value.class )

        else
          raise "Can't format value of type '#{ value.class.name }'"
        end
      end

      def format_partial_object( klass, attrs )
        result = {}

        DTOMaps.for_class( klass ).each do |dto_name, name, type, opts|
          if attrs.has_key?( name )
            result[ dto_name ] = format( attrs[ name ], opts || {} )
          end
        end

        result
      end

    private

      def format_with_map( value, map )
        result = {}

        map.each do |dto_name, name, type, opts|
          result[ dto_name ] = format( value.send( name ), opts || {} )
        end

        result
      end

    end
  end
end