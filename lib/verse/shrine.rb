# frozen_string_literal: true

require "verse/core"
require_relative "shrine/version"

module Verse
  module Shrine
  end
end

Dir["#{__dir__}/**/*.rb"].sort.each do |file|
  # do not load CLI nor specs files unless told otherwise.
  next if file =~ /(cli|spec)\.rb$/ ||
          file[__dir__.size..] =~ %r{^/(?:cli|spec)}

  require_relative file
end
