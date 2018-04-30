require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'rake'
require 'pg'
require 'pry'
require_relative './models/User'
require_relative './models/Post'

enable :sessions
set :database, {adapter: 'postgresql', database: 'rumblr'}

# GET

get '/' do 
    erb :home # where users can create a new account or login
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

# get '/profile' do 
#     @posts = Post.all
#     erb :homepage
# end

get '/profile' do
    @user = User.find(session[:id])
    erb :profile # login page for current users
end

# get '/profile' do
#     @user = User.find(params[:id])
#     erb :allposts
# end

get '/' do
    flash[:alert] = "Hooray, Flash is working!"
    # binding.pry 
    erb :home
end
 
get '/newpost' do
    @user = User.find(session[:id])
    erb :profile
  end
  
post '/newpost' do
    @user = User.find(session[:id])
    @newpost = Post.create(post_title: params[:post_title], city: params[:city], country: param[:country], post_caption: params[:post_caption], user_id: @user.id)
    redirect '/profile'
end

get '/:user' do
    if session[:id] != nil
      @user = User.find_by(id: session[:id])
    end
    @current_user = User.find_by(username: params[:user])
    @posts = Post.where(user_id: @current_user.id).order.limit(20)
    erb :profile
  end

post '/' do
    if session[:id] != nil
      @user = User.find_by(id: session[:id])
    end
    @posts = Post.all().order.limit(20).offset(20)
    erb :profile
end

# POST

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

post '/profile' do # a user that just created an account via form on home will be sent to a welcome page
    @userpost = User.find(session[:id])
    @newpost = Post.create(post_title: params[:post_title], city: params[:city], country: params[:country], post_caption: params[:post_caption], user_id: @userpost.id )
  #  session[:user_id] = @userpost # they have now created a unique id 
    redirect '/profile' # user is set into the welcome page where they can link into their profile
end

# PUT 

put '/profile/:id' do
    @user_avail = User.find(params[:id])
    @user_avail.update(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], birthday: params[:birthday], password: params[:password])
    redirect '/profile'
end

# DELETE

delete '/home/:id' do
    User.destroy(session[:id])
    redirect '/'
end