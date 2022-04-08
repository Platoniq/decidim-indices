class AddSubtitleToIndicesSatFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :indices_sat_feedbacks, :subtitle, :jsonb
  end
end
