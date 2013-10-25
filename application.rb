require 'sinatra'
require 'echowrap'
require 'rest_client'

require './secret'

before do
  # Analyse the given track through EchoNest and retrieve metadata.
  user_track_filepath = "/Users/issyl0/Music/Anathema - We're Here Because We're Here [320]/04 - Everything.mp3"
  @echonest_track = Echowrap.track_upload(:track => File.open(user_track_filepath), :filetype => "mp3")
  p @echonest_track
  
  # Push the song data to last.fm and retreive cover art.
  lastfm_url = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&track=#{@echonest_track.title}&artist=#{@echonest_track.artist}&api_key=#{LASTFM_API_KEY}&format=json"
  p lastfm_url
  @lastfm_image = JSON.parse(RestClient.get(lastfm_url))['track']['album']['image'][2]['#text']
  p "Album art: #{@lastfm_image}"
end

get '/' do
  erb :index
end
