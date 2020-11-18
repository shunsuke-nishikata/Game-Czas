class EventsController < ApplicationController
  
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  
  def index
    @events = Event.where.not(user_id: current_user.id)
    @new_events  = Event.page(params[:page]).per(8)
    # @new_events  = Event.all.shuffle.take(8)
    
    
    from = Time.current.beginning_of_day
    to = Time.current.end_of_day
    # today_event = Event.find()
    # @today_events = Event.find(requests).where(event_data: from..to)
    
    # 自分がリクエストを出したイベントを取得する
    # requests = Request.where(user_id: current_user.id).pluck(:event_id)
    @request_events = Event.joins(:requests)
                           .where(requests: { user_id: current_user.id })

    @today_events = @request_events.where(event_data: from..to)
    # binding.pry
  end
  
  def news
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
    redirect_to event_path(@event)
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
    params.permit(:event_image,:event_name,:event_data,:starting_time,:ending_time,:game_location,:place,:is_request)
  end
end
