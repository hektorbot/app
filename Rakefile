task :update_cron do
  sh "crontab -r"
  sh "whenever --update-crontab"
end

task :create_image do
  require_relative "./lib/api_hektor"
  hektor = ApiHektor.new
  hektor.run true
end
