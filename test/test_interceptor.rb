# frozen_string_literal: true

require "test_helper"

# rubocop:disable Naming/MethodParameterName
class Fixture
  include Perfetto::Interceptor
  perfetto_trace_all

  def func
    puts "func"
  end

  def func_with_args(a, b = nil, c: nil)
    puts "func_with_args"
    raise "args not given" if a.nil? || b.nil? || c.nil?
  end

  def func_with_block
    puts "func_with_block"
    raise "block not given" unless block_given?

    a = "yield to block"
    yield a
  end

  def func_with_block_and_args(a, b = nil, c: nil)
    puts "func_with_block_and_args"
    raise "args not given" if a.nil? || b.nil? || c.nil?
    raise "block not given" unless block_given?

    d = "yield to block"
    yield d
  end

  def func_returning_value
    puts "func_returning_value"
    "value"
  end

  class DummyError < StandardError; end

  def func_raising_exception
    puts "func_raising_exception"
    raise DummyError
  end

  def self.class_func
    puts "class_func"
  end
end

class Fixture2 < Fixture
  def func2
    puts "func2"
    func
  end
end

class Fixture3 < Fixture2
  def func
    puts "overridden func"
  end
end

class Fixture4
  include Perfetto::Interceptor
  perfetto_trace_all
  define_method(:func) do
    puts "dynamic func"
  end
end

# rubocop:enable Naming/MethodParameterName

class TestInterceptor < Minitest::Test
  def setup
    @fixture = Fixture.new
    @fixture2 = Fixture2.new
    @fixture3 = Fixture3.new
    @fixture4 = Fixture4.new
    Perfetto.start_tracing
  end

  def teardown
    @fixture = nil
  end

  def test_that_trival_func_works
    10.times do
      @fixture.func
    end
    Perfetto.stop_tracing "test_trival_func.pftrace"
  end

  def test_that_func_with_args_works
    10.times do
      @fixture.func_with_args(1, 2, c: 3)
    end
    Perfetto.stop_tracing "test_func_with_args.pftrace"
  end

  def test_that_func_with_block_works
    10.times do |i|
      @fixture.func_with_block do |a|
        puts "#{a} #{i}"
      end
    end
    Perfetto.stop_tracing "test_func_with_block.pftrace"
  end

  def test_that_func_with_block_and_args_works
    10.times do |i|
      @fixture.func_with_block_and_args(1, 2, c: 3) do |a|
        puts "#{a} #{i}"
      end
    end
    Perfetto.stop_tracing "test_func_with_block_and_args.pftrace"
  end

  def test_that_func_returning_value_works
    assert_equal "value", @fixture.func_returning_value
    Perfetto.stop_tracing "test_func_returning_value.pftrace"
  end

  def test_that_func_raising_exception_works
    assert_raises(Fixture::DummyError) do
      @fixture.func_raising_exception
    end
    Perfetto.stop_tracing "test_func_raising_exception.pftrace"
  end

  def test_that_class_func_works
    10.times do
      Fixture.class_func
    end
    Perfetto.stop_tracing "test_class_func.pftrace"
  end

  def test_that_inherited_func_works
    10.times do
      @fixture2.func2
    end
    Perfetto.stop_tracing "test_inherited_func.pftrace"
  end

  def test_that_overridden_func_works
    10.times do
      @fixture3.func
    end
    Perfetto.stop_tracing "test_overridden_func.pftrace"
  end

  def test_that_dynamic_func_works
    10.times do
      @fixture4.func
    end
    Perfetto.stop_tracing "test_dynamic_func.pftrace"
  end
end
