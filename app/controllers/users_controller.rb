require 'bcrypt'
require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    erb :'users/create_user'
  end

  post '/signup' do
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      session[:user_id] = @user.id
      redirect '/tweets'
    else
      flash[:message] = "Signup unsuccessful. Please try again."
      redirect '/signup'
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/tweets'
    else
      flash[:message] = "Login unsuccessful. Please try again."
      redirect '/login'
    end
  end

  get '/users/:slug' do
    binding.pry
    # if Helpers.is_logged_in?(session)
      @user = User.find_by_slug(params[:slug])
      @tweets = @user.tweets
      erb :'users/show'
    # else
    #   redirect '/login'
    # end
  end

  get '/logout' do
    if Helpers.is_logged_in?(session)
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

end
