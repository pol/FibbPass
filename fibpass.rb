require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'dm-core'
require 'sha1'
require File.join(File.dirname(__FILE__),'passgen')

configure do
  DataMapper.setup(:default,'sqlite3:memory')

  class User
    include DataMapper::Resource
    
    property  :id,          Serial
    property  :login,       String
    property  :password,    String
    property  :created_at,  DateTime
    
    has n, :passwords
  end

  class Password
    include DataMapper::Resource
    
    property  :id,        Serial
    property  :text,      String
    
    belongs_to :user
  end

  Password.auto_migrate!
  User.auto_migrate!
  
  User.create!(:login => 'user', :password => SHA1.new('password').to_s)
 
end

enable :sessions

get '/' do
  if session[:current_user]
    haml :pass_form
  else
    redirect 'login'
  end
end

get '/login' do
  unless session[:current_user]
    haml :login
  else
    redirect '/'
  end
end

get '/logout' do
  session[:current_user] = nil
  session[:message] = "You have been logged out."
  redirect '/'
end

post '/create_session' do
  login = params[:login]
  password = SHA1.new(params[:password]).to_s
  user = User.first(:login => login, :password => password)
  if user
    session[:current_user] = user
    redirect '/'
  else
    session[:message] = "Login failed! Your user/pass is not correct."
    redirect '/login'
  end
end

get '/clear_passwords' do
  session[:message] = "You have deleted your #{session[:current_user].passwords.length} passwords."
  session[:current_user].passwords.destroy
  redirect '/'
end

# convert the params into a uri
get '/action' do
  redirect "/passgen/#{params[:number]}/#{params[:length]}"
end

get '/passgen/:number/:length' do |num,len|
  Passgen.new.generate_series(num,len).each do |pass|
    session[:current_user].passwords << Password.new(:text => pass)
  end
  session[:current_user].save
  haml :passwords
end

get '/stylesheet.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :stylesheet
end
