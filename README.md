# Google Refresh Token Generator

A basic web server for generating refresh tokens to use with Google APIs for internal API usage.

## Requirements

* Docker
* Make
* Google Cloud Account
* Google OAuth Client ID and Secret JSON File

## Google OAuth Setup

1. Open the Client ID you want to authenticate with in Google Cloud
2. Edit the ID
3. Add `http://localhost:4567/oauth2callback` as a Authorized Redirect URI
4. Save changes
5. Download the JSON credentials and add the file to the project directory root as a file called `google_secrets.json` (this file is gitignored by default)

## Setup

1. Launch Docker
2. CD into the project directory
3. Update the `docker-compose.yml` file with your environment variable values
4. Run `make build` to build the project
5. Run `make start` to start the server
6. Open `http://localhost:4567` to initiate authentication
7. Authenticate with Google
8. Be redirect back and obtain your Refresh Token
