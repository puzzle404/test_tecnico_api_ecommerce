class AddValidTokenToAdministrators < ActiveRecord::Migration
  def change
    add_column :administrators, :valid_token, :string, default: nil
  end
end
