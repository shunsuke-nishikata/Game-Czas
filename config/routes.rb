Rails.application.routes.draw do
  devise_for :users
  
  root 'homes#top'
  # ゲストログイン用のpath
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  
  resources :users, only: [:edit, :update, :show] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
    get 'favorite_events' => 'users#favorite_events'
    get 'matching' => 'users#matching'
    
  resources :events do
    resources :event_comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :requests, only: [:create, :destroy]
  end
    get 'event/search' => 'search#search_events'
    get 'user/search' => 'search#search_users'
    
  resources :rooms, only: [:index, :show]
  resources :messages, only: [:create]
  resources :notifications, only: [:index]
end
