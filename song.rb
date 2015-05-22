require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :fname, String
  property :lname, String
  property :email, String
  property :major, String
  property :gpa, Float
 
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/songs' do
  if session[:admin]
    @songs = Student.all
    slim :songs
  else
    slim :entrance
  end
end

get '/songs/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = Student.new
  slim :new_song
end

get '/songs/:id' do
  @song = Student.get(params[:id])
  slim :show_song
end

get '/songs/:id/edit' do
  @song = Student.get(params[:id])
  slim :edit_song
end

post '/songs' do  
  song = Student.create(params[:song])
  redirect to("/songs/#{song.id}")
end

put '/songs/:id' do
  song = Student.get(params[:id])
  song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  Student.get(params[:id]).destroy
  redirect to('/songs')
end