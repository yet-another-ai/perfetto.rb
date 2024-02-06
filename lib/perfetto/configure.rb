# frozen_string_literal: true

module Perfetto
  # Global configuration
  class Configure
    extend Configurable

    set :enable_tracing, false
    set :enable_fiber, false
    set :buffer_size_kb, 1024
  end
end
