require 'sinatra'
require 'curb'
require 'json'

class App < Sinatra::Base
  get '/' do
      @image = get_last_img
    erb :index
  end

  get '/info' do
    erb :info
  end

  get '/bio' do
    erb :bio
  end

  get '/oeuvres' do
    @oeuvres = get_all_img.to_json
    erb :oeuvres
  end

  def get_last_img
    JSON.parse(Curl.get('https://api.hektor.ca/rest/artworks/?format=json&limit=1').body)["results"].first["full"]
  end

  def get_all_img
    JSON.parse(Curl.get('https://api.hektor.ca/rest/artworks/?format=json&limit=10000').body)["results"].map {|i| i["thumbnail"]}
  end

  run! if __FILE__ == $0
end