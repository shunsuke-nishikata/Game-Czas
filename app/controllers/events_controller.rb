class EventsController < ApplicationController
  
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  
  def index
    @events = Event.where.not(user_id: current_user.id)
    @new_events  = Event.page(params[:page]).per(8)
    # @new_events  = Event.all.shuffle.take(8)
    @today_events = Event.where(is_request: true, user_id: current_user.id)
    # from = Time.current.beginning_of_day
    # to = Time.current.end_of_day
    # @today_events = Event.where.not(is_request: false, user_id: current_user.id).find(date: from..to)
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
    @event_comment = EventComment.new
  end
  
  def update
    @event.update(event_params)
    redirect_back(fallback_location: root_path)
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
    params.require(:event).permit(:event_image,:event_name,:event_data,:starting_time,:ending_time,:game_location,:place,:is_request)
  end
end
