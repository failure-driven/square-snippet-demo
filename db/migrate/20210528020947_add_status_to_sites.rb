class AddStatusToSites < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE site_status AS ENUM ('active', 'deleted');
    SQL
    add_column :sites, :status, :site_status, null: false
    add_index :sites, :status
  end

  def down
    remove_column :sites, :status
    execute <<-SQL
      DROP TYPE site_status;
    SQL
  end
end
