task :update_cron do
  sh "whenever --update-crontab"
end

task :create_image do
  require "./lib/api_hektor"
  hektor = ApiHektor.new
  hektor.test
end
