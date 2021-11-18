class CreateIndicesSatFeedbacksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :indices_sat_feedbacks do |t|
      t.jsonb :title
      t.jsonb :description
      t.jsonb :hashtags
      t.references :sat_set, foreign_key: { to_table: :indices_sat_sets }
      t.timestamps
    end
  end
end
