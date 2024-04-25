# frozen_string_literal: true

module Verse
  module Shrine
    module Config
      Schema = Verse::Schema.define do
        field(:storages, Array) do
          field(:name, String)
          field(:adapter, String)
          field(:config, Hash)


          rule("adapter match") do |hash, error|
            schema, _ = Plugin::ADAPTERS.fetch(hash[:adapter]) do
              error.add(:adapter, "Unsupported adapter: `#{hash[:adapter]}`")
              next false
            end

            schema.validate(hash[:config], error_builder: error)

            true
          end
        end
      end
    end
  end
end
