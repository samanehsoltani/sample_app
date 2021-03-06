Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  #HTTP request	URL	Action	Named route
  #GET	/users/1/following	following	following_user_path(1)
  #GET	/users/1/followers	followers	followers_user_path(1)

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end


=begin
sami
e.g.,
  resources :users

  It will automatically add all following routes:

  users GET    /users(.:format)                        users#index
  POST   /users(.:format)                        users#create
  new_user GET    /users/new(.:format)                    users#new
  edit_user GET    /users/:id/edit(.:format)               users#edit
  user GET    /users/:id(.:format)                    users#show
  PATCH  /users/:id(.:format)                    users#update
  PUT    /users/:id(.:format)                    users#update
  DELETE /users/:id(.:format)                    users#destroy
=end
