module Brightcove
  class Video < Model

    attr_accessor :name,
      :id,
      :reference_id,
      :account_id,
      :short_description,
      :long_description,
      :flv_url,
      :renditions,
      :video_full_length,
      :creation_date,
      :published_date,
      :last_modified_date,
      :item_state,
      :start_date,
      :end_date,
      :link_url,
      :link_text,
      :tags,
      :video_still_url,
      :thumbnail_url,
      :length,
      :custom_fields,
      :economics,
      :ad_keys, # format?
      :geo_restricted,
      :geo_filtered_countries,
      :geo_filter_exclude,
      :cue_points,
      :plays_total,
      :plays_trailing_week

    def initialize( *args )
      @renditions = []
      @tags = []
      @custom_fields = {}
      @geo_filtered_countries = []
      @cue_points = []
      super
    end

    class << self

      def find( id, opts = {} )
        service, opts = extract_service( opts )
        service.find_video_by_id( id, opts )
      end

      def find_first( opts = {} )
        service, opts = extract_service( opts )
        service.find_all_videos( opts.merge( :page_size => 1 ) ).first
      end

      def find_all( opts = {} )
        to_enum( :each, opts ).to_a
      end

      def find_modified_since( time, opts = {} )
        to_enum( :each_modified_since, time, opts ).to_a
      end

      def each( opts = {}, &block )
        service, opts = extract_service( opts )

        find_proc = lambda { |find_opts|
          service.find_all_videos( find_opts )
        }

        each_record find_proc, opts, &block
      end

      def each_modified_since( time, opts = {}, &block )
        service, opts = extract_service( opts )

        find_proc = lambda { |find_opts|
          service.find_modified_videos( time, find_opts )
        }

        each_record find_proc, opts, &block
      end

    private

      def extract_service( opts )
        opts = opts.dup
        service = opts.delete( :service ) || Brightcove.service
        [ service, opts ]
      end

      def each_record( find_proc, opts = {} )
        each_page( find_proc, opts ) do |page|
          page.each { |record| yield record }
        end
      end

      def each_page( find_proc, opts = {} )
        opts = opts.merge :page_size => 100
        i = -1

        while true
          i += 1
          results = find_proc.call opts.merge( :page_number => i )
          break if results.empty?
          yield results
        end
      end

    end
  end
end