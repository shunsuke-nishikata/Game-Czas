class EventsController < ApplicationController
  
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  def index
    @events = Event.all
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    @event.save
    # イベント詳細ページへ
    redirect_to event_path(@event.id)
  end
  
  def show
  end
  
  def update
    @event.update(event_params)
    redirect_to event_path(@event.id)
  end
  
  def destroy
    @event.destroy
    # イベントindexページへ
    redirect_to events_path
  end
  
  private
  
  def set_event
    @event = Event.find(params[:id])
  end
  
  def event_params
    params.require(:event).permit(:event_image,:event_name,:event_data,:starting_time,:ending_time,:game_location,:place)
  end
end
