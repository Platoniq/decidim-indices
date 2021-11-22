class CreateIndicesSatSetTable < ActiveRecord::Migration[5.2]
  def change
    create_table :indices_sat_sets do |t|
      t.string :name, null: false
      t.references :organization, foreign_key: { to_table: :decidim_organizations }
      t.references :questionnaire, foreign_key: { to_table: :decidim_forms_questionnaires }
      t.timestamps

      t.index [:organization_id, :questionnaire_id], unique: true
    end
  end
end
