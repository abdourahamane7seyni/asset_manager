class CreateMovements < ActiveRecord::Migration[7.1]
  def change
    create_table :movements do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.string :action
      t.date :date
      t.text :notes

      t.timestamps
    end
  end
end
