class Movement < ApplicationRecord
  belongs_to :materiel
  belongs_to :employee

  after_save :update_materiel_assignment

  private

  def update_materiel_assignment
    if action == "Assignation"
      materiel.update(assigne_a: "#{employee.first_name} #{employee.last_name}", statut: "En service")
    elsif action == "Retour"
      materiel.update(assigne_a: nil, statut: "En stock")
    elsif action == "Maintenance"
      materiel.update(statut: "En maintenance")
    elsif action == "Transfert"
      materiel.update(assigne_a: "#{employee.first_name} #{employee.last_name}")
    end
  end
end
