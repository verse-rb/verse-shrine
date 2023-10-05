module Verse
  module Shrine
    module Config
      class FileSystemSchema < Verse::Validation::Contract
        params do
          required(:path).filled(:string)
          optional(:prefix).filled(:string)
        end

      end
    end
  end
end
