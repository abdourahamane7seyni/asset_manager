class ChangeAssetToMaterielInMovements < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :movements, :assets
    remove_column :movements, :asset_id
    add_reference :movements, :materiel, null: false, foreign_key: true, default: 0
  end
end
