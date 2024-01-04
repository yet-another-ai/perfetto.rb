# frozen_string_literal: true

module Perfetto
  # Rack middleware
  class Middleware
    def initialize(app, options = {})
      @app = app
      @options = options
      @env_proc = options[:env_proc]
    end

    # rubocop:disable Metrics/MethodLength
    def perfetto_traced_call(env)
      category = "RackMiddleware"
      method = env["REQUEST_METHOD"] || "UNKNOWN"
      path = env["PATH_INFO"] || "UNKNOWN PATH"
      task_name = "#{method} #{path}"
      env_str = @env_proc&.call(env) || { env: "unknown" }.to_json

      Perfetto.trace_event_begin_with_debug_info category, task_name, "env", env_str
      begin
        @app.call(env)
      ensure
        Perfetto.trace_event_end category
      end
    end
    # rubocop:enable Metrics/MethodLength

    def call(env)
      if Perfetto::Configure.enable_tracing
        perfetto_traced_call(env)
      else
        @app.call(env)
      end
    end
  end
end
