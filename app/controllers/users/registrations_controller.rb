# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController

  def create
    resource = User.new(sign_up_params)
    resource.save
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: resource
      }
    else
      render json: {
        status: { 
          code: 422, 
          message: "User couldn't be created. #{resource.errors.full_messages.to_sentence}" 
        }
      }, status: :unprocessable_entity
    end
  rescue error => e
    Rails.logger.error "Error during user registration: #{e.message}"
    render json: { error: 'An error occurred during registration' }, status: :unauthorized
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password)
  end
end
