module Verse
  module Shrine
    module Adapter
      octal_rule = Verse::Schema.rule("must be octal") do |value|
        value =~ /\A[0-7]+\z/
      end

      FileSystemSchema = Verse::Schema.define do
        field(:path, String)
        field?(:prefix, String)

        field?(:directory_permissions, String).rule(octal_rule)
        field?(:permissions, String).rule(octal_rule)
      end


      FileSystemAdapter = FileSystemSchema.dataclass do
        def create
          require "shrine/storage/file_system"

          opts = {
            prefix:,
            permissions: permissions&.to_i(8),
            directory_permissions: directory_permissions&.to_i(8)
          }.compact

          ::Shrine::Storage::FileSystem.new(path, **opts)
        end
      end

    end
  end
end
