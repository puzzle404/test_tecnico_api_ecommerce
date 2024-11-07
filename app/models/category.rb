class Category < ActiveRecord::Base
  attr_accessible :administrator_id, :description, :name
  belongs_to :administrator
  has_and_belongs_to_many :products
  has_many :audit_logs, as: :auditable

  validates :name, presence: true, uniqueness: true
  validates :administrator_id, presence: true

  # Registrar la creación y las actualizaciones
  after_create :log_creation
  after_update :log_update

  def log_creation
    AuditLog.create!(
      auditable: self,
      admin_id: self.administrator_id, # Asegúrate de que `administrator_id` esté presente al crear
      action: 'create',
      change_log: self.attributes.to_s # Guarda los atributos iniciales (en texto)
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
