# frozen_string_literal: true

class CreateDecidimMultisurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_multisurveys_multisurveys do |t|
      t.references :decidim_component, index: { name: "index_decidim_multisurveys_on_decidim_component_id" }
      t.timestamps
    end
  end
end
