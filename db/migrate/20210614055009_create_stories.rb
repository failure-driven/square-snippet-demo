class CreateStories < ActiveRecord::Migration[6.1]
  def change
    create_table :stories, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :site, null: false, foreign_key: true, type: :uuid
      t.string :story_title, null: false
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
