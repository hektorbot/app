task :update_cron do
  begin
    sh "crontab -r"
  ensure
    sh "whenever --update-crontab"
  end
end

task :create_image do
  require_relative "./lib/api_hektor"
  hektor = ApiHektor.new
  hektor.run
end
