class Purchase < ActiveRecord::Base
  attr_accessible :customer_id, :product_id, :purchase_date, :quantity, :total_price
  belongs_to :customer
  belongs_to :product
  belongs_to :administrator

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  after_create :check_and_send_first_purchase_email, unless: -> { ENV['DISABLE_CALLBACKS_FOR_SEEDS'] == 'true' }

  private

  def check_and_send_first_purchase_email
    # Usa una transacción para asegurar la condición de carrera
    Purchase.transaction do
      if first_purchase?
        send_first_purchase_email
      end
    end
  end

  def first_purchase?
    # Verifica si esta es la primera compra del producto dentro de la transacción
    Purchase.where(product_id: product_id).count == 1
  end

  def send_first_purchase_email
    # Envía el correo al creador del producto y en copia a los demás administradores
    FirstPurchaseMailer.notify_admins(product).deliver
  end
end
