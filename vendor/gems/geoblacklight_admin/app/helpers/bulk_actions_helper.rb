# frozen_string_literal: true

# BulkActionsHelper
#
# This module provides helper methods for handling bulk actions
# within the GeoblacklightAdmin application.
module BulkActionsHelper
  # Returns a collection of attributes that can be used for bulk actions.
  #
  # The collection includes all importable fields from the GeoblacklightAdmin
  # schema, with "Publication State" prepended to the list.
  #
  # @return [Array<String>] an array of attribute names
  def bulk_actions_collection
    attrs = GeoblacklightAdmin::Schema.instance.importable_fields.collect { |key, _value| key }
    attrs.prepend("Publication State")
  end
end
