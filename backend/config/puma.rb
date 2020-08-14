workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 16)
threads 8, threads_count

preload_app!
tag 'ENFLOW'

rackup      DefaultRackup
port         3000
daemonize    false
environment 'development'
pidfile     'tmp/pids/puma.pid'
state_path  'tmp/pids/puma.state'

worker_timeout 6000

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
