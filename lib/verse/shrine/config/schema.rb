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
          result = \
            case value[:adapter]
            when "s3"
              S3Schema.new.call(value[:config])
            when "file_system"
              FileSystemSchema.new.call(value[:config])
            else
              key([:storages, index, :adapter]).failure("Unsupported adapter: `#{value[:adapter]}`")
            end

          key([:storages, index]).failure("Failed to validate adapter config") if result.failure?
        end

      end
    end
  end
end
