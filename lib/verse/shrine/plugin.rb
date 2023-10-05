# frozen_string_literal: true

module Verse
  module Shrine
    class Plugin < Verse::Plugin::Base

      def description
        "Shrine integration with Verse."
      end

      def on_init
        require "shrine"
      end

    end
  end
end
