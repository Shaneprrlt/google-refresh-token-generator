require 'sinatra'
require 'json'
require 'googleauth'
require 'securerandom'

# Add your own scope here
SCOPE = 'https://www.googleapis.com/auth/adwords'
SERVER = "localhost"
PORT = "4567"

def get_authorizer
  json = JSON.load_file('google_secrets.json')
  creds, callback_uri, _port =
      if !json["installed"].nil?
        [json["installed"], "http://#{SERVER}:#{PORT}", PORT]
      elsif !json["web"].nil?
        web_creds = json["web"]
        # If you have more than one redirect URI, you may need to add some
        # code here to ensure that you choose the correct one.
        uri = json["web"]["redirect_uris"].first
        port = uri.split(":").last
        [web_creds, uri, port]
      else
        raise "No installed or web credentials found."
      end
  client_id = Google::Auth::ClientId.new(
    creds["client_id"],
    creds["client_secret"],
  )
  Google::Auth::UserAuthorizer.new(client_id, SCOPE, nil, callback_uri)
end

def get_authorization_url
  # Create an anti-forgery state token as described here:
  # https://developers.google.com/identity/protocols/OpenIDConnect#createxsrftoken
  state = SecureRandom.hex(16)
  user_authorizer = get_authorizer
  user_authorizer.get_authorization_url(state: state)
end

def get_refresh_token(code)
  user_authorizer = get_authorizer
  user_credentials = user_authorizer.get_credentials_from_code(code: code)
  user_credentials.refresh_token
end

get '/' do
  authorization_url = get_authorization_url
  redirect authorization_url
end

get '/oauth2callback' do
  code = params[:code]
  refresh_token = get_refresh_token(code)
  "Refresh token: #{refresh_token}"
end
