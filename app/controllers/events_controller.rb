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

    @today_events = @request_events.where(event_date: from..to)
    # binding.pry
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      flash[:notice] = "イベントを作成しました！"
      redirect_to event_path(@event.id)
    else
      render :new
    end
  end
  
  def show
    @event_comment = EventComment.new
    @event_comments = @event.event_comments
  end
  
  def update
    if @event.update(event_params)
      flash[:notice] = "イベントを内容を更新しました！"
      redirect_to event_path(@event)
    else
      render :edit
    end
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
    params[:event].permit(:event_image,:event_name,:event_date,:starting_time,:ending_time,:game_location,:price,:is_request,:is_online)
  end
end
