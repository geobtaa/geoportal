# frozen_string_literal: true

# ExportChannel
class ExportChannel < ApplicationCable::Channel
  def subscribed
    stream_from "export_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
