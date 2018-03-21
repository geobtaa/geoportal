class ImageUploadStateMachine
  include Statesman::Machine

  state :initialized, initial: true
  state :queued
  state :processing
  state :succeeded
  state :failed

  # Queued => Background Job
  # Processing, Succeeded, Failed => ImageService
  transition from: :initialized,  to: [:queued, :processing]
  transition from: :queued,       to: [:processing]
  transition from: :processing,   to: [:succeeded, :failed]
  transition from: :failed,       to: [:queued, :processing]
  transition from: :succeeded,    to: [:queued, :processing]
end
