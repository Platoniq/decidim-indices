# This migration comes from decidim_survey_sections_group (originally 20221026073800)
class CreateSurveyGroup < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_survey_groups do |t|
      t.references :survey, index: {name: "decidim_ss_survey"}
      t.references :decidim_survey_section, index: {name: "decidim_ss_survey_section"}
      t.integer :weight, default: 0
      t.timestamps
    end
  end
end
