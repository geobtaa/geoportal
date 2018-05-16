class UriStateMachine
  include Statesman::Machine

  state :initialized, initial: true
  state :queued
  state :processing
  state :succeeded
  state :failed

  # Queued => Background Job Init
  # Processing => Failed, Succeeded
  transition from: :initialized,  to: [:queued, :processing]
  transition from: :queued,       to: [:queued, :processing]
  transition from: :processing,   to: [:queued, :processing, :succeeded, :failed]
  transition from: :failed,       to: [:queued, :processing]
  transition from: :succeeded,    to: [:queued, :processing]
end
