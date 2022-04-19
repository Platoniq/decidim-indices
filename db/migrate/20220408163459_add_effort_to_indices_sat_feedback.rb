class AddEffortToIndicesSatFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :indices_sat_feedbacks, :effort, :integer, default: 0
  end
end
