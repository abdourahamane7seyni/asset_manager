class CreateDecharges < ActiveRecord::Migration[7.1]
  def change
    create_table :decharges do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :statut
      t.date :date_emission
      t.date :date_signature
      t.text :notes
      t.string :fichier

      t.timestamps
    end
  end
end
