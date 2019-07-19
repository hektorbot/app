#https://github.com/waits/dropbox-sdk-ruby
#https://www.rubydoc.info/github/waits/dropbox-sdk-ruby/Dropbox/Client
require 'dropbox'

class ApiDropbox
  attr_accessor :api

  def initialize
    @api = Dropbox::Client.new(ENV['DROPBOX_ACCESS_TOKEN'])
  end

  def get_inputs
    sleep 1
    @api.list_folder("/inputs").map {|f| { path: f.path_lower, created: f.client_modified } }
  end

  def get_styles
    sleep 1
    @api.list_folder("/styles").map {|f| { path: f.path_lower, created: f.client_modified } }
  end

  def renommer (old, new)
    sleep 1
    p "Renommer : ", old, new
    @api.move(old, new)
  end

end
