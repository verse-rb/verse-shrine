# frozen_string_literal: true

module Verse
  module Shrine
    class Plugin < Verse::Plugin::Base

      attr_reader :file_storage

      def description
        "Shrine integration with Verse."
      end

      def validate_config!
        result = Config::Schema.new.call(config)

        unless result.success?
          raise "Invalid config for shrine plugin: #{result.errors}"
        end
      end

      def init_file_storage
        @file_storage = \
        case config.fetch(:adapter)
        when "s3"
          opts = {
            public: config.fetch(:public, true),
            bucket: config.fetch(:bucket),
            region: config.fetch(:region),
            access_key_id: config.fetch(:access_key_id),
            secret_access_key: config.fetch(:secret_access_key),
            prefix: config.fetch(:prefix, nil),
            endpoint: config.fetch(:endpoint, nil)
          }.compact

          require "shrine/storage/s3"

          Shrine::Storage::S3.new(**opts)
        when "file_system"
          Shrine::Storage::FileSystem.new(config.fetch(:path), prefix: config.fetch(:prefix, ""))
        else
          raise NotImplementedError, "adapter not found: #{adapter}"
        end
      end

      def on_init
        require "shrine"

        validate_config!
        init_file_storage
      end

    end
  end
end
