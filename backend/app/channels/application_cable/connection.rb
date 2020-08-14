  ##
  # = Get the authenticated connection with websocket
  #
  # GET ws://localhost:3000/cable
  #
  # params:
  #   id #desired user's id
  #
  # = Examples
  #
  #   resp = new Websocket("ws://localhost:3000/cable")
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
  #   resp.status
  #   => 101
  #
  #   resp.body
  #   => {:message => "An unauthorized connection attempt was rejected"}  
 

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = is_logged_in_user
    end

    protected

    def is_logged_in_user
      if current_user = env['warden'].user   # Devise is build on warden so we can use this, but it is not tested yet that it is good way or not.
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
