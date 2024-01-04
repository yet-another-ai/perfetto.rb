# frozen_string_literal: true

module Perfetto
  # To intercept method calls in other classes
  module Interceptor
    def self.included(base)
      if Perfetto::Configure.enable_tracing
        base.extend ImplMethods
      else
        base.extend StubMethods
      end
    end

    # Stub methods
    module StubMethods
      def perfetto_trace_instance_method(_method_name); end
      def perfetto_trace_class_method(_method_name); end
      def perfetto_trace_all; end

      def perfetto_traced_instance_method?(_method_name)
        false
      end

      def perfetto_traced_class_method?(_method_name)
        false
      end

      def perfetto_traced_instance_methods
        []
      end

      def perfetto_traced_class_methods
        []
      end
    end

    # Real Implementation
    module ImplMethods
      def perfetto_trace_instance_method(method_name)
        return if method_name.to_s.start_with? "_pfi_"

        # warn "Perfetto[InstanceMethod]: #{name}##{method_name}"
        perfetto_traced_instance_methods << method_name

        original_method = instance_method(method_name)
        alias_method "_pfi_#{method_name}", method_name

        define_method(method_name) do |*args, **kwargs, &block|
          Perfetto.trace_event_begin self.class.name, method_name.to_s
          original_method.bind(self).call(*args, **kwargs, &block)
        ensure
          Perfetto.trace_event_end self.class.name
        end
      end

      def perfetto_trace_class_method(method_name)
        return if method_name.to_s == "singleton_method_added" || method_name.to_s.start_with?("_pfc_")

        # warn "Perfetto[ClassMethod]: #{name}.#{method_name}"
        perfetto_traced_class_methods << method_name

        original_method = method(method_name)
        singleton_class.send(:alias_method, "_pfc_#{method_name}", method_name)

        define_singleton_method(method_name) do |*args, **kwargs, &block|
          Perfetto.trace_event_begin name, method_name.to_s
          original_method.call(*args, **kwargs, &block)
        ensure
          Perfetto.trace_event_end name
        end
      end

      def perfetto_trace_all
        define_singleton_method(:method_added) do |method_name|
          return if perfetto_traced_instance_method?(method_name)

          perfetto_trace_instance_method method_name
        end

        define_singleton_method(:singleton_method_added) do |method_name|
          return if perfetto_traced_class_method?(method_name)

          perfetto_trace_class_method method_name
        end
      end

      def perfetto_traced_instance_method?(method_name)
        perfetto_traced_instance_methods.include? method_name
      end

      def perfetto_traced_class_method?(method_name)
        perfetto_traced_class_methods.include? method_name
      end

      def perfetto_traced_instance_methods
        @perfetto_traced_instance_methods ||= []
      end

      def perfetto_traced_class_methods
        @perfetto_traced_class_methods ||= []
      end
    end
  end
end
