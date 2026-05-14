class Decharge < ApplicationRecord
  belongs_to :employee

  STATUTS = ["En attente de signature", "Signé", "Refusé"].freeze

  validates :statut, inclusion: { in: STATUTS }
  validates :date_emission, presence: true

  scope :signees, -> { where(statut: "Signé") }
  scope :en_attente, -> { where(statut: "En attente de signature") }
end
