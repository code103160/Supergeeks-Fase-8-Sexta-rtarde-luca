class Api::V1::UsersController < ApplicationController
    def index
        render json: {}, status: 200
    end

    def show 
        begin
            @user = User.find(params[:id])
            render json: { user: @user.to_json }, status: 200
        rescue
            render json: { user: {} }, status: 404
        end
    end
end
