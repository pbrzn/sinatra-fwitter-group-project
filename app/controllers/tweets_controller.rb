require 'rack-flash'

class TweetsController < ApplicationController
  use Rack::Flash

  get '/tweets' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if Helpers.is_logged_in?(session)
      erb :'tweets/new'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    current_user = Helpers.current_user(session)
    if !params[:content].empty?
      @tweet = current_user.tweets.build(content: params[:content])
      if @tweet.save
        redirect "/tweets/#{@tweet.id}"
      else
        flash[:message] = "Empty text field, please try again."
        redirect '/tweets/new'
      end
    else
      redirect to '/tweets/new'
    end
  end

  get '/tweets/:id/edit' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find(params[:id])
      erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if !params[:content].empty?
      @tweet.update(:content => params[:content])
      redirect "/tweets/#{@tweet.id}"
    else
      flash[:message] = "Empty text field, please try again."
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if Helpers.is_logged_in?(session) && @tweet.user == Helpers.current_user(session)
      @tweet.delete
      redirect '/tweets'
    elsif Helpers.is_logged_in?(session) && @tweet.user != Helpers.current_user(session)
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

end
