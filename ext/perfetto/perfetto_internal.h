#ifndef _RUBY_PERFETTO_INTERNAL_H_
#define _RUBY_PERFETTO_INTERNAL_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdint.h>
#include <string.h>
#include <stdlib.h>

    /* C Interface */

    bool perfetto_start_tracing(const uint32_t buffer_size_kb);

    bool perfetto_stop_tracing(const char *const output_file);

    void perfetto_trace_event_begin(const char *const category, const char *const name);

    void perfetto_trace_event_end(const char *const category);

    void perfetto_trace_counter_i64(const char *const category, const char *const name, const int64_t value);

    void perfetto_trace_counter_double(const char *const category, const char *const name, const double value);

    void perfetto_trace_event_instant(const char *const category, const char *const name);

    void perfetto_trace_event_instant_with_debug_info(const char *const category, const char *const name, const char *const debug_info_key, const char *const debug_info_value);

    void perfetto_trace_event_begin_with_debug_info(const char *const category, const char *const name, const char *const debug_info_key, const char *const debug_info_value);
#ifdef __cplusplus
}
#endif

#endif // _RUBY_PERFETTO_INTERNAL_H_