Rails.application.routes.draw do
  devise_for :users, {
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
    }
  }

  post 'token' => 'user_tokens#auth', as: 'user_token_auth'
  post 'trainings/bulk_create' => 'trainings#bulk_create'
  resources :trainings, only: [:index]
  post 'evolutions/save_or_update' => 'evolutions#save_or_update'
end
