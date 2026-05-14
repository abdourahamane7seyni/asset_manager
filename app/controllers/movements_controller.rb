class MovementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movement, only: %i[ show edit update destroy ]

  def index
    @movements = Movement.all.order(created_at: :desc)
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="mouvements.xlsx"'
      end
      format.pdf do
        pdf = generate_pdf_movements(@movements)
        send_data pdf.render, filename: "mouvements.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def show; end
  def new; @movement = Movement.new; end
  def edit; end

  def create
    @movement = Movement.new(movement_params)
    if @movement.save
      redirect_to @movement, notice: "Mouvement créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @movement.update(movement_params)
      redirect_to @movement, notice: "Mouvement mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movement.destroy
    redirect_to movements_path, notice: "Mouvement supprimé avec succès."
  end

  private

  def set_movement
    @movement = Movement.find(params[:id])
  end

  def movement_params
    params.require(:movement).permit(:materiel_id, :employee_id, :action, :date, :notes)
  end

  def generate_pdf_movements(movements)
    Prawn::Document.new(page_size: "A4", page_layout: :landscape) do |pdf|
      pdf.fill_color "16a34a"
      pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 60
      pdf.fill_color "000000"
      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: 60) do
        pdf.move_down 15
        pdf.text "HISTORIQUE DES MOUVEMENTS", size: 18, style: :bold, color: "FFFFFF", align: :center
        pdf.text "Généré le #{Date.today.strftime('%d/%m/%Y')}", size: 10, color: "FFFFFF", align: :center
      end
      pdf.move_down 20

      headers = ["Date", "Matériel", "Type", "Employé", "Département", "Action", "Notes"]
      rows = movements.map do |m|
        [
          m.date&.strftime("%d/%m/%Y").to_s,
          m.materiel&.nom.to_s,
          m.materiel&.type_materiel.to_s,
          "#{m.employee&.first_name} #{m.employee&.last_name}",
          m.employee&.department.to_s,
          m.action.to_s,
          m.notes.to_s.truncate(30)
        ]
      end

      pdf.font_size 9
      pdf.table([headers] + rows, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = "16a34a"
        row(0).text_color = "FFFFFF"
        cells.borders = [:top, :bottom, :left, :right]
        cells.border_color = "DDDDDD"
        cells.padding = [6, 8, 6, 8]
        rows(1..-1).each_with_index do |row, i|
          row.background_color = i.even? ? "F0FDF4" : "FFFFFF"
        end
      end
    end
  end
end
