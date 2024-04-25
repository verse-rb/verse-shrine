module Verse
  module Shrine
    module Config
      FileSystemSchema = Verse::Schema.define do
        field(:path, String)
        field?(:prefix, String)
        field?(:directory_permissions, String)
        field?(:permissions, String)
      end
    end
  end
end
