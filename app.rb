require "sinatra"
require "sinatra/activerecord"
require_relative './models/User'
require_relative './models/Post'
require_relative './models/Tag'
require_relative './models/PostTag'


set :database, {adapter: 'postgresql', database: 'rumblr'}

get '/' do 
    @users = User.all
    # @captions = Caption.all
    erb :index
end

get '/homepage' do 
    @users = User.all
    # @captions = Caption.all
    erb :homepage
end

