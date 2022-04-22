class AddLinkUrlAndLinkLabelToSatFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :indices_sat_feedbacks, :link_label, :jsonb
    add_column :indices_sat_feedbacks, :link_uri, :string
  end
end
