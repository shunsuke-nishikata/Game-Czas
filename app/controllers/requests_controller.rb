class RequestsController < ApplicationController
  
  def create
    event = Event.find(params[:event_id])
    requests = current_user.requests.new(event_id: event.id)
    requests.save
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    event = Event.find(params[:event_id])
    requests = current_user.requests.find_by(event_id: event.id)
    requests.destroy
    redirect_back(fallback_location: root_path)
  end
end
