class RenameFormElementFeature < ActiveRecord::Migration[7.2]
  def change
    FormElement.where(
      type: "FormFeature",
      label: "Institutional Access Links"
    ).update_all(label: "Licensed Access")
  end
end
