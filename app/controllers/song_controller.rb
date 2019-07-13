require 'sinatra/base'
require 'rack-flash'

class SongsController < Sinatra::Base
  enable :sessions
  use Rack::Flash
  register Sinatra::ActiveRecordExtension
  set :session_secret, "my_application_secret"
  set :views, Proc.new {File.join(root,"../views/")}

  get '/songs' do
    @songs = Song.all
    erb :"songs/index"
  end

  get '/songs/new' do
    @genres = Genre.all
    erb :"songs/new"
  end

  post '/songs' do
    @song = Song.create(:name => params[:song][:name])
    artist_entry = params[:song][:artist]
    if Artist.find_by(:name => artist_entry)
      artist = Artist.find_by(:name => artist_entry)
    else
      artist = Artist.create(:name => artist_entry)
    end
    @song.artist = artist
    genre_selections = params[:song][:genres]
    genre_selections.each do |genre|
      @song.genres << Genre.find(genre)
  end
  @song.save
end

end
