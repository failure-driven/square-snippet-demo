class AddIsActiveToIdentity < ActiveRecord::Migration[6.1]
  def change
    add_column :identities, :is_active, :boolean, default: true
  end
end
