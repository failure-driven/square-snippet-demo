class DropPublishedFromStories < ActiveRecord::Migration[6.1]
  def change
    remove_column :stories, :published
  end
end
