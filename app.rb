require "sinatra"
require "sinatra/activerecord"
require 'sinatra/flash'
require 'pry'

require_relative './models/User'
require_relative './models/Post'
# require_relative './models/Tag'
# require_relative './models/PostTag'

enable :sessions

set :database, {adapter: 'postgresql', database: 'rumblr'}

get '/' do 
    erb :home # where users can create a new account or login
end

get '/profile' do
    @user = User.find(session[:id])
    erb :profile # login page for current users
end

get '/welcome' do 
    @user = User.find(session[:id])
    erb :welcome # welcome page for new users
end 

get '/logout' do
    session.clear # clear the session
    redirect '/home' # bring user back home
end

get '/edit' do
    @user_avail = User.find(session[:id])
    erb :edit
end


put '/users/:id' do
    @user_avail = User.find(params[:id])
    @user_avail.update(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], birthday: params[:birthday], password: params[:password])
    redirect '/home'
end


delete '/home/:id' do
    User.destroy(session[:id])
    redirect '/home'
end


# get '/profile' do 
#     @users = User.all
#     erb :homepage
# end

get '/profile/:id' do
    @user = User.find(params[:id])
    erb :homepage
end

get '/' do
    flash[:alert] = "Hooray, Flash is working!"
    # binding.pry 
    erb :home
end
 
post '/user/profile' do 
    @user = User.find_by(email: params[:email], password: params[:password])   
    if @user != nil # if a user exists (is not nil)
        session[:id] = @user.id # then identify their session by id
        erb :profile # bring them into their profile
    else # if the user is not found ...
        redirect '/' # bring them back home to try to sign in again or to create a new account
    end 
    redirect '/profile' # otherwise, be directed to their profile
end

post '/user/welcome' do # a user that just created an account via form on home will be sent to a welcome page
    @newuser = User.create(first_name: params[:firstname], last_name: params[:lastname], birthday: params[:birthday], email: params[:email], password: params[:password]) # their params should link to the input
    session[:id] = @newuser.id # they have now created a unique id 
    redirect '/welcome' # user is set into the welcome page where they can link into their profile
end

