module Brightcove
  module DTOMaps

    def self.for_class( klass )
      if klass == Video
        VIDEO
      elsif klass == CuePoint
        CUE_POINT
      elsif klass == Rendition
        RENDITION
      else
        raise "No DTO map for objects of type '#{ klass.name }'"
      end
    end

    # dto_name, internal_name, internal_type, hints

    VIDEO = [
      [ 'name', :name, :string ],
      [ 'id', :id, :integer ],
      [ 'referenceId', :reference_id, :string ],
      [ 'accountId', :account_id, :integer ],
      [ 'shortDescription', :short_description, :string ],
      [ 'longDescription', :long_description, :string ],
      [ 'FLVURL', :flv_url, :string ],
      [ 'renditions', :renditions, :array, { :type => :rendition } ],
      [ 'videoFullLength', :video_full_length, :rendition ],
      [ 'creationDate', :creation_date, :time ],
      [ 'publishedDate', :published_date, :time ],
      [ 'lastModifiedDate', :last_modified_date, :time ],
      [ 'itemState', :item_state, :string ],
      [ 'startDate', :start_date, :time ],
      [ 'endDate', :end_date, :time ],
      [ 'linkURL', :link_url, :string ],
      [ 'linkText', :link_text, :string ],
      [ 'tags', :tags, :array, { :type => :string } ],
      [ 'videoStillURL', :video_still_url, :string ],
      [ 'thumbnailURL', :thumbnail_url, :string ],
      [ 'length', :length, :integer ],
      [ 'customFields', :custom_fields, :hash ],
      [ 'economics', :economics, :string ],
      [ 'adKeys', :ad_keys, :string ], #?
      [ 'geoRestricted', :geo_restricted, :boolean ],
      [ 'geoFilteredCountries', :geo_filtered_countries, :array, { :type => :string } ],
      [ 'geoFilterExclude', :geo_filter_exclude, :boolean ],
      [ 'cuePoints', :cue_points, :array, { :type => :cue_point } ],
      [ 'playsTotal', :plays_total, :integer ],
      [ 'playsTrailingWeek', :plays_trailing_week, :integer ]
    ]

    RENDITION = [
      [ 'url', :url, :string ],
      [ 'controllerType', :controller_type, :string ],
      [ 'encodingRate', :encoding_rate, :integer ],
      [ 'frameHeight', :frame_height, :integer ],
      [ 'frameWidth', :frame_width, :integer ],
      [ 'size', :size, :long ],
      [ 'remoteUrl', :remote_url, :string ],
      [ 'remoteStreamName', :remote_stream_name, :string ],
      [ 'videoDuration', :video_duration, :long ],
      [ 'videoCodec', :video_codec, :string ],
      [ 'displayName', :display_name, :string ]
    ]

    CUE_POINT = [
      [ 'name', :name, :string ],
      [ 'videoId', :array, { :type => :integer, :format => :comma_list } ],
      [ 'time', :time, :long ],
      [ 'forceStop', :force_stop, :boolean ],
      [ 'type', :type, :string ],
      [ 'metadata', :metadata, :string ]
    ]

    PLAYLIST = [
      [ 'id', :id, :long ],
      [ 'referenceId', :reference_id, :string ],
      [ 'accountId', :account_id, :long ],
      [ 'name', :name, :string ],
      [ 'shortDescription', :short_description, :string ],
      [ 'videoIds', :video_ids, :array ],
      [ 'videos', :videos, :array, { :type => :video } ],
      [ 'playlistType', :playlist_type, :string ],
      [ 'filterTags', :filter_tags, :array ],
      [ 'thumbnailURL', :thumbnail_url, :string ]
    ]

  end
end