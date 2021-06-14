class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents, id: :uuid do |t|
      t.references :story, null: false, foreign_key: true, type: :uuid
      t.string :content_title, null: false
      t.string :description, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
