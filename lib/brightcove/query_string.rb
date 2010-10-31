module Brightcove

  class QueryString

    class << self

      def build( token, method, params = {} )
        format params.merge( :command => method, :token => token )
      end

    private

      def format( value )
        case value
        when String
          value

        when Numeric, Symbol
          value.to_s

        when TrueClass, FalseClass
          value ? "true" : "false"

        when Time
          # minutes since UNIX epoch
          ( value.to_i / 60 ).to_s

        when Array
          value.each { |element| format( element ) }.join( "," )

        when Hash
          value.collect do |name, value|
            "#{ CGI.escape( name.to_s ) }=#{ CGI.escape( format( value ) ) }"
          end.join( "&" )

        else
          raise "Can't include value of type '#{ value.class.name }' in query request"
        end
      end

    end
  end
end