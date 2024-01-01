#include "sdk.h"

#include <memory>
#include <atomic>
#include <mutex>
#include <fstream>
#include <vector>
#include <string>

#include "perfetto_internal.h"

PERFETTO_DEFINE_CATEGORIES();
PERFETTO_TRACK_EVENT_STATIC_STORAGE();

static struct GlobalState
{
    std::unique_ptr<perfetto::TracingSession> tracing_session;
    bool is_initialized;
    bool is_tracing;
    std::mutex mutex;

    GlobalState() : tracing_session(nullptr), is_initialized(false), mutex()
    {
    }
} global_state;

extern "C"
{

    static inline void perfetto_initialize()
    {
        perfetto::TracingInitArgs args;
        args.backends = perfetto::kInProcessBackend;
        perfetto::Tracing::Initialize(args);
        perfetto::TrackEvent::Register();
        global_state.is_initialized = true;
    }

    bool perfetto_start_tracing(const uint32_t buffer_size_kb)
    {
        std::lock_guard<std::mutex> lock(global_state.mutex);

        if (global_state.is_tracing)
        {
            return false;
        }

        if (!global_state.is_initialized)
        {
            perfetto_initialize();
        }

        if (buffer_size_kb == 0)
        {
            return false;
        }

        perfetto::TraceConfig trace_config;
        trace_config.add_buffers()->set_size_kb(buffer_size_kb);
        auto *ds_config = trace_config.add_data_sources()->mutable_config();
        ds_config->set_name("track_event");

        auto tracing_session = perfetto::Tracing::NewTrace();
        tracing_session->Setup(trace_config);
        tracing_session->StartBlocking();

        global_state.tracing_session = std::move(tracing_session);
        global_state.is_tracing = true;
        return true;
    }

    bool perfetto_stop_tracing(const char *const output_file)
    {
        std::lock_guard<std::mutex> lock(global_state.mutex);
        if (!global_state.is_initialized || !global_state.is_tracing)
        {
            return false;
        }

        perfetto::TrackEvent::Flush();
        global_state.tracing_session->StopBlocking();
        std::vector<char> trace_data(global_state.tracing_session->ReadTraceBlocking());
        global_state.tracing_session.reset();
        global_state.is_tracing = false;

        try
        {
            std::ofstream output(output_file, std::ios::out | std::ios::binary);
            output.write(trace_data.data(), trace_data.size());
            output.close();
        }
        catch (std::exception &e)
        {
            return false;
        }

        return true;
    }

    void perfetto_trace_event_begin(const char *const category, const char *const name)
    {
        perfetto::DynamicCategory dynamic_category(category);
        perfetto::DynamicString dynamic_name(name);
        TRACE_EVENT_BEGIN(dynamic_category, dynamic_name);
    }

    void perfetto_trace_event_end(const char *const category)
    {
        perfetto::DynamicCategory dynamic_category(category);
        TRACE_EVENT_END(dynamic_category);
    }

    void perfetto_trace_counter_i64(const char *const category, const char *const name, const int64_t value)
    {
        perfetto::DynamicCategory dynamic_category(category);
        perfetto::DynamicString dynamic_name(name);
        TRACE_COUNTER(dynamic_category, perfetto::CounterTrack(name), value);
    }

    void perfetto_trace_counter_double(const char *const category, const char *const name, const double value)
    {
        perfetto::DynamicCategory dynamic_category(category);
        TRACE_COUNTER(dynamic_category, perfetto::CounterTrack(name), value);
    }

    void perfetto_trace_event_instant(const char *const category, const char *const name)
    {
        perfetto::DynamicCategory dynamic_category(category);
        perfetto::DynamicString dynamic_name(name);
        TRACE_EVENT_INSTANT(dynamic_category, dynamic_name);
    }

    void perfetto_trace_event_instant_with_debug_info(const char *const category, const char *const name, const char *const debug_info_key, const char *const debug_info_value)
    {
        perfetto::DynamicCategory dynamic_category(category);
        perfetto::DynamicString dynamic_name(name);
        TRACE_EVENT_INSTANT(dynamic_category, dynamic_name,
                            debug_info_key, debug_info_value);
    }

    void perfetto_trace_event_begin_with_debug_info(const char *const category, const char *const name, const char *const debug_info_key, const char *const debug_info_value)
    {
        perfetto::DynamicCategory dynamic_category(category);
        perfetto::DynamicString dynamic_name(name);
        TRACE_EVENT_BEGIN(dynamic_category, dynamic_name,
                          debug_info_key, debug_info_value);
    }

} // extern "C"
