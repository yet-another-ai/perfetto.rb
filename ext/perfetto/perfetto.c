#include <ruby.h>

#include "perfetto_internal.h"

/* Modules */
static VALUE rb_mPerfetto;

/* Methods */

static VALUE rb_perfetto_start_tracing(VALUE self, VALUE buffer_size_kb)
{
    return perfetto_start_tracing(NUM2UINT(buffer_size_kb)) ? Qtrue : Qfalse;
}

static VALUE rb_perfetto_stop_tracing(VALUE self, VALUE output_file)
{
    return perfetto_stop_tracing(StringValuePtr(output_file)) ? Qtrue : Qfalse;
}

static VALUE rb_perfetto_trace_event_begin(VALUE self, VALUE category, VALUE name)
{
    perfetto_trace_event_begin(StringValuePtr(category), StringValuePtr(name));
    return Qnil;
}

static VALUE rb_perfetto_trace_event_end(VALUE self, VALUE category)
{
    perfetto_trace_event_end(StringValuePtr(category));
    return Qnil;
}

static VALUE rb_perfetto_trace_counter_i64(VALUE self, VALUE category, VALUE name, VALUE value)
{
    perfetto_trace_counter_i64(StringValuePtr(category), StringValuePtr(name), NUM2LL(value));
    return Qnil;
}

static VALUE rb_perfetto_trace_counter_double(VALUE self, VALUE category, VALUE name, VALUE value)
{
    perfetto_trace_counter_double(StringValuePtr(category), StringValuePtr(name), NUM2DBL(value));
    return Qnil;
}

static VALUE rb_perfetto_trace_event_instant(VALUE self, VALUE category, VALUE name)
{
    perfetto_trace_event_instant(StringValuePtr(category), StringValuePtr(name));
    return Qnil;
}

static VALUE rb_perfetto_trace_event_instant_with_debug_info(VALUE self, VALUE category, VALUE name, VALUE debug_info_key, VALUE debug_info_value)
{
    perfetto_trace_event_instant_with_debug_info(StringValuePtr(category), StringValuePtr(name), StringValuePtr(debug_info_key), StringValuePtr(debug_info_value));
    return Qnil;
}

static VALUE rb_perfetto_trace_event_begin_with_debug_info(VALUE self, VALUE category, VALUE name, VALUE debug_info_key, VALUE debug_info_value)
{
    perfetto_trace_event_begin_with_debug_info(StringValuePtr(category), StringValuePtr(name), StringValuePtr(debug_info_key), StringValuePtr(debug_info_value));
    return Qnil;
}

static VALUE rb_perfetto_trace_counter(VALUE self, VALUE category, VALUE name, VALUE value)
{
    if (TYPE(value) == T_FIXNUM)
    {
        return rb_perfetto_trace_counter_i64(self, category, name, value);
    }
    else if (TYPE(value) == T_FLOAT)
    {
        return rb_perfetto_trace_counter_double(self, category, name, value);
    }
    else
    {
        rb_raise(rb_eTypeError, "Value must be a Fixnum or Float");
    }
}

void Init_perfetto(void)
{
    rb_mPerfetto = rb_define_module("Perfetto");

    rb_define_module_function(rb_mPerfetto, "start_tracing", rb_perfetto_start_tracing, 1);
    rb_define_module_function(rb_mPerfetto, "stop_tracing", rb_perfetto_stop_tracing, 1);
    rb_define_module_function(rb_mPerfetto, "trace_event_begin", rb_perfetto_trace_event_begin, 2);
    rb_define_module_function(rb_mPerfetto, "trace_event_end", rb_perfetto_trace_event_end, 1);
    rb_define_module_function(rb_mPerfetto, "trace_counter_i64", rb_perfetto_trace_counter_i64, 3);
    rb_define_module_function(rb_mPerfetto, "trace_counter_double", rb_perfetto_trace_counter_double, 3);
    rb_define_module_function(rb_mPerfetto, "trace_counter", rb_perfetto_trace_counter, 3);
    rb_define_module_function(rb_mPerfetto, "trace_event_instant", rb_perfetto_trace_event_instant, 2);
    rb_define_module_function(rb_mPerfetto, "trace_event_instant_with_debug_info", rb_perfetto_trace_event_instant_with_debug_info, 4);
    rb_define_module_function(rb_mPerfetto, "trace_event_begin_with_debug_info", rb_perfetto_trace_event_begin_with_debug_info, 4);
}