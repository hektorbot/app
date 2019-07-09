require "fileutils"

task :update_cron do
  sh "whenever --update-crontab"
end

task :create_image do
  File.open("log/tmp.txt", "a") {|f| f.write Time.now.to_s + "\n"}
end
