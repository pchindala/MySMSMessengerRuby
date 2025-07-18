class HomesController < ApplicationController
    before_action :authenticate!
    def index
       render json: User.first.as_json(only: [:id, :email, :created_at]), status: :ok
    end
end
