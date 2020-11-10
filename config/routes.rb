Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  resources :events
  resources :users, only: [:index, :show, :edit, :update]
  resources :notifications, only: [:index]
end
