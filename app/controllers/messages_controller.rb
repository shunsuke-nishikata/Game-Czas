class MessagesController < ApplicationController
  
  def create
    @message = current_user.messages.new(message_params)
    @message.save
    room = @message.room
    # roomが同じでユーザーのidが違うものをエントリーから探す、相手のidを取得するため
    visited_room = Entry.where(room_id: room.id).where.not(user_id: current_user.id)
    # 取得したエントリー情報をvisited_memberへ
    visited_member = visited_room.find_by(room_id: room.id)
    # roomが同じメッセージ相手のid
    # visited_id = visited_member.user_id
    
    notification = current_user.active_notifications.new(
      visitor_id: current_user.id,
      visited_id: visited_member.user_id,
      room_id: room.id,
      message_id: @message.id,
      action: 'message'
    )
    notification.save
    # @message.create_notification_message(current_user, @message.id, room.id, visited_id)
    
    redirect_back(fallback_location: root_path)
    
  end
  
  def index
    # 未確認の通知レコードを8件取得
    # その後「未確認→確認済」になるように更新
    @notifications = current_user.passive_notifications.page(params[:page]).per(8)
    # binding.pry
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end
