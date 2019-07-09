task :update_cron do
  sh "whenever --update-crontab"
end

task :create_image do
  require_relative "./lib/api_hektor"
  hektor = ApiHektor.new
  hektor.run
end
