# app/workers/daily_purchase_report_worker.rb
class DailyPurchaseReportWorker
  include Sidekiq::Worker  # Usa Sidekiq::Worker en lugar de ApplicationJob

  def perform
    # Lógica de generación de reporte
    start_date = 1.day.ago.beginning_of_day
    end_date = 1.day.ago.end_of_day
    purchases = Purchase.where(purchase_date: start_date..end_date)

    # Agrupamos las compras por producto
    report_data = purchases.group_by(&:product_id).map do |product_id, purchases|
      {
        product: Product.find(product_id).name,
        total_purchases: purchases.size
      }
    end
    Rails.logger.debug "Report Data desde purchase reporte mailer #{report_data}"
    # Enviamos el reporte a cada admin
    Administrator.first.each do |admin|
      PurchaseReportMailer.daily_report(admin, report_data).deliver
    end
  end
end
