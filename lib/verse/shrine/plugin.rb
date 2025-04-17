# frozen_string_literal: true

require_relative "./adapters"

module Verse
  module Shrine
    class Plugin < Verse::Plugin::Base

      attr_reader :storages

      def description
        "Shrine integration with Verse."
      end

      def validate_config!
        @config = Config::Schema.dataclass.new(@config)
      end

      def init_file_storage
        @storages = {}

        @config.storages.each do |storage|
          ::Shrine.storages[storage.name] = storage.adapter.create

          @storages[storage.name] = Manager.new(storage.name)
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
