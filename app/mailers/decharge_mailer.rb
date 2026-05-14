class DechargeMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def envoyer_decharge(decharge)
    @decharge = decharge
    @employee = decharge.employee
    @materiels = @employee.movements.where(action: "Assignation").order(date: :desc)

    mail(
      to: @employee.email,
      subject: "Décharge de matériel informatique - #{@employee.first_name} #{@employee.last_name}"
    )
  end
end
