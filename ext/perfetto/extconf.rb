# frozen_string_literal: true

require "mkmf"

# Rubocop
# rubocop:disable Style/GlobalVars
$CXXFLAGS += " -std=c++17 -O3 -pthread"
# rubocop:enable Style/GlobalVars
append_cflags(["-std=c11", "-O3", "-pthread"])

create_makefile "perfetto/perfetto_native"
