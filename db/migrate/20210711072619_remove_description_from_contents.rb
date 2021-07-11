class RemoveDescriptionFromContents < ActiveRecord::Migration[6.1]
  def change
    remove_column :contents, :description
  end
end
