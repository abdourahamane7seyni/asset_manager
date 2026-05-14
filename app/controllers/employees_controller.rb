class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee, only: %i[ show edit update destroy decharge envoyer_decharge update_statut_decharge ]

  def index
    @employees = Employee.all
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="employes.xlsx"'
      end
      format.pdf do
        pdf = generate_pdf_employees(@employees)
        send_data pdf.render, filename: "employes.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  def show
    @decharges = @employee.decharges.order(date_emission: :desc)
  end

  def new; @employee = Employee.new; end
  def edit; end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Employé créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: "Employé mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Employé supprimé avec succès."
  end

  def decharge
    materiels = @employee.movements.where(action: "Assignation").order(date: :desc)
    @decharge = @employee.decharges.create!(
      statut: "En attente de signature",
      date_emission: Date.today
    )
    pdf = generer_pdf(@employee, materiels, @decharge)
    send_data pdf.render,
      filename: "decharge_#{@employee.first_name}_#{@employee.last_name}_#{Date.today}.pdf",
      type: "application/pdf",
      disposition: "attachment"
  end

  def envoyer_decharge
    materiels = @employee.movements.where(action: "Assignation").order(date: :desc)
    @decharge = @employee.decharges.create!(
      statut: "En attente de signature",
      date_emission: Date.today
    )
    DechargeMailer.envoyer_decharge(@decharge).deliver_now
    redirect_to @employee, notice: "Décharge envoyée par email à #{@employee.email} !"
  end

  def update_statut_decharge
    @decharge = Decharge.find(params[:decharge_id])
    @decharge.update(
      statut: params[:statut],
      date_signature: params[:statut] == "Signé" ? Date.today : nil
    )
    redirect_to @employee, notice: "Statut de la décharge mis à jour !"
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :email, :department, :phone)
  end

  def generate_pdf_employees(employees)
    Prawn::Document.new(page_size: "A4", page_layout: :landscape) do |pdf|
      pdf.fill_color "16a34a"
      pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 60
      pdf.fill_color "000000"
      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: 60) do
        pdf.move_down 15
        pdf.text "LISTE DES EMPLOYÉS", size: 18, style: :bold, color: "FFFFFF", align: :center
        pdf.text "Généré le #{Date.today.strftime('%d/%m/%Y')}", size: 10, color: "FFFFFF", align: :center
      end
      pdf.move_down 20

      headers = ["Prénom", "Nom", "Email", "Département", "Téléphone", "Matériels assignés"]
      rows = employees.map do |e|
        [
          e.first_name.to_s,
          e.last_name.to_s,
          e.email.to_s,
          e.department.to_s,
          e.phone.to_s,
          e.movements.where(action: "Assignation").count.to_s
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

  def generer_pdf(employee, materiels, decharge)
    Prawn::Document.new(page_size: "A4") do |pdf|
      pdf.fill_color "16a34a"
      pdf.fill_rectangle [0, pdf.cursor], pdf.bounds.width, 80
      pdf.fill_color "000000"
      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width, height: 80) do
        pdf.move_down 20
        pdf.text "DÉCHARGE DE MATÉRIEL INFORMATIQUE", size: 16, style: :bold, color: "FFFFFF", align: :center
        pdf.text "Asset Manager", size: 10, color: "FFFFFF", align: :center
      end
      pdf.move_down 20
      pdf.text "Nom : #{employee.first_name} #{employee.last_name}", size: 11, style: :bold
      pdf.text "Département : #{employee.department}", size: 10
      pdf.text "Email : #{employee.email}", size: 10
      pdf.move_down 10
      pdf.text "Date : #{decharge.date_emission&.strftime('%d/%m/%Y')}    Réf : DECH-#{employee.id}-#{Date.today.strftime('%Y%m%d')}", size: 9, color: "666666"
      pdf.move_down 15
      pdf.text "Je soussigné(e), #{employee.first_name} #{employee.last_name}, reconnais avoir reçu les matériels suivants en bon état.", size: 10, align: :justify
      pdf.move_down 15
      pdf.text "MATÉRIELS ASSIGNÉS", size: 11, style: :bold, color: "16a34a"
      pdf.move_down 8
      if materiels.any?
        headers = ["#", "Nom", "Type", "Marque/Modèle", "N° Série", "Date"]
        rows = materiels.each_with_index.map do |m, i|
          [(i+1).to_s, m.materiel&.nom.to_s, m.materiel&.type_materiel.to_s, "#{m.materiel&.marque} #{m.materiel&.modele}", m.materiel&.numero_serie.to_s, m.date&.strftime("%d/%m/%Y").to_s]
        end
        pdf.table([headers] + rows, header: true, width: pdf.bounds.width, cell_style: { size: 9 }) do
          row(0).font_style = :bold
          row(0).background_color = "16a34a"
          row(0).text_color = "FFFFFF"
          cells.borders = [:top, :bottom, :left, :right]
          cells.border_color = "DDDDDD"
          cells.padding = [5, 6, 5, 6]
        end
      end
      pdf.move_down 40
      pdf.bounding_box([0, pdf.cursor], width: pdf.bounds.width / 2 - 20) do
        pdf.text "L'employé", size: 10, style: :bold
        pdf.move_down 40
        pdf.stroke_horizontal_rule
        pdf.text "Signature et date", size: 8, color: "999999"
      end
      pdf.bounding_box([pdf.bounds.width / 2 + 20, pdf.cursor + 55], width: pdf.bounds.width / 2 - 20) do
        pdf.text "Le responsable", size: 10, style: :bold
        pdf.move_down 40
        pdf.stroke_horizontal_rule
        pdf.text "Signature et date", size: 8, color: "999999"
      end
    end
  end
end
