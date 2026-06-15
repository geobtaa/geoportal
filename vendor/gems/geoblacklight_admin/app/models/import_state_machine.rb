# frozen_string_literal: true

# Import Statesman
class ImportStateMachine
  include Statesman::Machine

  state :created, initial: true
  state :mapped
  state :imported
  state :success
  state :failed

  transition from: :created, to: [:mapped]
  transition from: :mapped, to: [:imported]
  transition from: :imported, to: %i[success failed]
end
