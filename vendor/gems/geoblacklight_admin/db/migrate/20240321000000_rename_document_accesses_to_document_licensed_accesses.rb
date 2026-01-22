class RenameDocumentAccessesToDocumentLicensedAccesses < ActiveRecord::Migration[7.0]
  def change
    rename_table :document_accesses, :document_licensed_accesses
  end
end 