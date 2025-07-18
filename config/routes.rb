Rails.application.routes.draw do
  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
  get :home, to: "homes#index"
  scope :api do
    resources :message_histories do
      collection do
        post :status_update
      end
    end
    devise_for :users, defaults: { format: :json }, 
      controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
      }
  end
end
