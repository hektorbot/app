#https://github.com/waits/dropbox-sdk-ruby
#https://www.rubydoc.info/github/waits/dropbox-sdk-ruby/Dropbox/Client
require 'dropbox'

class ApiDropbox

  def initialize
    @d = Dropbox::Client.new(ENV['DROPBOX_ACCESS_TOKEN'])
  end

  def get_inputs
   p @d.list_folder("/inputs").map {|f| f.path_lower }
  end

  def get_styles
    @d.list_folder("/styles").map {|f| f.path_lower }
  end

  def marquer_utilise (path)
    @d.move(path, path + "-L" + Time.now.to_i)
  end

end
