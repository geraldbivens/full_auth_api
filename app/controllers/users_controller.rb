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
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            payload = { user_id: @user.id }

            # @token = JWT.encode( payload, Rails.application.secret_key_base[0] )
            @token = JWT.encode( payload, 'secret' )

            render json: { user: @user, token: @token }
        else
            render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
    end
end
