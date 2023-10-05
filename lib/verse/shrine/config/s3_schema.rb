module Verse
  module Shrine
    module Config
      class S3Schema < Verse::Validation::Contract
        params do
          required(:bucket).filled(:string)
          required(:access_key_id).filled(:string)
          required(:secret_access_key).filled(:string)

          optional(:public).filled(:string) # default true

          optional(:region).filled(:string)
          optional(:prefix).filled(:string)
          optional(:endpoint).filled(:string)
        end

      end
    end
  end
end
