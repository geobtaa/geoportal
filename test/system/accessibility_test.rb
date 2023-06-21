require "application_system_test_case"
require 'axe/matchers/be_axe_clean'

class AccessibilityTest < ApplicationSystemTestCase
  def setup
    Capybara.server = :puma
    visit "/"
  end

  def test_accessibility
    matcher = Axe::Matchers::BeAxeClean.new.according_to(:wcag21aa)
    assert_accessible(page, matcher)
  end
  
  # Move this to for example your test_helper 
  def assert_accessible(page, matcher = Axe::Matchers::BeAxeClean.new.according_to(:critical))
    audit_result = matcher.audit(page)
    assert(audit_result.passed?, audit_result.failure_message)
  end
end