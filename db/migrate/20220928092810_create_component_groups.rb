class CreateComponentGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :indices_component_groups do |t|
      t.jsonb :name
      t.jsonb :description
      t.integer :weight, default: 0

      t.timestamps
    end
  end
end
