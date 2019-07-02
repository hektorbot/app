require 'dotenv/load'
require "curb"
require 'fileutils'

#https://github.com/streamio/streamio-ffmpeg
require "streamio-ffmpeg"

require_relative 'api_arlo.rb'
require_relative 'api_dropbox.rb'

DOSSIER_IMAGES_ARLO = Dir.pwd + "/data/" + "arlo_images"
DOSSIER_VIDEOS_ARLO = Dir.pwd + "/data/" + "arlo_videos"

ARLO_JPG_QUALITY = 1 #1-31, 1 : meilleur

class ApiHektor
  attr_accessor :arlo, :dropbox

  def initialize
    Dotenv.load "../.env"
    @arlo = ApiArlo.new
    @dropbox = ApiDropbox.new
    
    # Creer le dossier images s'il n'existe pas
    unless File.directory?(DOSSIER_IMAGES_ARLO)
      FileUtils.mkdir_p(DOSSIER_IMAGES_ARLO)
    end

    # Creer le dossier images s'il n'existe pas
    unless File.directory?(DOSSIER_VIDEOS_ARLO)
      FileUtils.mkdir_p(DOSSIER_VIDEOS_ARLO)
    end
  end

  def get_new_images (debut = nil, fin = nil)

    #init
    time = (Time.now).strftime("%Y%m%d")
    debut ||= time
    fin ||= time

    # Videos de la journee
    videos = @arlo.get_videos(debut, fin)
    videos.each do |v|
      nom_video = DOSSIER_VIDEOS_ARLO + "/" + v[:id] + "-" + v[:camera] + "-" + v[:date] + ".mp4"
      nom_image = DOSSIER_IMAGES_ARLO + "/" + v[:id] + "-" + v[:camera] + "-" + v[:date] + ".jpg"
      begin

        # Telecharger videos
        save(nom_video, Curl.get(v[:video]).body)

        # Creation de l'image
        movie = FFMPEG::Movie.new(nom_video)
        movie.screenshot(nom_image, seek_time: (v[:secondes] / 2), quality: ARLO_JPG_QUALITY)

        # Suppression du video
        File.delete(nom_video)

      rescue StandardError => e
        p e.message
      end
    end
  end

  def save (nom, contenu)
    File.open(nom, 'w') { |f| f.write contenu }
  end

end

hektor = ApiHektor.new
hektor.get_new_images '20190626', '20190626'
