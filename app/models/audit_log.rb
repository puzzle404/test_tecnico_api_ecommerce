class AuditLog < ActiveRecord::Base
  attr_accessible :auditable, :auditable_id, :auditable_type, :admin_id, :action, :change_log
  belongs_to :auditable, polymorphic: true
  belongs_to :admin, class_name: 'Administrator' # Asociación con el administrador
end
