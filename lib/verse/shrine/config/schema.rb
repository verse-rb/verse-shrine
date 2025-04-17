# frozen_string_literal: true

module Verse
  module Shrine
    module Config
      Schema = Verse::Schema.define do
        field(:storages, Array) do
          field(:name, Symbol)
          field(:adapter, Symbol)
          field(:config, Hash)

          transform do |hash, error_builder|
            hash[:adapter] = Adapters.fetch(hash[:adapter]) do
              error.add(:adapter, "unsupported adapter: `#{hash[:adapter]}`")
              next
            end.yield_self do |adapter|
              adapter.new(hash[:config])
            end

            hash
          end

        end
      end
    end
  end
end
