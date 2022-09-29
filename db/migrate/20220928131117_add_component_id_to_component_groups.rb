class AddComponentIdToComponentGroups < ActiveRecord::Migration[6.0]
  def change
    add_reference :indices_component_groups, :decidim_component
  end
end
