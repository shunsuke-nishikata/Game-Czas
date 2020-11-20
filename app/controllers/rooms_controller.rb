class RoomsController < ApplicationController
  
  
  def index
  end
  
  def show
    # メッセージする相手のIDを取得
    @user = User.find(params[:id])
    # 自分がentryしているentryのidを取得しその中のroom_idをpluckを使い配列で取り出す
    # メッセージをする相手とのroomがすでにあるか確認するため
    rooms = current_user.entries.pluck(:room_id)
    
    # メッセージする相手のユーザーのIDとroom_id上記roomsに一致しているレコードを取り出す
    # すでにメッセージをしたことがあるかの確認のため
    entry = Entry.find_by(user_id: @user.id, room_id: rooms )
    # 自分とメッセージをする相手のentry情報がない場合のif文
   
    if entry.nil?
      @room = Room.create
      # 自分のentryテーブル作成
      Entry.create(user_id: current_user.id, room_id: @room.id)
      # メッセージを送る相手のentroyテーブルを作成
      Entry.create(user_id: @user.id, room_id: @room.id)
      
    else
      # すでにメッセージをしたことがありroomが存在しているときは、
      # 取得したroomを代入する
      @room = entry.room
    end
    
    @message = Message.new(room_id: @room.id)
    # 自分と相手の部屋のメッセージ全て
    @messages = @room.messages
    # session[:user_id] = @user.id
    
  end
  
end
