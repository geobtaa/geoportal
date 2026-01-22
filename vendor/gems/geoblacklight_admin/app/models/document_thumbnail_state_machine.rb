# frozen_string_literal: true

# Document Thumbnail State Machine
class DocumentThumbnailStateMachine
  include Statesman::Machine

  state :initialized, initial: true
  state :queued
  state :processing
  state :succeeded
  state :failed
  state :placeheld

  # Queued => Background Job Init
  # Processing => Failed, Placeheld, Succeeded
  transition from: :initialized, to: %i[queued processing]
  transition from: :queued, to: %i[queued processing]
  transition from: :processing, to: %i[queued processing placeheld succeeded failed]
  transition from: :placeheld, to: %i[queued processing failed]
  transition from: :failed, to: %i[queued processing]
  transition from: :succeeded, to: %i[queued processing]
end
