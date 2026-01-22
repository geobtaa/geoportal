# frozen_string_literal: true

# Import Distribution Statesman
class ImportDistributionStateMachine
  include Statesman::Machine

  state :created, initial: true
  state :imported
  state :success
  state :failed

  transition from: :created, to: [:imported]
  transition from: :imported, to: %i[success failed]
end
