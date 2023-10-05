# frozen_string_literal: true

module Verse
  module Shrine
    class Manager

      attr_reader :adapter

      FileInfo = Struct.new(
        :filename, :size,
        :mime_type, :id,
        :file_url,
        keyword_init: true
      )

      def initialize(adapter)
        @adapter = adapter
      end

      def upload(file)
        file_info = ::Shrine.upload(file, @adapter)

        FileInfo.new(file_info.metadata.merge(
          "id"  => file_info.id,
          "file_url" =>  file_info.url
        ))
      end

      def open(file_id)
        ::Shrine.storages[@adapter].open(file_id)
      end

      def uploaded_file(file_id, metadata)
        ::Shrine::UploadedFile.new(
          {
            id: file_id,
            storage: @adapter,
            metadata: metadata
          }
        )
      end

      def delete(file_id)
        ::Shrine.storages[@adapter].delete(file_id)
      end
    end
  end
end
