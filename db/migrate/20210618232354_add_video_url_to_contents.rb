class AddVideoUrlToContents < ActiveRecord::Migration[6.1]
  def change
    add_column :contents, :video_url, :string
  end
end
