require 'dotenv/load'
require "curb"
require 'fileutils'

#https://github.com/streamio/streamio-ffmpeg
require "streamio-ffmpeg"

require_relative 'api_arlo.rb'
require_relative 'api_dropbox.rb'

DOSSIER_IMAGES_ARLO = Dir.pwd + "/data/arlo_images/"
DOSSIER_VIDEOS_ARLO = Dir.pwd + "/data/arlo_videos/"
DOSSIER_TMP = Dir.pwd + "/data/tmp/"

DOSSIER_INPUTS_DROPBOX = "/inputs/"
DOSSIER_STYLES_DROPBOX = "/styles/"

ARLO_JPG_QUALITY = 1 #1-31, 1 : meilleur

URL_HEKTOR = "https://api.hektor.ca/rest/artworks/?format=json"

USED_PREFIX = "used_"

REGEXP_NOM_FICHIER = /\/\w+\/(\w+\.\w{3})/

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

    # Creer le dossier images s'il n'existe pas
    unless File.directory?(DOSSIER_TMP)
      FileUtils.mkdir_p(DOSSIER_TMP)
    end
  end

  def run
    #Ajouter les nouvelles images
    import_from_arlo

    # Envoyer a Hektor
    envoyer_hektor selectionner_input, selectionner_style
  end

  def import_from_arlo (debut = nil, fin = nil)

    #init
    time = (Time.now).strftime("%Y%m%d")
    debut ||= time
    fin ||= time

    # Videos de la journee
    videos = @arlo.get_videos(debut, fin)
    videos.each do |v|
      nom_video = v[:id] + "-" + v[:camera] + "-" + v[:date] + ".mp4"
      nom_image = v[:id] + "-" + v[:camera] + "-" + v[:date] + ".jpg"
      begin

        # Telecharger videos
        save(DOSSIER_VIDEOS_ARLO + nom_video, Curl.get(v[:video]).body)

        # Creation de l'image
        movie = FFMPEG::Movie.new(DOSSIER_VIDEOS_ARLO + nom_video)
        movie.screenshot(DOSSIER_IMAGES_ARLO + nom_image, seek_time: (v[:secondes] / 2), quality: ARLO_JPG_QUALITY)

        # Suppression du video
        File.delete(DOSSIER_VIDEOS_ARLO + nom_video)

        # Upload image
        File.open(DOSSIER_IMAGES_ARLO + nom_image, 'r') { |f| @dropbox.api.upload DOSSIER_STYLES_DROPBOX + nom_image, f.read }

      rescue StandardError => e
        p e.message
      end
    end
  end

  def selectionner_input
    inputs = get_liste_inputs
    abort "Aucun input" + Time.now.to_s if inputs.count == 0
    
    unused = inputs.select { |i| not is_used? i[:path] }

    # Si tous les inputs ont ete utilises
    if unused.count == 0 
      inputs.each {|i| set_unused i[:path] }
    end

    #Si un style n'est pas utilise, le selectionner et updater
    unused.count > 0 ? set_used(unused.sample[:path]) : selectionner_input
  end

  def selectionner_style
    styles = get_liste_styles
    abort "Aucun style" + Time.now.to_s if styles.count == 0

    unused = styles.select { |s| not is_used? s[:path] }

    # Si tous les styles ont ete utilises
    if unused.count == 0 
      styles.each {|s| set_unused s[:path]}
    end

    unused.count > 0 ? set_used(unused.sort {|a,b| a[:created] <=> b[:created] }.first[:path]) : selectionner_style
  end

  def save (nom, contenu)
    File.open(nom, 'w') { |f| f.write contenu }
  end

  def create_used_path (path)
    parties = path.match /\/(\w+)\/([\w-]+\.\w{3})/
    "/" + parties[1] + "/" + USED_PREFIX + parties[2]
  end

  def create_unused_path (path)
    parties = path.match /\/(\w+)\/#{USED_PREFIX}([\w-]+\.\w{3})/
    "/" + parties[1] + "/"  + parties[2]
  end

  def is_used? (path)
    path.match /\/\w+\/#{USED_PREFIX}[\w-]+\.\w{3}/
  end

  def set_used (path)
    new = create_used_path path
    @dropbox.renommer path, new
    new
  end

  def set_unused (path)
    @dropbox.renommer path, create_unused_path(path)
  end

  def get_liste_inputs
    @dropbox.get_inputs
  end

  def get_liste_styles
    @dropbox.get_styles
  end

  def envoyer_hektor (fichier_dropbox_input, fichier_dropbox_style)
    fichier_input, body_input = @dropbox.api.download fichier_dropbox_input
    fichier_style, body_style = @dropbox.api.download fichier_dropbox_style
    
    save(DOSSIER_TMP + fichier_input.name, body_input.to_s)
    save(DOSSIER_TMP + fichier_style.name, body_style.to_s)

    p "--------------------------------------------------"
    p Time.now.to_s
    p "Fusion de : " + fichier_input.name + " & " + fichier_style.name
    traiter_images DOSSIER_TMP + fichier_input.name, DOSSIER_TMP + fichier_style.name
  end

  def traiter_images (input, style)
    c = Curl::Easy.new(URL_HEKTOR)
    c.multipart_form_post = true
    c.http_post(Curl::PostField.file('input_image', input), Curl::PostField.file('style_image', style))
    p c.body_str
  end

end
