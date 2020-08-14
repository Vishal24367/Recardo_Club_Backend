  ##
  # = Get the authenticated connection with websocket
  #
  # GET ws://localhost:3000/cable
  #     
  #
  # params:
  #   id #desired user's id
  #
  # = Examples
  #
  #   App.cable = new Websocket("ws://localhost:3000/cable")
  #
  #   resp.status
  #   => 101
  #
  #   resp.headers
  #   => {
  #       "connection" => "upgrade",
  #       "Upgrade" => "websocket"
  #     }
  #   resp.body
  #   => {
  #       "Registered connection" => "Z2lkOi8vYmFja2VuZC9Vc2VyLzE"
  #   }
  #   
  #   identifier
  #   => {
  #        "command" => "subscribe",
  #         "identifier" { 
  #                   "channel" => "NotificationChannel"
  #          }
  #      }
  #
  #   resp.status
  #   => 101
  #
  #   resp.body
  #   => {:message => "An unauthorized connection attempt was rejected"}  

class NotificationChannel < ApplicationCable::Channel

  # identifier
  # => {
  #      "command" => "subscribe",
  #       "identifier" { 
  #                 "channel" => "NotificationChannel",
  #                 "type" => "confirm_subscription"
  #        }
  #    }
  #
  # Console message: 
  # NotificationChannel is transmitting the subscription confirmation
  # NotificationChannel is streaming from notifications:1
  #

  def subscribed
    stream_from "notifications:#{current_user.id}"
  end

  ## Unsubcription is also done automatically whenever user logged out and unsubscribe channel.
  ##
  ## Console message :-
  ## NotificationChannel stopped streaming from notifications:1
  ## NotificationChannel transmitting {"counter"=>1} (via streamed from notifications:1)

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # This notification stream is hard coded because it broadcast no of connected user. When user unsubsribe the it broadcast
    # on the same stream but user can't see as he get unsubcribed.

    ActionCable.server.broadcast "notifications:1", counter: count_unique_connections
  end

  ## This is use to broadcast message.
  ##
  ## This broadcast the message recieve.
  ## Response :-
  ## NotificationChannel transmitting {"data"=>"sadasd"} (via streamed from notifications:1)
  ##

  def receive(data)
    ActionCable.server.broadcast "notifications:#{current_user.id}", data
  end

  ## This funtion is used to broadcast message to the stream and called from user model broadcast method.
  ##
  ## 2.3.1 > User.first.broadcast("message")
  ##
  ## Response :-
  ## [ActionCable] Broadcasting to notifications:1: {:data=>"asdsa"}
  ## NotificationChannel transmitting {"data"=>"asdsa"} (via streamed from notifications:1)


  def self.broadcast_msg(broadcast_id, data)
    ActionCable.server.broadcast "notifications:#{broadcast_id}", data: data
  end

  private
  ## Counts all users connected to the ActionCable server
  ## If we have one channel then it provide use all the user connected there.
  def count_unique_connections
    ActionCable.server.connections.map {|c| c.current_user}.pluck(:id).uniq.length
  end
end

## This is use to find out all the stream present in a channel.
## we can run it via Rails console
# 2.3.1 > Redis.new.pubsub("channels", "action_cable/*")
#https://stackoverflow.com/questions/36106542/how-do-i-find-out-who-is-connected-to-actioncable/36230416