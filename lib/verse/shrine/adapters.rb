require_relative "./adapter/s3_adapter"
require_relative "./adapter/file_system_adapter"

module Verse
  module Shrine
    Adapters = {
      s3: Adapter::S3Adapter,
      file_system: Adapter::FileSystemAdapter
    }
  end
end
