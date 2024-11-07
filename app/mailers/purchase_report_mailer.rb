# app/mailers/purchase_report_mailer.rb
class PurchaseReportMailer < ActionMailer::Base
  default from: 'cmanuferrer@gmail.com'
  default charset: 'UTF-8'

  def daily_report(admin, report_data)
    @admin = admin
    @report_data = report_data
    Rails.logger.debug "Report Data desde purchase reporte mailer #{@report_data}"
    mail(to: @admin.email, subject: 'Reporte Diario de Compras2')
  end
end
