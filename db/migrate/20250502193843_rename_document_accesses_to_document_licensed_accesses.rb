class RenameDocumentAccessesToDocumentLicensedAccesses < ActiveRecord::Migration[7.0]
  def change
    if table_exists?(:document_accesses)
      rename_table :document_accesses, :document_licensed_accesses
    end
  end
end