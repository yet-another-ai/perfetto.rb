# frozen_string_literal: true

require "test_helper"

# rubocop:disable Naming/MethodParameterName
class Fixture
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

  include Perfetto::Interceptor
  pftrace_all
end
# rubocop:enable Naming/MethodParameterName

class TestInterceptor < Minitest::Test
  def setup
    @fixture = Fixture.new
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
end
