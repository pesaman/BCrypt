get '/' do
  erb :index
end

get '/registrar' do
 erb :registrar
end

get '/loogin_user' do
 erb :login
end

get '/secret' do
  p current_user
  erb :secret
end

before '/secret' do
  unless session[:email]
    session[:error] = "No has iniciado sesión"
    #i need to redirect to index to avoid go to /secret again
    redirect to '/'
  end
end

get '/logout' do
  session.clear
  session[:logout] = "Has cerrado sesión correctamente"
  redirect to '/'
end

post '/profile' do
  email = params[:email]
  password_digest = params[:password]
  user_validate = User.authenticate(email,password_digest)
    if user_validate 
       session[:email] = email
       session[:user_id] = user_validate.id
       redirect to '/secret'
    else 
       session[:incorrect_login] = "Email y/o password incorrectos"
       redirect to '/loogin_user'
    end
end


post '/create_user' do
  username = params[:username]
  name = params[:name]
  email = params[:email]
  password_digest = params[:password]
  existe = User.find_by(email: email)
  user  = User.new(username: username, name: name, email: email, password: password_digest)
  user.save
  if user.valid?
      session[:user_id] = user.id
      session[:correct_user] = "Usuario Creado con Exito"
      redirect to '/loogin_user'
  else 
    if existe
      session[:incorrect_user] = "Usuario ya Existe Intenta de Nuevo"
      redirect to '/registrar'
      else
    
      session[:incorrect_user] = "No puedes dejar campos vacios"
      redirect to '/registrar'
    end
  end
end