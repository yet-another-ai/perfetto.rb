# frozen_string_literal: true

require "mkmf"

# Rubocop
# rubocop:disable Style/GlobalVars
$CXXFLAGS += " -std=c++17 -O3 -pthread"
$CFLAGS += " -std=c11 -O3 -pthread"
# rubocop:enable Style/GlobalVars

create_makefile "perfetto/perfetto"
