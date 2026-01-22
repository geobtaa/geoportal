# frozen_string_literal: true

# ImportDocument Statesman
class ImportDocumentStateMachine
  include Statesman::Machine

  state :queued, initial: true
  state :success
  state :failed

  transition from: :queued, to: %i[success failed]
  transition from: :failed, to: :success
end
