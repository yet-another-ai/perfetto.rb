# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "perfetto"

require "minitest/autorun"

Perfetto.setup enable_tracing: true
