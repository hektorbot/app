require 'sinatra'

get '/' do
    @image = "https://wallpapertag.com/wallpaper/full/d/7/f/966832-full-size-hd-wallpaper-widescreen-1920x1080-1920x1080-tablet.jpg"
	erb :index
end

get '/bio' do
  erb :bio
end

get '/oeuvres' do
  erb :oeuvres
end
