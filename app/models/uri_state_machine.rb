# frozen_string_literal: true

class UriStateMachine
  include Statesman::Machine

  state :initialized, initial: true
  state :queued
  state :processing
  state :succeeded
  state :failed

  # Queued => Background Job Init
  # Processing => Failed, Succeeded
  transition from: :initialized,  to: %i[queued processing]
  transition from: :queued,       to: %i[queued processing]
  transition from: :processing,   to: %i[queued processing succeeded failed]
  transition from: :failed,       to: %i[queued processing]
  transition from: :succeeded,    to: %i[queued processing]
end
