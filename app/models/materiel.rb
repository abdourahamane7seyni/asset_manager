class Materiel < ApplicationRecord
  has_many :movements, dependent: :destroy

  def current_employee
    movements.where(action: "Assignation").order(date: :desc).first&.employee
  end
end
