# frozen_string_literal: true

module Verse
  module Shrine
    class Plugin < Verse::Plugin::Base

      attr_reader :storages

      ADAPTERS = {
        "s3" => [Config::S3Schema, -> (config) {
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

          ::Shrine::Storage::S3.new(**opts)
        }],
        "file_system" => [Config::FileSystemSchema, -> (config) {
          require "shrine/storage/file_system"

          path = config[:path]
          prefix = config[:prefix]

          opts = {
            prefix: config[:prefix],
            permissions: config[:permissions]&.to_i(8),
            directory_permissions: config[:directory_permissions]&.to_i(8)
          }.compact

          ::Shrine::Storage::FileSystem.new(path, **opts )
        }]
      }

      def description
        "Shrine integration with Verse."
      end

      def validate_config!
        result = Config::Schema.new.call(config)

        unless result.success?
          raise "Invalid config for shrine plugin: #{result.errors.messages.map(&:text).join(" ")}"
        end
      end

      def init_file_storage
        @storages = {}

        config.fetch(:storages).each do |config|

          _, adapter = ADAPTERS.fetch(config.fetch(:adapter)) {
            raise "Unsupported adapter: `#{config.fetch(:adapter)}`"
          }

          ::Shrine.storages[config[:name].to_sym] = \
            adapter.call(config.fetch(:config))

          @storages[config[:name].to_sym] = Manager.new(config[:name].to_sym)
        end
      end

      def on_init
        require "shrine"

        validate_config!
        init_file_storage
      end

      def storage(storage = :default)
        @storages.fetch(storage) do
          raise "Storage not found: `#{storage}`"
        end
      end

      def with_storage(storage = :default)
        yield self.storage(storage)
      end

    end
  end
end
