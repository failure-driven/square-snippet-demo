class AddVisitCountToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :visit_count, :integer, null: false, default: 0
  end
end
