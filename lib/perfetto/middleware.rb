# frozen_string_literal: true

require "json"

module Perfetto
  # Rack middleware
  class Middleware
    def initialize(app, options = {})
      @app = app
      @options = options
    end

    if Perfetto::Configure.enable_tracing
      def call(env)
        category = "RackMiddleware"
        method = env["REQUEST_METHOD"] || "UNKNOWN"
        path = env["PATH_INFO"] || "UNKNOWN PATH"
        task_name = "#{method} #{path}"
        Perfetto.trace_event_begin_with_debug_info category, task_name, "env", env.to_json
        begin
          @app.call(env)
        ensure
          Perfetto.trace_event_end category
        end
      end
    else # Stub methods
      def call(env)
        @app.call(env)
      end
    end
  end
end
