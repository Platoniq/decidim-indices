# frozen_string_literal: true

module Indices
  # The data store for the self assessment tool set
  class SatFeedback < ApplicationRecord
    self.table_name = "indices_sat_feedbacks"

    belongs_to :sat_set,
               class_name: "Indices::SatSet"
  end
end
