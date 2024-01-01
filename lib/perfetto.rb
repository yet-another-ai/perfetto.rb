# frozen_string_literal: true

require_relative "perfetto/version"

# Native extension
require_relative "perfetto/perfetto"

module Perfetto
  class Error < StandardError; end
end
