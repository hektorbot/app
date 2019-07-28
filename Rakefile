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

task :get_videos do
  require_relative "./lib/api_hektor"
  hektor = ApiHektor.new
  p hektor.arlo.get_videos (Time.now - 24*HEURE).strftime("%Y%m%d"), (Time.now).strftime("%Y%m%d")
end
