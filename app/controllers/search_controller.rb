class SearchController < ApplicationController
  
  # イベントの検索を対象とする処理
  def search_events
    @search_word = params[:search_word]
    @search_events = Event.search_for(@search_word).page(params[:page]).per(8)
    # @search_events = Event.page(params[:page]).per(8)
  end
  
  # ユーザーの検索を対象とする処理
  def search_users
    @search_word  = params[:search_word]
    @search_users = User.search_for(@search_word).page(params[:page]).per(8)
    # @search_users = User.page(params[:page]).per(8)
  end
end
