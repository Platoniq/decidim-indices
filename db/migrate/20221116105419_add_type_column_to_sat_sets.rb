class AddTypeColumnToSatSets < ActiveRecord::Migration[6.0]
  def change
    add_column :indices_sat_sets, :type, :string
  end
end
