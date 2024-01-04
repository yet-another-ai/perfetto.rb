# frozen_string_literal: true

module Perfetto
  # To intercept method calls in other classes
  module Interceptor
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class methods for the interceptor
    module ClassMethods
      if Perfetto::Configure.enable_tracing
        def pftrace(method_name)
          original_method = instance_method(method_name)
          alias_method "pftrace_#{method_name}", method_name
          define_method(method_name) do |*args, **kwargs, &block|
            Perfetto.trace_event_begin self.class.name, method_name.to_s
            original_method.bind(self).call(*args, **kwargs, &block)
          ensure
            Perfetto.trace_event_end self.class.name
          end
        end

        def pftrace_all
          instance_methods(false).each do |method_name|
            pftrace method_name
          end
        end
      else # When tracing is disabled
        def pftrace(_method_name); end
        def pftrace_all; end
      end
    end
  end
end
