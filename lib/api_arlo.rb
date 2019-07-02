#https://github.com/ihassin/arlo
require "arlo"

class ApiArlo
  attr_accessor :api

  def initialize
    @api = Arlo::API.new
    exit "mauvaise config Arlo" if not @api
  end

  def get_videos (debut, fin)
    videos = @api.get_library(debut, fin)["data"]
    cameras = get_cameras

    videos.map do |v|
      {
        id: v["uniqueId"],
        video: v["presignedContentUrl"],
        camera: cameras.select {|c| c["deviceId"] == v["deviceId"] }.first["deviceName"],
        date: v["createdDate"]
      }
    end
  end

  def get_cameras
    @cameras = @api.devices['data'].select {|d| d['deviceType'] == 'camera'} if not @cameras
    @cameras
  end

  #Inutile
  def get_dernieres_images
    get_cameras.each {|c| download_derniere_image(c)}
  end

  def download_derniere_image (camera)
    File.open(DOSSIER_IMAGES_ARLO + "/last_" + camera['deviceName'], 'w') { |f| f.write(Curl.get(camera['presignedLastImageUrl']).body)  }
  end
end
