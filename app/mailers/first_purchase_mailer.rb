class FirstPurchaseMailer < ActionMailer::Base
  default from: 'cmanuferrer@gmail.com'

  def notify_admins(product)
    @product = product
    @creator = product.administrator
    @administrators = Administrator.where("id != ?", @creator.id)
    @purchase = product.purchases.first

    mail(
      to: @creator.email,
      cc: @administrators.map(&:email),
      subject: "Primera compra de #{product.name}"
    )
  end
end
