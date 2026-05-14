class CreateMateriels < ActiveRecord::Migration[7.1]
  def change
    create_table :materiels do |t|
      t.string :nom
      t.string :type_materiel
      t.string :marque
      t.string :modele
      t.string :numero_serie
      t.string :statut
      t.date :date_achat
      t.date :expiration_garantie
      t.string :assigne_a
      t.string :localisation
      t.text :notes

      t.timestamps
    end
  end
end
