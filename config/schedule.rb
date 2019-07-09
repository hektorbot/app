set :output, 'log/cron.log'

every 15.minute do
  rake "create_image"
end
