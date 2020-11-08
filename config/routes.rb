Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  resources :events, only: [:index, :show, :new, :update, :destory]
  resources :users, only: [:index, :show, :edit, :update]
  resources :notifications, only: [:index]
end
