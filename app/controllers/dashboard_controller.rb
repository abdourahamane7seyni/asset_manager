class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_materiels = Materiel.count
    @materiels_par_type = Materiel.group(:type_materiel).count
    @materiels_par_statut = Materiel.group(:statut).count
    @total_employes = Employee.count
    @mouvements_recents = Movement.order(created_at: :desc).limit(5)
    @expirant_bientot = Materiel.where(expiration_garantie: Date.today..30.days.from_now)
    @expires = Materiel.where("expiration_garantie < ?", Date.today)
  end
end
