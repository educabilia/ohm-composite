ENV["REDIS_URL"] = "redis://localhost:6379/15"

require "cutest"

$VERBOSE = 1

require_relative "../lib/ohm/composite"

setup do
  Ohm.flush
end
