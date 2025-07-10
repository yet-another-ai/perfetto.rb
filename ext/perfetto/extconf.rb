# frozen_string_literal: true

require "mkmf"

# Rubocop
append_cppflags(["-std=c++17", "-O3", "-pthread"])
append_cflags(["-std=c11", "-O3", "-pthread"])

create_makefile "perfetto/perfetto_native"
