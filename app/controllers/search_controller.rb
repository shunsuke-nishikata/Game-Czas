class SearchController < ApplicationController
  
  def search_events
    @search_word = params[:search_word]
    
    @search_events = Event.search_for(@search_word)
    
  end
  
  def search_users
    @search_word  = params[:search_word ]
    @search_users = User.search_for(@search_word)
  end
end
