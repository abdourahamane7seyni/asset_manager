class MaterielsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_materiel, only: %i[ show edit update destroy qrcode ]

  def index
    @materiels = Materiel.all
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="materiels.xlsx"'
      end
      format.pdf do
        pdf = generate_pdf(@materiels)
        send_data pdf.render, filename: "materiels.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def show; end

  def new
    @materiel = Materiel.new
  end

  def edit; end

  def create
    @materiel = Materiel.new(materiel_params)
    if @materiel.save
      redirect_to @materiel, notice: "Matériel créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @materiel.update(materiel_params)
      redirect_to @materiel, notice: "Matériel mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @materiel.destroy
    redirect_to materiels_path, notice: "Matériel supprimé avec succès."
  end

  def qrcode
    qrcode = RQRCode::QRCode.new(materiel_url(@materiel))
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    )
    send_data svg, type: "image/svg+xml", disposition: "inline"
  end

  private

  def set_materiel
    @materiel = Materiel.find(params[:id])
  end

  def materiel_params
    params.require(:materiel).permit(:nom, :type_materiel, :marque, :modele, :numero_serie, :statut, :date_achat, :expiration_garantie, :assigne_a, :localisation, :notes)
  end

  def generate_pdf(materiels)
    Prawn::Document.new(page_size: "A4", page_layout: :landscape) do |pdf|
      pdf.font_size 18
      pdf.text "Liste des Matériels", style: :bold, align: :center
      pdf.text "Généré le #{Date.today.strftime('%d/%m/%Y')}", size: 10, align: :center, color: "888888"
      pdf.move_down 20

      headers = ["Nom", "Type", "Marque", "Modèle", "N° Série", "Statut", "Assigné à", "Garantie"]
      rows = materiels.map do |m|
        [
          m.nom.to_s,
          m.type_materiel.to_s,
          m.marque.to_s,
          m.modele.to_s,
          m.numero_serie.to_s,
          m.statut.to_s,
          m.assigne_a.to_s,
          m.expiration_garantie&.strftime("%d/%m/%Y").to_s
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
          row.background_color = i.even? ? "F8F9FA" : "FFFFFF"
        end
      end
    end
  end
end
