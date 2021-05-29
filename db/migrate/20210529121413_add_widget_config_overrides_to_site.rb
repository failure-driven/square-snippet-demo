class AddWidgetConfigOverridesToSite < ActiveRecord::Migration[6.1]
  def change
    add_column :sites, :widget_config_overrides, :jsonb
  end
end
