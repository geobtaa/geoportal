# frozen_string_literal: true

# ImportDocumentDistribution Statesman
class ImportDocumentDistributionStateMachine
  include Statesman::Machine

  state :queued, initial: true
  state :success
  state :failed

  transition from: :queued, to: %i[success failed]
  transition from: :failed, to: :success
end
