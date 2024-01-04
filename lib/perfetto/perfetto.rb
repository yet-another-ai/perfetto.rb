# frozen_string_literal: true

# Ruby wrapper for native extension
module Perfetto
  class << self
    alias start_tracing_native start_tracing
    alias stop_tracing_native stop_tracing
  end

  if Perfetto::Configure.enable_tracing
    # Default arguments implemented in this wrapper
    def self.start_tracing
      start_tracing_native Configure.buffer_size_kb
    end

    def self.stop_tracing(trace_file_name = "#{Time.now.strftime("%Y%m%d-%H-%M-%S")}.pftrace")
      stop_tracing_native trace_file_name
    end

    # Methods implemented in native extension
    # We don't want to proxy these methods because they are called very frequently on hot paths
    #   def self.start_tracing; end
    #   def self.stop_tracing(_trace_file_name); end
    #   def self.trace_event_begin(_class_name, _method_name); end
    #   def self.trace_event_end(_class_name); end
    #   def self.trace_counter(_class_name, _counter_name, _counter_value); end
    #   def self.trace_counter_i64(_class_name, _counter_name, _counter_value); end
    #   def self.trace_counter_double(_class_name, _counter_name, _counter_value); end
    #   def self.trace_event_instant(_class_name, _method_name); end
    #   def self.trace_event_begin_with_debug_info(_class_name, _method_name, _debug_key, _debug_value); end
    #   def self.trace_event_instant_with_debug_info(_class_name, _method_name, _debug_key, _debug_value); end
  else
    # Stub methods
    def self.start_tracing; end
    def self.stop_tracing(trace_file_name = nil); end
    def self.trace_event_begin(_class_name, _method_name); end
    def self.trace_event_end(_class_name); end
    def self.trace_counter(_class_name, _counter_name, _counter_value); end
    def self.trace_counter_i64(_class_name, _counter_name, _counter_value); end
    def self.trace_counter_double(_class_name, _counter_name, _counter_value); end
    def self.trace_event_instant(_class_name, _method_name); end
    def self.trace_event_begin_with_debug_info(_class_name, _method_name, _debug_key, _debug_value); end
    def self.trace_event_instant_with_debug_info(_class_name, _method_name, _debug_key, _debug_value); end
  end
end
