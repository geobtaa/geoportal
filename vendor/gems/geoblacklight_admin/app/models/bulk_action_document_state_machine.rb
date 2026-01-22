# frozen_string_literal: true

# BulkActionDocument Statesman
class BulkActionDocumentStateMachine
  include Statesman::Machine

  state :created, initial: true
  state :queued
  state :success
  state :failed

  transition from: :created, to: %i[queued success failed]
  transition from: :queued, to: %i[success failed]
end
