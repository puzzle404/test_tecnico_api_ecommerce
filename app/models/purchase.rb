class Purchase < ActiveRecord::Base
  attr_accessible :customer_id, :product_id, :purchase_date, :quantity, :total_price
  belongs_to :customer
  belongs_to :product
  belongs_to :administrator

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  after_create :check_and_send_first_purchase_email, unless: -> { ENV['DISABLE_CALLBACKS_FOR_SEEDS'] == 'true' }

  scope :by_date_range, ->(start_date, end_date) {
    where(purchase_date: Date.parse(start_date).beginning_of_day..Date.parse(end_date).end_of_day) if start_date && end_date
  }

  scope :by_category, ->(category_id) {
    joins(product: :categories).where('categories_products.category_id = ?', category_id) if category_id
  }

  scope :by_customer, ->(customer_id) {
    where(customer_id: customer_id) if customer_id
  }

  scope :by_administrator, ->(administrator_id) {
    joins(product: :administrator).where(products: { administrator_id: administrator_id }) if administrator_id
  }

  scope :group_by_granularity, ->(granularity) {
    case granularity
    when 'hour'
      group("DATE_TRUNC('hour', purchase_date)")
    when 'day'
      group("DATE_TRUNC('day', purchase_date)")
    when 'week'
      group("DATE_TRUNC('week', purchase_date)")
    when 'year'
      group("DATE_TRUNC('year', purchase_date)")
    else
      raise ArgumentError, 'Invalid granularity parameter'
    end
  }


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
