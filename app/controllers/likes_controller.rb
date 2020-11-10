class LikesController < ApplicationController
  
  def create
    event = Event.find(params[:event_id])
    like = Like.new(event_id: event.id)
    like.user_id = current_user.id
    like.save
    redirect_to event_path(event.id)
  end
  
  def destroy
    # like = Like.find_by(id: params[:id], event_id: params[:event_id])
    event = Event.find(params[:event_id])
    like = current_user.likes.find_by(event_id: event.id)
    like.destroy
    redirect_to event_path(params[:event_id])
  end
end
