class AddPublishedToContents < ActiveRecord::Migration[6.1]
  def change
    add_column :contents, :published, :boolean, default: false
  end
end
