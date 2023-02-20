# frozen_string_literal: true

class CreateSurveySections < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_survey_sections do |t|
      t.jsonb :title
      t.jsonb :description
      t.integer :weight, default: 0
      t.timestamps
      t.references :decidim_survey_sections_group, index: { name: "decidim_ss_ss_group" }
    end
  end
end
