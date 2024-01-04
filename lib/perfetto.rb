# frozen_string_literal: true

require_relative "perfetto/version"

require_relative "perfetto/core_ext/configurable"
require_relative "perfetto/configure"

# To minimize the overhead of tracing at runtime
# we determine whether to enable instrumentations
# at the first call to 'setup' method instead of
# every call to bussiness logics being traced.
module Perfetto
  def self.setup(enable_tracing: nil, buffer_size_kb: nil)
    Configure.enable_tracing = enable_tracing unless enable_tracing.nil?
    Configure.buffer_size_kb = buffer_size_kb unless buffer_size_kb.nil?

    # Native extension
    require_relative "perfetto/perfetto_native"
    # Ruby wrapper
    require_relative "perfetto/perfetto"
    # Instrumentation Helper
    require_relative "perfetto/interceptor"
    # Rack middleware
    require_relative "perfetto/middleware"
  end
end
