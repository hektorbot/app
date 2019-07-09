set :output, 'log/cron.log'

every 1.minute do
  rake "create_image"
end
