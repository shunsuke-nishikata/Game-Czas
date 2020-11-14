Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
    get 'favorite_events' => 'users#favorite_events'
    get 'matching' => 'users#matching'
    
  resources :events do
    resources :event_comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
  
  resources :notifications, only: [:index]
end
