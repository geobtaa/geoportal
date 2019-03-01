# frozen_string_literal: true

class ImageUploadStateMachine
  include Statesman::Machine

  state :initialized, initial: true
  state :queued
  state :processing
  state :succeeded
  state :failed
  state :placeheld

  # Queued => Background Job Init
  # Processing => Failed, Placeheld, Succeeded
  transition from: :initialized,  to: :queued
  transition from: :queued,       to: %i[queued processing]
  transition from: :processing,   to: %i[queued processing placeheld succeeded failed]
  transition from: :placeheld,    to: %i[queued processing]
  transition from: :failed,       to: %i[queued processing]
  transition from: :succeeded,    to: %i[queued processing]

  guard_transition(to: :queued) do |sidecar|
    sidecar.remove_image!
    sidecar.save
  end
end
