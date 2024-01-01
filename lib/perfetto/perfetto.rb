# frozen_string_literal: true

# Ruby wrapper for native extension
module Perfetto
  class << self
    alias start_tracing_native start_tracing
    alias stop_tracing_native stop_tracing
  end

  def self.start_tracing(buffer_size_kb = 1024)
    start_tracing_native buffer_size_kb
  end

  def self.stop_tracing(trace_file_name = "perfetto.pftrace")
    stop_tracing_native trace_file_name
  end
end
