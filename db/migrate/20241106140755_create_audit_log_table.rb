class CreateAuditLogTable < ActiveRecord::Migration
  def change
    create_table :audit_logs do |t|
      t.integer :auditable_id, null: false # ID del recurso auditado
      t.string :auditable_type, null: false # Tipo de recurso auditado (Product o Category)
      t.integer :admin_id, null: false # ID del administrador que realizó el cambio
      t.string :action, null: false # Acción realizada (create, update, delete)
      t.text :change_log  # Cambios realizados (guardados como texto o JSON)
      t.timestamps
    end

    add_index :audit_logs, [:auditable_type, :auditable_id]
    add_index :audit_logs, :admin_id
  end
end
