# This file is used by Rack-based servers to start the application.

# Unicorn self-process killer
require 'unicorn/worker_killer'

max_request_min =  ENV['UNICORN_MAX_REQUEST_MIN']&.to_i || 100
max_request_max =  ENV['UNICORN_MAX_REQUEST_MAX']&.to_i || 120

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

oom_min = ((ENV['UNICORN_OOM_MIN']&.to_i || 250) * (1024**2))
oom_max = ((ENV['UNICORN_OOM_MAX']&.to_i || 300) * (1024**2))

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, oom_min, oom_max

require_relative 'config/environment'

run Rails.application
