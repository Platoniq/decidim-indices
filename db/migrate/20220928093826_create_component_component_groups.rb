class CreateComponentComponentGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :indices_component_component_groups do |t|
      t.references :decidim_component, index: {name: "indices_c_cg_component"}
      t.references :indices_component_group, index: {name: "indices_c_cg_component_group"}
      t.integer :weight, default: 0

      t.timestamps
    end
  end
end
