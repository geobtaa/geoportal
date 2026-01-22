# frozen_string_literal: true

# Document Statesman
class DocumentStateMachine
  include Statesman::Machine

  state :draft, initial: true
  state :published
  state :unpublished

  transition from: :draft, to: %i[draft published unpublished]
  transition from: :published, to: %i[draft published unpublished]
  transition from: :unpublished, to: %i[draft published unpublished]
end
