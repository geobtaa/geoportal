class RenameDocumentAccesses < ActiveRecord::Migration[7.2]
  def change
    rename_table :document_accesses, :document_licensed_accesses
  end
end
