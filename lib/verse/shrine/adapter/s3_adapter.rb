require "pry"

module Verse
  module Shrine
    module Adapter
      S3Schema = Verse::Schema.define do
        field(:bucket, String)
        field(:access_key_id, String)
        field(:secret_access_key, String)

        field(:public, TrueClass).default(true)

        field?(:region, String)
        field?(:prefix, String)
        field?(:endpoint, String)
      end

      S3Adapter = S3Schema.dataclass do
        def create
          require "shrine/storage/s3"

          opts = {
            public:,
            bucket:,
            region:,
            access_key_id:,
            secret_access_key:,
            prefix:,
            endpoint:
          }.compact

          ::Shrine::Storage::S3.new(**opts)
        end
      end
    end
  end
end
