class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites, id: :uuid do |t|
      t.string :reference_id, null: false, index: { unique: true }
      t.string :site_title, null: false
      t.string :domain
      t.boolean :is_published
      t.references :identity, foreign_key: true, null: false, type: :uuid
      t.datetime :site_created_at
      t.datetime :site_updated_at

      t.timestamps
    end
  end
end
