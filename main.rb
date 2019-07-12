require 'sinatra'
require 'curb'
require 'json'
  
LOGO = "/images/logo_hektor.png"
LOGO_VERT = "/images/logo_vert_hektor.png"

class App < Sinatra::Base

  def initialize
    super()
    @logo = LOGO_VERT
  end

  get '/' do
    @image = get_last_img
    erb :index
  end

  get '/info' do
    @logo = LOGO
    erb :info
  end

  get '/bio' do
    erb :bio
  end

  get '/oeuvres' do
    @oeuvres = get_all_img.to_json
    erb :oeuvres
  end

  get '/paysages/:image' do
    @image = get_image(params['image'])['full']
    erb :images
  end

  def get_last_img
    JSON.parse(Curl.get('https://api.hektor.ca/rest/artworks/?format=json&limit=1').body)["results"].first["full"]
  end

  def get_all_img
    JSON.parse(Curl.get('https://api.hektor.ca/rest/artworks/?format=json&limit=10000').body)["results"]
  end

  def get_image (image)
    JSON.parse(Curl.get('https://api.hektor.ca/rest/artworks/' + image + '/').body)
  end

  run! if __FILE__ == $0
end
