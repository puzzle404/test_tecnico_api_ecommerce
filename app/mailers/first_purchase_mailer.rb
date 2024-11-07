class FirstPurchaseMailer < ActionMailer::Base
  default from: 'cmanuferrer@gmail.com'

  def notify_admins(product)
    Rails.logger.error "PRODUCTO #{product.name} no tiene un administrador."
    @product = product
    @creator = product.administrator
    @administrators = Administrator.where("id != ?", @creator.id)
    @purchase = product.purchases.first
    Rails.logger.error "PRODUCTO #{@product.name}"
    Rails.logger.error "PRODUCTO #{@product.name}"

    mail(
      to: @creator.email,
      subject: "Primera compra de #{product.name}"
    )
  end
end
