class Employee < ApplicationRecord
  has_many :movements, dependent: :destroy
  has_many :decharges, dependent: :destroy

  def materiels_assignes
    movements.where(action: "Assignation").map(&:materiel).uniq
  end
end
