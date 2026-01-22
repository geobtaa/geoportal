# frozen_string_literal: true

# BulkAction Statesman
class BulkActionStateMachine
  include Statesman::Machine

  state :created, initial: true
  state :queued
  state :complete
  state :failed
  state :reverted

  transition from: :created, to: %i[queued]
  transition from: :queued, to: %i[created complete failed]
  transition from: :complete, to: %i[reverted]
end
