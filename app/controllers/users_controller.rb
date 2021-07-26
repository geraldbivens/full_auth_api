class UsersController < ApplicationController
    def index
        @users = User.all

        render json: @users
    end

    def create
        @user = User.create(
            username: params[:username],
            password: params[:password]
        )

        render json: @user, status: :created
    end

    def signin
        # Find the user by their username
        @user = User.find_by(username: params[:username])

        # If the username is found, then authenticate the user by hashing their password and comparing this to the saved hashed password 
        if @user && @user.authenticate(params[:password])
            # If the passwords match, then create a payload for a jwt token
            payload = { user_id: @user.id }

            # Create the jwt token
            # @token = JWT.encode( payload, Rails.application.secret_key_base[0] )
            @token = JWT.encode( payload, 'secret' )

            # Render json back to the frontend of the user's object and token
            render json: { user: @user, token: @token }
        else
            # If the username is not found or the passwords do not match, then send an error
            render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
    end
end
