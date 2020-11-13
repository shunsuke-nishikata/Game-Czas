Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  resources :users, only: [:index, :show, :edit, :update]
  resources :events do
    resources :event_comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
  get 'events#favorite_events'
  resources :notifications, only: [:index]
end
