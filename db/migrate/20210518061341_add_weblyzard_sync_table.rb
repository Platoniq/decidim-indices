class AddWeblyzardSyncTable < ActiveRecord::Migration[5.2]
  def change
    create_table :indices_weblyzard_log do |t|
      t.string :uid, index: true, null: false
      t.string :keywords
      t.string :title
      t.text :content
      t.string :uri
      t.jsonb :metadata
      t.jsonb :features
      t.jsonb :relations
      t.boolean :active, default: true
      t.jsonb :defaults
      t.references :resource, polymorphic: true, index: false
      t.timestamps
    end

    add_index :indices_weblyzard_log,
            [:uid, :resource_id, :resource_type],
            name: "index_on_resource_and_uid"
  end
end
