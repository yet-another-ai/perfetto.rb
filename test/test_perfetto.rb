# frozen_string_literal: true

require "test_helper"

class TestPerfetto < Minitest::Test

  def setup
    Perfetto::start_tracing 1024
  end

  def test_that_it_has_a_version_number
    refute_nil ::Perfetto::VERSION
  end

  def test_that_trace_event_works
    Perfetto::trace_event_begin 'test_category', 'test_task'
    Perfetto::trace_event_end 'test_category'
    Perfetto::stop_tracing 'test_trace_event.pftrace'
  end

  def test_that_trace_counter_works
    (1..100).each do |i|
      Perfetto::trace_counter 'test_category', 'test_counter_i64', i % 2 == 0 ? 1 : -1
      Perfetto::trace_counter 'test_category', 'test_counter_dobule', i % 2 == 0 ? 10.0 : -10.0
    end
    Perfetto::stop_tracing 'test_trace_counter.pftrace'
  end

  def test_that_trace_event_instant_works
    (1..10).each do |i|
      Perfetto::trace_event_instant 'test_category', 'test_instant'
    end
    Perfetto::stop_tracing 'test_trace_event_instant.pftrace'
  end

  def test_that_trace_event_with_debug_info_works
    Perfetto::trace_event_begin_with_debug_info 'test_category', 'test_task', 'debug_key', 'debug_value'
    Perfetto::trace_event_end 'test_category'
    Perfetto::stop_tracing 'test_trace_event_with_debug_info.pftrace'
  end

  def test_that_trace_event_instant_with_debug_info_works
    (1..10).each do |i|
      Perfetto::trace_event_instant_with_debug_info 'test_category', 'test_instant', 'debug_key', "#{i} debug_value"
    end
    Perfetto::stop_tracing 'test_trace_event_instant_with_debug_info.pftrace'
  end
end
