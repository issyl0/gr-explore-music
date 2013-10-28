require 'sinatra'
require 'echowrap'
require 'rest_client'
require 'open-uri'

require './secret'

before do
# Analyse the given track through EchoNest and retrieve metadata.

# Clean ID3 tags. 
user_track_filepath = "/Users/issyl0/Music/Anathema - We're Here Because We're Here [320]/04 - Everything.mp3"
# Dirty ID3 tags.
user_track_filepath2 = "/Users/issyl0/Downloads/1304477400_the-prodigy-splitfire.mp3"

# Doing this could cause excessive server load when there are
# multiple users. Files must be stored locally for this to work, but
# they are deletable once we have the correct song data.
echonest_track1 = `echoprint-codegen "#{user_track_filepath}" 10 30`
@echonest_identified1 = Echowrap.song_identify(:query => echonest_track1)
echonest_track2 = `echoprint-codegen "#{user_track_filepath2}" 10 30`
@echonest_identified2 = Echowrap.song_identify(:query => echonest_track2)

# Push the song data to last.fm and retreive cover art.
 lastfm_url = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&track=#{URI::encode(@echonest_identified2.title)}&artist=#{URI::encode(@echonest_identified2.artist_name)}&api_key=#{LASTFM_API_KEY}&format=json"
 @lastfm_image = JSON.parse(RestClient.get(lastfm_url))['track']['album']['image'][2]['#text']
 p "Album art: #{@lastfm_image}"
end

get '/' do
  erb :index
end
