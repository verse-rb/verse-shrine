# frozen_string_literal: true

module Verse
  module Shrine
    class Plugin < Verse::Plugin::Base

      attr_reader :storages

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
          adapter = \
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

              ::Shrine::Storage::S3.new(**opts)
            when "file_system"
              require "shrine/storage/file_system"
              ::Shrine::Storage::FileSystem.new(config.dig(:config, :path), prefix: config.dig(:config, :prefix) || "")
            else
              raise NotImplementedError, "adapter not found: #{adapter}"
            end

          ::Shrine.storages[config[:name].to_sym] = adapter
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
