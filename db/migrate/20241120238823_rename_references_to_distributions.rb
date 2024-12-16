class RenameReferencesToDistributions < ActiveRecord::Migration[7.0]
  def change
    rename_table :document_references, :document_distributions
  end
end