class TicketsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tickets_channel"
  end

  def unsubscribed; end
end
