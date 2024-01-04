# Perfetto

## Visualization

https://ui.perfetto.dev/

## Usage

### Basic

```ruby
require "perfetto"

Perfetto.setup enable_tracing: true

Perfetto.start_tracing

# Slice
# Stack frame is inferred from the begin event with the same category 'cpu_work'
Perfetto.trace_event_begin "cpu_work", "example_task"
sleep 0.1
Perfetto.trace_event_end "cpu_work"

# Slice with debug info
# Same as above, but "key"=>"value" is added to the event details
Perfetto.trace_event_begin_with_debug_info "cpu_work", "example_task2", "key", "value"
sleep 0.1
Perfetto.trace_event_end "cpu_work"

# Counter
10.times do |n|
  Perfetto.trace_counter "rendering", "frame_rate", n.even? ? 60 : 30
  sleep 0.1
end
Perfetto.trace_counter "rendering", "frame_rate", 0

# Instant
Perfetto.trace_event_instant "cpu_work", "example_instant"

sleep 0.1

# Instant with debug info
Perfetto.trace_event_instant_with_debug_info "cpu_work", "example_instant2", "key", "value"

sleep 0.1

class Foo
  # Intercept instance methods
  include Perfetto::Interceptor
  perfetto_trace_all

  def bar(a, b = 1, c: 2)
    yield(a + b + c)
  end

  def baz(x)
    puts x
    sleep 0.1
  end

  def self.buf
    puts "buf"
    sleep 0.1
  end
end

class Bar < Foo
  def say
    puts "hello"
    sleep 0.1
  end
end

f = Foo.new
b = Bar.new
f.bar(1, 2, c: 3) do |n|
  n.times do |x|
    f.baz x + n
    Foo.buf
    b.say
  end
end

Perfetto.stop_tracing "example.pftrace"
```

![example](./example/example.png)

### Rack Middleware

```ruby
# frozen_string_literal: true

require "sinatra/base"
require "perfetto"

class Server < Sinatra::Base
  use Perfetto::Middleware, env_proc: ->(env) { env.to_json }

  get "/" do
    "Hello World"
  end
end

Perfetto.setup enable_tracing: true
Perfetto.start_tracing
Server.run!
Perfetto.stop_tracing "middleware.pftrace"
```
