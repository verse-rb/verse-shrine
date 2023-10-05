# frozen_string_literal: true

module Verse
  module Shrine
    module Config
      class Schema < Verse::Validation::Contract
        params do
          required(:storages).value(:array).each do
            hash do
              required(:name).filled(:string)
              required(:adapter).filled(:string)
              required(:config).hash
            end
          end
        end

        rule(:storages).each do |index:|
          schema, _ = Plugin::ADAPTERS.fetch(value[:adapter]) do
            key([:storages, index, :adapter]).failure("Unsupported adapter: `#{value[:adapter]}`")
            nil
          end

          next unless schema

          result = schema.new.call(value[:config])

          key([:storages, index]).failure("Failed to validate adapter config") if result.failure?
        end

      end
    end
  end
end
