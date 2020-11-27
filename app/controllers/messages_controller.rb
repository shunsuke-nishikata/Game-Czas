class MessagesController < ApplicationController
  def create
    @message = current_user.messages.new(message_params)
    if @message.save

      room = @message.room
      # roomが同じでユーザーのidが違うものをエントリーから探す、相手のidを取得するため
      visited_room = Entry.where(room_id: room.id).where.not(user_id: current_user.id)
      # 取得したエントリー情報をvisited_memberへ
      visited_member = visited_room.find_by(room_id: room.id)
      # roomが同じメッセージ相手のid
      # visited_id = visited_member.user_id
      @messages = room.messages
      notification = current_user.active_notifications.new(
        visitor_id: current_user.id,
        visited_id: visited_member.user_id,
        room_id: room.id,
        message_id: @message.id,
        action: 'message'
      )
      
       notification.save
       
      # if notification
      #   notification_old = Notification.where(
      #     visitor_id: current_user.id,
      #     visited_id: visited_member.user_id,
      #     room_id: room.id,
      #     action: 'message'
      #     )
      #   # notification.created_at != notification_old.created_at
      #   notification_old.each do |old|
      #     if notification.created_at != old.created_at
      #       old.destroy
      #     end
      #   end
      #   binding.pry
      # end
      
    else
      flash[:notice] = "メッセージを入力してください"
      redirect_back(fallback_location: root_path)
    end
    # @message.create_notification_message(current_user, @message.id, room.id, visited_id)

    # redirect_back(fallback_location: root_path)
  end

  def index
    # 未確認の通知レコードを8件取得
    # その後「未確認→確認済」になるように更新
    @notifications = current_user.passive_notifications.page(params[:page]).per(8)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
    
    # 一番最新の通知
    # latest_notification = current_user.passive_notifications.first
    # if latest_notification.action == "message"
    #   @notification = latest_notification
    # end
    
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end
