Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  namespace :api do
    namespace :v1 do
      resources :events do
        collection do
          post 'add_user_to_events', to: 'events#add_user_to_events' 
          get 'get_events', to: 'events#get_events'
          get 'joined_events', to: 'events#joined_events'
        end 
      end
    end
  end
end
