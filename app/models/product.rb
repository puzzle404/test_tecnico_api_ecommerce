class Product < ActiveRecord::Base
  attr_accessible :administrator_id, :description, :name, :price, :stock
  belongs_to :administrator
  has_and_belongs_to_many :categories
  has_many :purchases
  has_many :images
  has_many :audit_logs, as: :auditable

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Registrar la creación y las actualizaciones
  after_create :log_creation
  after_update :log_update

  def self.most_purchased_by_category(category)
    category.products.joins(:purchases)
                    .select('products.*, COUNT(purchases.id) as purchases_count')
                    .group('products.id')
                    .order('purchases_count DESC')
  end

  # Método para obtener los productos con mayor recaudación de una categoría
  def self.top_revenue_by_category(category, limit = 3)
    category.products.joins(:purchases)
                    .select('products.*, SUM(purchases.total_price) as total_revenue')
                    .group('products.id')
                    .order('total_revenue DESC')
                    .limit(limit)
  end

  def log_creation
    AuditLog.create!(
      auditable: self,
      admin_id: self.administrator_id,
      action: 'create',
      change_log: self.attributes.to_s
    )
  end

  # Método para registrar actualizaciones
  def log_update
    # Solo crea un registro si hubo cambios
    if self.changed?
      AuditLog.create!(
        auditable: self,
        admin_id: self.administrator_id, # Suponiendo que se pasa el admin actual
        action: 'update',
        change_log: self.changes.to_s # Guarda solo los cambios
      )
    end
  end
end
