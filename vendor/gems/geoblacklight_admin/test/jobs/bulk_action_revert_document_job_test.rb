require "test_helper"

class BulkActionRevertDocumentJobTest < ActiveJob::TestCase
  fixtures :documents

  def setup
    @job = BulkActionRevertDocumentJob.new
    @document = documents(:ag)
    @document.title = "New Title"
    @document.save
  end

  test "perform revert_publication_status" do
    @job.stub :revert_publication_status, true do
      @job.perform(:revert_publication_status, @document)
    end
  end

  test "perform revert_delete" do
    @job.stub :revert_delete, true do
      @job.perform(:revert_delete, @document)
    end
  end

  test "revert_publication_status success" do
    @document.stub :save, true do
      @job.revert_publication_status(@document)
      assert_equal "published", @document.state_machine.current_state
    end
  end

  test "revert_publication_status failure" do
    @document.stub :save, false do
      @job.revert_publication_status(@document)
      assert_equal "published", @document.state_machine.current_state
    end
  end

  test "revert_delete success" do
    @document.stub :save, true do
      @job.revert_delete(@document)
    end
  end

  test "revert_delete failure" do
    @document.stub :save, false do
      @job.revert_delete(@document)
    end
  end
end

class StateMachine
  attr_accessor :state

  def transition_to!(new_state)
    @state = new_state
  end
end
