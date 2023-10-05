# frozen_string_literal: true

module Verse
  module Shrine
    module Config
      class Schema < Verse::Validation::Contract
        params do
          required(:adapter).filled(:string)
          required(:config).hash
        end

        rule(:adapter, :config) do
          result = \
            case values[:adapter]
            when "s3"
              S3Schema.new.call(values[:config])
            when "file_system"
              FileSystemSchema.new.call(values[:config])
            else
              raise "Unsupported adapter: `#{values[:adapter]}`"
            end

          key.failure("Failed to validate adapter config") if result.failure?
        end

      end
    end
  end
end
