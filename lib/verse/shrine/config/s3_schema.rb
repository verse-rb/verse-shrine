module Verse
  module Shrine
    module Config
      S3Schema = Verse::Schema.define do
        field(:bucket, String)
        field(:access_key_id, String)
        field(:secret_access_key, String)

        field(:public, TrueClass).default(true)

        field?(:region, String)
        field?(:prefix, String)
        field?(:endpoint, String)
      end
    end
  end
end
