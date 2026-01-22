class RenameReferencesToDistributions < ActiveRecord::Migration[7.2]
  def change
    rename_table :document_references, :document_distributions
  end
end