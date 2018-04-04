class ImageUploadStateMachine
  include Statesman::Machine

  state :initialized, initial: true
  state :queued
  state :processing
  state :succeeded
  state :failed
  state :placeheld

  # Queued => Background Job Init
  # Processing, Succeeded, Failed => ImageService
  transition from: :initialized,  to: :queued
  transition from: :queued,       to: :processing
  transition from: :processing,   to: [:queued, :placeheld, :succeeded, :failed]
  transition from: :placeheld,    to: :queued
  transition from: :failed,       to: :queued
  transition from: :succeeded,    to: :queued

  guard_transition(to: :queued) do |sidecar|
    sidecar.remove_image!
    sidecar.save
  end
end
