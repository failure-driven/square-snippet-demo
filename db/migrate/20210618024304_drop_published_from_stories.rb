class DropPublishedFromStories < ActiveRecord::Migration[6.1]
  def change
    remove_column :stories, :published # rubocop:disable Rails/ReversibleMigration
  end
end
