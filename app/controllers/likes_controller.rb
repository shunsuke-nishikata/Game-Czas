class LikesController < ApplicationController
  
  def create
    @event = Event.find(params[:event_id])
    like = Like.new(event_id: @event.id)
    like.user_id = current_user.id
    like.save
    # 通知作成
    @event.create_notification_like(current_user)
    # redirect_back(fallback_location: root_path)
  end
  
  def destroy
    # like = Like.find_by(id: params[:id], event_id: params[:event_id])
    @event = Event.find(params[:event_id])
    like = current_user.likes.find_by(event_id: @event.id)
    like.destroy
    # redirect_back(fallback_location: root_path)
  end
end
