# frozen_string_literal: true

require "rack/test"
require "minitest/autorun"

require "sinatra/base"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "perfetto"

class TestServer < Sinatra::Base
  use Perfetto::Middleware, env_proc: ->(env) { env.to_json }

  get "/" do
    "Hello World"
  end
end

class TestMiddleware < Minitest::Test
  include Rack::Test::Methods

  def setup
    Perfetto.setup enable_tracing: true
    Perfetto.start_tracing
  end

  def teardown
    Perfetto.stop_tracing "test_middleware.pftrace"
  end

  def app
    TestServer
  end

  def test_that_middleware_works
    get "/"

    assert_predicate last_response, :ok?
  end
end